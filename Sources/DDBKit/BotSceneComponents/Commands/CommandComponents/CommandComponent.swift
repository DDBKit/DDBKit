//
//  BotCommandComponent.swift
//  
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation
import RegexBuilder
@_spi(UserInstallableApps) import DiscordBM

/// A basic command thats easy and fast to declare and program
public struct Command: BaseCommand, _ExtensibleCommand, IdentifiableCommand, LocalisedThrowable {
  
  @_spi(Extensions)
  public var localThrowCatch: ((any Error, DiscordModels.Interaction) async throws -> Void)?
  
  @_spi(Extensions)
  public var id: (any Hashable)?
  
  public var preActions: [(CommandDescription, any DiscordGateway.GatewayManager, DiscordGateway.DiscordCache, Interaction, DatabaseBranches) async throws -> Void] = []
  public var postActions: [(CommandDescription, any DiscordGateway.GatewayManager, DiscordGateway.DiscordCache, Interaction, DatabaseBranches) async throws -> Void] = []
  
  public var modalReceives: [String: [(Interaction, Interaction.ModalSubmit, DatabaseBranches) async throws -> Void]] = [:]
  public var componentReceives: [String: [(Interaction, Interaction.MessageComponent, DatabaseBranches) async throws -> Void]] = [:]
  
  // autocompletion related things
  func autocompletion(_ i: Interaction, cmd: Interaction.ApplicationCommand, opt: Interaction.ApplicationCommand.Option, client: DiscordClient) async {
    guard let _ = opt.value else { return } /// no point doing work if no value is present to derive autocompletions from
    // find autocompletable options
    let autocompletableOptions = self.options.compactMap { $0 as? _AutocompletableOption }
    
    // find applicable option in autocompletable options
    let option = autocompletableOptions.first(where: {$0.optionData.name == opt.name})
    // run autocompletions callback
    
    let autocompletionsValues = await option?.autocompletion?(opt, cmd)
    
    // return these choices
    _ = try? await client.createInteractionResponse(id: i.id, token: i.token, payload: .autocompleteResult(.init(choices: autocompletionsValues ?? [])))
  }
  
  var options: [Option] = []
  
  // command data
  public var baseInfo: Payloads.ApplicationCommandCreate
  public var guildScope: CommandGuildScope = .init(scope: .global, guilds: [])

  public func trigger(_ i: Interaction, _ c: GatewayManager, _ ch: DiscordCache) async throws {
    switch i.data {
    case .applicationCommand(let j):
      let k: DatabaseBranches = .init(i)
      do {
        try await preAction(i, c, ch)
        try await action(i, j, k)
        try await postAction(i, c, ch)
      } catch {
        if let localThrowCatch { try await localThrowCatch(error, i) }
        else { throw error }
      }
    default: break
    }
  }
  
  // we let the user define action, but we control the before and after actions.
  // we internally execute proxyAction which executes before, user-def and after actions.
  var action: (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async throws -> Void
  
  public init(_ commandName: String, action: @escaping (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async throws -> Void) {
    let name = commandName.trimmingCharacters(in: .whitespacesAndNewlines)
    self.action = action
    self.baseInfo = .init(
      name: commandName,
      description: "This command has no description."
    )
    
    self.baseInfo.integration_types = [.guildInstall]
    self.baseInfo.contexts = [.guild]
    
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
