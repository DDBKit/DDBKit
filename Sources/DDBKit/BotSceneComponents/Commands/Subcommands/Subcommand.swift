//
//  Subcommand.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 07/10/2024.
//

import DiscordBM

/// Group subcommands under a label
public struct SubcommandGroup: BaseInfoType {
  var commands: [Subcommand] // this carries the instances so we keep trigger intact
  var baseInfo: ApplicationCommand.Option
  public init(_ name: String, @SubcommandBuilder _ tree: () -> [Subcommand]) {
    self.commands = tree()
    
    self.baseInfo = .init(
      type: .subCommandGroup,
      name: name,
      name_localizations: nil,
      description: "This subcommand group has no description.",
      description_localizations: nil,
      options: self.commands.map(\.baseInfo)
    )
  }
}

/// A subcommand to a base or group
public struct Subcommand: BaseInfoType {
  var options: [Option] = []
  var baseInfo: ApplicationCommand.Option
  var action: (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async throws -> Void
  
  func action(_ i: Interaction, _ j: Interaction.ApplicationCommand, _ k: DatabaseBranches) async throws {
    try await preAction(i)
    try await action(i, j, k)
    try await postAction(i)
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
  
  
  func autocompletion(_ i: DiscordModels.Interaction, cmd: DiscordModels.Interaction.ApplicationCommand, opt: DiscordModels.Interaction.ApplicationCommand.Option, client: DiscordClient) async {
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
