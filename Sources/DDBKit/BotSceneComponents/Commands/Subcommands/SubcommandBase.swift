//
//  SubcommandBase.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 07/10/2024.
//

import DiscordBM

public struct SubcommandBase: BaseCommand {
  var guildScope: CommandGuildScope = .init(scope: .global, guilds: [])
  
  var baseInfo: DiscordModels.Payloads.ApplicationCommandCreate
  
  var tree: [BaseInfoType]
  
  // this is called when a command under this base is called
  func trigger(_ i: DiscordModels.Interaction) async {
    // do preprocessing work to find where which closure requires calling in the registered subcommands
    switch i.data {
    case .applicationCommand(let j):
      let k: DatabaseBranches = .init(i)
      let command = self.findChild(i)
      await command?.trigger(i, j, k)
    default: break
    }
  }
  
  func autocompletion(_ i: DiscordModels.Interaction, cmd: DiscordModels.Interaction.ApplicationCommand, opt: DiscordModels.Interaction.ApplicationCommand.Option, client: any DiscordHTTP.DiscordClient) async {
    // same as trigger
    guard let command = self.findChild(i) else { return print("[\(self.baseInfo.name)] Autocompletion was called and no handler found for option path.") }
    await command.autocompletion(i, cmd: cmd, opt: opt, client: client)
  }
  
  public init(_ name: String, @SubcommandBaseBuilder _ tree: () -> [SubcommandBaseTypes]) {
    
    self.baseInfo = .init(
      name: name,
      description: "This command group has no description."
    )
    self.tree = tree() as! [BaseInfoType]
    
    self.baseInfo.options = []
    
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
}

extension SubcommandBase {
  func findChild(_ i: Interaction) -> Subcommand? {
    let options: [Interaction.ApplicationCommand.Option]? = {
      switch i.data {
      case .applicationCommand(let applicationCommand):
        return applicationCommand.options
      default: return nil
      }
    }()
    guard let options, !options.isEmpty else { print("[\(self.baseInfo.name)] SubcommandBase triggered with no options, skipped eval."); return nil } // options in this command cannot be empty, its literally impossible
    
    var currentOption = options.first!
    var currentObject: (any BaseInfoType)?
    currentObject = self.tree.first { obj in
      obj.baseInfo.name == currentOption.name
    }
    
    // in case of nesting
    if currentOption.options?.first?.type == .subCommand {
      currentOption = currentOption.options!.first!
      if let obj = (currentObject as? SubcommandGroup)?.commands.first(where: { cmd in
        cmd.baseInfo.name == currentOption.name
      }) {
        currentObject = obj
      }
    }
    
    guard let subcommand = currentObject as? Subcommand else { print("[\(self.baseInfo.name)] SubcommandBase triggered and failed to find subcommand."); return nil }
    return subcommand
  }
}
