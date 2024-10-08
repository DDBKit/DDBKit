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
  var trigger: (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async -> Void
  
  public init(_ name: String, action: @escaping (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async -> Void) {
    self.trigger = action
    
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
    guard let value = opt.value else { return } /// no point doing work if no value is present to derive autocompletions from
    // find autocompletable options
    let autocompletableOptions = self.options.compactMap { $0 as? _AutocompletableOption }
    
    // find applicable option in autocompletable options
    let option = autocompletableOptions.first(where: {$0.optionData.name == opt.name})
    // run autocompletions callback
    
    let autocompletions = option?.autocompletion?(value)
    // return these choices
    _ = try? await client.createInteractionResponse(id: i.id, token: i.token, payload: .autocompleteResult(.init(choices: autocompletions ?? [])))
  }
}
