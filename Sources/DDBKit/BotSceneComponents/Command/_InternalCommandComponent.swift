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
  var baseInfo: Payloads.ApplicationCommandCreate { get }
  func trigger(_ i: Interaction) async
  func autocompletion(_ i: Interaction, cmd: Interaction.ApplicationCommand, opt: Interaction.ApplicationCommand.Option, client: DiscordClient) async
}


