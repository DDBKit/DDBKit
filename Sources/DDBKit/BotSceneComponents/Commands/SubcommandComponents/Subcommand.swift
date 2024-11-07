//
//  Subcommand.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 07/10/2024.
//

import DiscordBM

/// A subcommand to a base or group
public struct Subcommand: BaseInfoType, LocalisedThrowable {
  public var localThrowCatch: ((any Error, DiscordModels.Interaction) async throws -> Void)?
  
  var options: [Option] = []
  var baseInfo: ApplicationCommand.Option
  var action: (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async throws -> Void
  
  func trigger(
    _ i: Interaction,
    _ j: Interaction.ApplicationCommand,
    _ cmd: BaseContextCommand,
    _ c: GatewayManager,
    _ ch: DiscordCache,
    _ errorActions: [(any Error, BaseContextCommand, any DiscordGateway.GatewayManager, DiscordGateway.DiscordCache, Interaction, DatabaseBranches) async throws -> Void]
  ) async throws {
    do {
      try await action(i, j, .init(i))
    } catch {
      if let localThrowCatch { try await localThrowCatch(error, i) }
        // run error actions in order
      for errorAction in errorActions {
        try? await errorAction(error, cmd, c, ch, i, .init(i))
      }
      if localThrowCatch == nil { throw error }
    }
  }
  
  public init(_ name: String, action: @escaping (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async throws -> Void) {
    self.action = action
    
    self.baseInfo = .init(
      type: .subCommand,
      name: name,
      name_localizations: nil,
      description: "This subcommand has no description.",
      description_localizations: nil,
      options: []
    )
  }
  
  
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
}
