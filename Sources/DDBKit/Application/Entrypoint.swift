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
    let expandedScenes = BotSceneBuilder.expandScenes(self.body)
    let sceneData = readScene(scenes: expandedScenes)
    
    // just a sanity check, ensure there are no groups in the scene when expanding
    expandedScenes.map { type(of: $0) }.forEach { if $0 == Group.self { fatalError("Groups found in scene data after expansion. This is a bug. Please report this in an issue.") } }
    
    // BotInstance contains all of our commands and events, it handles dispatching data to the bot
    var instance: BotInstance = .init(bot: self.bot, cache: self.cache, events: sceneData.events, commands: sceneData.commands)
    
    // we should store the reference somewhere useful for use later
    _BotInstances[instance.id] = instance
    try await self.boot()
    
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
    
    // extensions setup.
    let extensions = instance.extensions
    for ext in extensions {
      try await ext.onBoot(&instance) // is ok to be async as everything is still on the main actor rn.
    }
    // every extension has now had an opportunity to configure the bot instance
    
    // now run boot of all modifiers in commands
    for command in sceneData.commands {
      if let cmd = command as? _ExtensibleCommand {
        for boot in cmd._bootActions {
          try await boot(command, instance)
        }
      }
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

public extension DiscordBotApp {
  func boot() async throws { } // default implementation
}
