//
//  ContextCommand.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 15/10/2024.
//

import DiscordBM

public struct Context: BaseContextCommand {
  var modalReceives: [String : [(DiscordModels.Interaction, DiscordModels.Interaction.ModalSubmit, DatabaseBranches) async -> Void]] = [:]
  var componentReceives: [String : [(DiscordModels.Interaction, DiscordModels.Interaction.MessageComponent, DatabaseBranches) async -> Void]] = [:]
  
  var guildScope: CommandGuildScope = .init(scope: .global, guilds: [])
  
  var baseInfo: DiscordModels.Payloads.ApplicationCommandCreate
  
  func trigger(_ i: DiscordModels.Interaction) async {
    switch i.data {
    case .applicationCommand(let j): await proxyAction(i, j)
    default: break
    }
  }
  
  var action: (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async -> Void
  func proxyAction(_ i: Interaction, _ j: Interaction.ApplicationCommand) async {
    let dbReqs: DatabaseBranches = .init(i)
    
    await preAction(i)
    await action(i, j, dbReqs)
    await postAction(i)
  }
  
  public init(_ name: String, kind: Kind, action: @escaping (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async -> Void) {
    self.baseInfo = .init(
      name: name,
      name_localizations: nil,
      description: nil,
      description_localizations: nil,
      options: [],
      default_member_permissions: nil,
      dm_permission: nil,
      type: .init(rawValue: kind.rawValue),
      nsfw: nil
    )
    self.action = action
  }
  
  public enum Kind: UInt {
    case user = 2 // ApplicationCommand.Kind.user.rawValue
    case message = 3 // ApplicationCommand.Kind.message.rawValue
  }
  
  // MARK: - These pre and post actions are for use internally
  
  func preAction(_ interaction: Interaction) async {
    // do things like sending defer, processing, idk
  }
  func postAction(_ interaction: Interaction) async {
    // idk maybe register something internally, just here for completeness
  }
}
