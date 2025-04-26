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
  var actions: ActionInterceptions = .init()
  
  @_spi(Extensions)
  public var localThrowCatch: (@Sendable (any Error, DiscordModels.Interaction) async throws -> Void)?
  
  @_spi(Extensions)
  public nonisolated(unsafe) var id: (any Hashable)?
  
  @_spi(Extensions)
  public var modalReceives: [String: [@Sendable (InteractionExtras) async throws -> Void]] = [:]
  @_spi(Extensions) public var componentReceives: [String: [@Sendable (InteractionExtras) async throws -> Void]] = [:]
  
  // autocompletion related things
	public func autocompletion(_ i: Interaction, cmd: Interaction.ApplicationCommand, opt: Interaction.ApplicationCommand.Option, client: DiscordClient) async {
    guard opt.value != nil else { return } /// no point doing work if no value is present to derive autocompletions from
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
  @_spi(Extensions)
  public var baseInfo: Payloads.ApplicationCommandCreate
  @_spi(Extensions)
  public var guildScope: CommandGuildScope = .init(scope: .global, guilds: [])

  @_spi(Extensions)
  public func trigger(_ i: Interaction, _ instance: BotInstance) async throws {
    let e = InteractionExtras(instance, i)
    do {
      try await preAction(e)
      try await action(e)
      try await postAction(e)
    } catch {
      if let localThrowCatch { try await localThrowCatch(error, i) }
        // run error actions in order
      for errorAction in self.actions.errorActions {
        try? await errorAction(error, self, e)
      }
      if localThrowCatch == nil { throw error }
    }
  }
  
  // we let the user define action, but we control the before and after actions.
  // we internally execute proxyAction which executes before, user-def and after actions.
  var action: @Sendable (InteractionExtras) async throws -> Void
  
  public init(_ commandName: String, action: @Sendable @escaping (InteractionExtras) async throws -> Void) {
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
  
  func preAction(_ e: InteractionExtras) async throws {
    // do things like sending defer, processing, idk
    
    // run preActions in order
    for preAction in self.actions.preActions {
      try await preAction(self, e)
    }
  }
  func postAction(_ e: InteractionExtras) async throws {
    // idk maybe register something internally, just here for completeness
    
    // run postActions in order
    for postAction in self.actions.postActions {
      try await postAction(self, e)
    }
  }
}
