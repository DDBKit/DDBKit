//
//  _InternalCommandComponent.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 17/09/2024.
//

import DiscordModels
import DiscordHTTP

/// Give `Command` and `ComplexCommand` conformance so they can be used the same behind the scenes
protocol BaseCommand: BotScene {
  var guildScope: CommandGuildScope { get set }
  var baseInfo: Payloads.ApplicationCommandCreate { get set }
  func trigger(_ i: Interaction) async
  func autocompletion(
    _ i: Interaction,
    cmd: Interaction.ApplicationCommand,
    opt: Interaction.ApplicationCommand.Option,
    client: DiscordClient
  ) async
}

public struct CommandGuildScope {
  var scope: ScopeType
  var guilds: [GuildSnowflake]
  
  public enum ScopeType {
    case global
    case local
  }
}


