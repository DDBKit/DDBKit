//
//  Subcommand.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 07/10/2024.
//

import DiscordBM

/// A subcommand to a base or group
public struct Subcommand: BaseInfoType, _ExtensibleCommand, IdentifiableCommand, LocalisedThrowable {
  public var localThrowCatch: ((any Error, DiscordModels.Interaction) async throws -> Void)?
  
  var preActions: [(CommandDescription, any DiscordGateway.GatewayManager, DiscordGateway.DiscordCache, Interaction, DatabaseBranches) async throws -> Void] = []
  var postActions: [(CommandDescription, any DiscordGateway.GatewayManager, DiscordGateway.DiscordCache, Interaction, DatabaseBranches) async throws -> Void] = []
  
  @_spi(Extensions)
  public var id: (any Hashable)?

  var options: [Option] = []
  var baseInfo: ApplicationCommand.Option
  var action: (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async throws -> Void
  
  var detail: CommandDescription!
  
  func action(_ i: Interaction, _ j: Interaction.ApplicationCommand, _ k: DatabaseBranches) async throws {
    do {
      try await preAction(i)
      try await action(i, j, k)
      try await postAction(i)
    } catch {
      if let localThrowCatch { try await localThrowCatch(error, i) }
      else { throw error }
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
  
  // MARK: - These pre and post actions are for use internally
  
  func preAction(_ interaction: Interaction) async throws {
    // do things like sending defer, processing, idk
  }
  func postAction(_ interaction: Interaction) async throws {
    // idk maybe register something internally, just here for completeness
  }
}
