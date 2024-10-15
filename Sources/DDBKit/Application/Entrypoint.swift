//
//  Entrypoint.swift
//
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation
@_spi(UserInstallableApps) import DiscordBM

extension DiscordBotApp {
  
  public static func main() async throws {
    // Default implementation for main function
    try await Self.init().run()
  }
  
  @MainActor // eventloop runs on main actor
  public func run() async throws {
    // first init the environment to capture events and process commands
    let sceneData = readScene(scenes: self.body)
    // BotInstance contains all of our commands and events, it handles dispatching data to the bot
    let instance: BotInstance = .init(bot: self.bot, events: sceneData.events, commands: sceneData.commands)
    
    // register commands
    let allCommands = sceneData.commands
    
    let globalCommands = allCommands.filter({ $0.guildScope.scope == .global }).map(\.baseInfo)
    try await bot.client
      .bulkSetApplicationCommands(payload: globalCommands)
      .guardSuccess()
    
    // don't check for scope to be local, we check if it contains guilds to target
    let targettedCommands: [GuildSnowflake: [Payloads.ApplicationCommandCreate]] = allCommands
      .filter({ !$0.guildScope.guilds.isEmpty })
      .flatMap { command in
        command.guildScope.guilds.map { guild in
          (guild, command.baseInfo)  // pair up guilds to base info
        }
      }
      .reduce(into: [GuildSnowflake: [Payloads.ApplicationCommandCreate]]()) { result, pair in
        let (guild, commandInfo) = pair
        result[guild, default: []].append(commandInfo)  // append
      }
    
      
    for guildCommandsGroup in targettedCommands {
      try await bot.client
        .bulkSetGuildApplicationCommands(
          guildId: guildCommandsGroup.key,
          payload: guildCommandsGroup.value
        )
        .guardSuccess()
    }
    
    // then connect the bot
    await bot.connect()
    
    // and finally, begin receiving events
    for await event in await self.bot.events {
      instance.sendEvent(event)
    }
  }
}

internal extension DiscordBotApp {
  /// Reads the declared scene
  /// - Parameter scenes: Scene data
  /// - Returns: Separated scenes
  func readScene(scenes: [any BotScene]) -> (events: [any BaseEvent], commands: [any BaseContextCommand]) {
    var events = [any BaseEvent]()
    var commands = [any BaseContextCommand]()
    scenes.forEach { scene in
      switch true {
      case scene is any BaseEvent: events.append(scene as! any BaseEvent) // register event handlers
      case scene is any BaseContextCommand: commands.append(scene as! any BaseContextCommand) // register commands
      default: break
      }
    }
    return (events, commands)
  }
}
