//
//  BotCommandComponent.swift
//  
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation
import RegexBuilder
import DiscordBM

/// A basic command thats easy and fast to declare and program
public struct Command: BaseCommand {
  var modalReceives: [String: [(Interaction, Interaction.ModalSubmit, DatabaseBranches) async throws -> Void]] = [:]
  var componentReceives: [String: [(Interaction, Interaction.MessageComponent, DatabaseBranches) async throws -> Void]] = [:]
  
  // autocompletion related things
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
  
  var options: [Option] = []
  
  // command data
  var baseInfo: DiscordModels.Payloads.ApplicationCommandCreate
  var guildScope: CommandGuildScope = .init(scope: .global, guilds: [])

  func trigger(_ i: DiscordModels.Interaction) async throws {
    switch i.data {
    case .applicationCommand(let j): await proxyAction(i, j)
    default: break
    }
  }
  
  // we let the user define action, but we control the before and after actions.
  // we internally execute proxyAction which executes before, user-def and after actions.
  var action: (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async -> Void
  func proxyAction(_ i: Interaction, _ j: Interaction.ApplicationCommand) async {
    let dbReqs: DatabaseBranches = .init(i)
    
    await preAction(i)
    await action(i, j, dbReqs)
    await postAction(i)
  }
  
  public init(_ commandName: String, action: @escaping (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async -> Void) {
    let name = commandName.trimmingCharacters(in: .whitespacesAndNewlines)
    self.action = action
    self.baseInfo = .init(
      name: commandName,
      description: "This command has no description."
    )
    
    let valid = self.baseInfo.validate()
    if !valid.isEmpty {
      preconditionFailure("[\(name)] Failed validation\n\n\(valid)")
    }
  }
  
  // MARK: - These pre and post actions are for use internally
  
  func preAction(_ interaction: Interaction) async {
    // do things like sending defer, processing, idk
  }
  func postAction(_ interaction: Interaction) async {
    // idk maybe register something internally, just here for completeness
  }
}
