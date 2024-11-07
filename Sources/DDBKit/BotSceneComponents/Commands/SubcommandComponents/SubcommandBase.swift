//
//  SubcommandBase.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 07/10/2024.
//

@_spi(UserInstallableApps) import DiscordBM

public struct SubcommandBase: BaseCommand, _ExtensibleCommand {  
  var preActions: [(CommandDescription, any DiscordGateway.GatewayManager, DiscordGateway.DiscordCache, Interaction, DatabaseBranches) async throws -> Void] = []
  var postActions: [(CommandDescription, any DiscordGateway.GatewayManager, DiscordGateway.DiscordCache, Interaction, DatabaseBranches) async throws -> Void] = []
  
  public var modalReceives: [String: [(Interaction, Interaction.ModalSubmit, DatabaseBranches) async throws -> Void]] = [:]
  public var componentReceives: [String: [(Interaction, Interaction.MessageComponent, DatabaseBranches) async throws -> Void]] = [:]
  
  public var guildScope: CommandGuildScope = .init(scope: .global, guilds: [])
  
  public var baseInfo: Payloads.ApplicationCommandCreate
  
  var tree: [BaseInfoType]
  
  // this is called when a command under this base is called
  public func trigger(_ i: Interaction, _ c: GatewayManager, _ ch: DiscordCache) async throws {
    // do preprocessing work to find where which closure requires calling in the registered subcommands
    switch i.data {
    case .applicationCommand(var j):
      guard let (command, options) = try? self.findChild(i) else { return }
      j.options = options ?? j.options
      try await self.preAction(i, c, ch)
      try await command.trigger(i, j)
      try await self.postAction(i, c, ch)
    default: break
    }
  }
  
  func autocompletion(_ i: Interaction, cmd: Interaction.ApplicationCommand, opt: Interaction.ApplicationCommand.Option, client: any DiscordClient) async {
    /// same as trigger, we dont use the pruned options from findChild(:) since BotInstance recursively tracks the option with focused set to true.
    guard let (command, _) = try? self.findChild(i) else { return print("[\(self.baseInfo.name)] Autocompletion was called and no handler found for option path.") }
    await command.autocompletion(i, cmd: cmd, opt: opt, client: client)
  }
  
  public init(_ name: String, @SubcommandBaseBuilder _ tree: () -> [SubcommandBaseTypes]) {
    
    self.baseInfo = .init(
      name: name,
      description: "This command group has no description."
    )
    self.tree = (tree() as! [BaseInfoType])
    
    self.baseInfo.options = []
    
    self.baseInfo.integration_types = [.guildInstall]
    self.baseInfo.contexts = [.guild]
    
    self.tree = self.tree.reduce([], { partialResult, type in
      var p = partialResult
      p += {
        var type = type
        if var group = type as? SubcommandGroup {
          group.detail = .init(info: self.baseInfo, scope: self.guildScope)
          group.detail.info.name = "\(group.detail.info.name) \(group.baseInfo.name)"
          type = group
        }
        if var cmd = type as? Subcommand {
          cmd.detail = .init(info: self.baseInfo, scope: self.guildScope)
          cmd.detail.info.name = "\(cmd.detail.info.name) \(cmd.baseInfo.name)"
          type = cmd
        }
        return [type]
      }()
      return p
    })
        
    for object in self.tree {
      // begin by finding subcommands and registering them, or finding groups and registering them with their subcommands
      
      // command
      if let cmd = object as? Subcommand {
        self.baseInfo.options?.append(cmd.baseInfo)
      }
      // group
      if let group = object as? SubcommandGroup {
        self.baseInfo.options?.append(group.baseInfo)
      }
    }
    
    let valid = self.baseInfo.validate()
    if !valid.isEmpty {
      preconditionFailure("[\(name)] Failed validation\n\n\(valid)")
    }
  }
  
  // MARK: - These pre and post actions are for use internally
  
  func preAction(_ i: Interaction, _ c: GatewayManager, _ ch: DiscordCache) async throws {
    // do things like sending defer, processing, idk
    
    // run preActions in order
    for preAction in self.preActions {
      try await preAction(
        .init(info: self.baseInfo, scope: self.guildScope),
        c, ch, i,
        .init(i)
      )
    }
  }
  func postAction(_ i: Interaction, _ c: GatewayManager, _ ch: DiscordCache) async throws {
    // idk maybe register something internally, just here for completeness
    
    // run postActions in order
    for postAction in self.postActions {
      try await postAction(
        .init(info: self.baseInfo, scope: self.guildScope),
        c, ch, i,
        .init(i)
      )
    }
  }
}

extension SubcommandBase {
  func findChild(_ i: Interaction) throws -> (Subcommand,  [Interaction.ApplicationCommand.Option]?) {
    // get the options tree from the interaction
    let options: [Interaction.ApplicationCommand.Option]? = {
      switch i.data {
      case .applicationCommand(let applicationCommand):
        return applicationCommand.options
      default: return nil
      }
    }()
    // ensure the options exist before we continue
    guard let options, !options.isEmpty else { print("[\(self.baseInfo.name)] SubcommandBase triggered with no options, skipped eval."); throw SubcommandError.noOptions } // options in this command cannot be empty, its literally impossible
    // this is a variable to store the pruned tree
    var optionsTree: [Interaction.ApplicationCommand.Option]? = nil

    // currentOption is the root option in the tree (the subcommand or subcommandgroup layer
    var currentOption = options.first!
    var currentObject: (any BaseInfoType)?
    // tree contains all the subcommands available
    currentObject = self.tree.first { obj in
      if obj.baseInfo.name == currentOption.name {
        optionsTree = currentOption.options
        return true
      }
      return false
    }
    
    // in case of nesting
    if currentOption.options?.first?.type == .subCommand {
      currentOption = currentOption.options!.first!
      if let obj = (currentObject as? SubcommandGroup)?.commands.first(where: { cmd in
        if cmd.baseInfo.name == currentOption.name {
          optionsTree = currentOption.options
          return true
        }
        return false
      }) {
        currentObject = obj
      }
    }
    
    guard let subcommand = currentObject as? Subcommand else { print("[\(self.baseInfo.name)] SubcommandBase triggered and failed to find subcommand."); throw SubcommandError.noChildFound }
    return (subcommand, optionsTree)
  }
  
  enum SubcommandError: Error {
    case noOptions
    case noChildFound
  }
}
