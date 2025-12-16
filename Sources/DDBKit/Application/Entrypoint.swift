//
//  Entrypoint.swift
//
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

@_spi(UserInstallableApps) import DiscordBM
import Foundation

extension DiscordBotApp {

  public static func main() async throws {
    // Default implementation for main function
    try await Self.init().run()
  }

  @MainActor  // eventloop runs on main actor
  public func run() async throws {
    // MARK: - Run
    let expandedScenes = BotSceneBuilder.expandScenes(self.body)
    let sceneData = readScene(scenes: expandedScenes)

    // just a sanity check, ensure there are no groups in the scene when expanding
    expandedScenes.map { type(of: $0) }.forEach {
      if $0 == Group.self {
        fatalError(
          "Groups found in scene data after expansion. This is a bug. Please report this in an issue."
        )
      }
    }

    // BotInstance contains all of our commands and events, it handles dispatching data to the bot
    var instance: BotInstance = .init(bot: self.bot, cache: self.cache)

    // register initial scenes
    instance.registerEvents(sceneData.events)
    try await instance.registerCommands(sceneData.commands)

    // we should store the reference somewhere useful for use later
    _BotInstances[instance.id] = instance
    try await self.onBoot()

    // MARK: - Extensions Setup
    let extensions = instance.extensions
    for ext in extensions {
      // is ok to be async as everything is still on the main actor rn? probably!
      try await ext.onBoot(&instance)
      // now we should register all the scenes
      let extScene = await ext.register()
      let expandedScenes = BotSceneBuilder.expandScenes(extScene)
      let extData = readScene(scenes: expandedScenes)

      // register extension scenes (ensures their modal/component callbacks and boot actions run)
      instance.registerEvents(extData.events)
      try await instance.registerCommands(extData.commands)
    }
    // every extension has now had an opportunity to configure the bot instance, and its commands were registered

    // MARK: - Command Setup

    // we want to split the commands into global and guild-scoped
    let allCommands = instance._commands

    let globalCommands = allCommands.filter({ $0.guildScope.scope == .global }).map(\.baseInfo)

    // don't check for scope to be local, we check if it contains guilds to target
    let targettedCommands: [GuildSnowflake: [Payloads.ApplicationCommandCreate]] =
      allCommands
      .filter({ $0.guildScope.scope == .local })  // filter out global commands
      .filter({ !$0.guildScope.guilds.isEmpty })  // filter out commands without guilds (they will never be registered now)
      .flatMap { command in
        command.guildScope.guilds.map { guild in
          (guild, command.baseInfo)  // pair up guilds to base info
        }
      }  // flatmaps into a list of guild and command info pairs
      .reduce(into: [GuildSnowflake: [Payloads.ApplicationCommandCreate]]()) { result, pair in
        let (guild, commandInfo) = pair
        result[guild, default: []].append(commandInfo)  // append
      }  // reduce into a dictionary of guilds and their commands

    // MARK: - Command Registration
    // global
    try await bot.client
      .bulkSetApplicationCommands(payload: globalCommands)
      .guardSuccess()
    // local
    for guildCommandsGroup in targettedCommands {
      try await bot.client
        .bulkSetGuildApplicationCommands(
          guildId: guildCommandsGroup.key,
          payload: guildCommandsGroup.value
        )
        .guardSuccess()
    }

    // MARK: - Connection & Events
    await bot.connect()

    // and finally, begin receiving events
    for await event in await self.bot.events {
      // trigger event for all extensions
      for ext in instance.extensions { Task { try await ext.onEvent(instance, event: event) } }

      // trigger event for all scenes in instance
      instance.sendEvent(event)
    }
  }
}

extension DiscordBotApp {
  /// Reads the declared scene
  /// - Parameter scenes: Scene data
  /// - Returns: Separated scenes
  func readScene(scenes: [any BotScene]) -> (
    events: [any BaseEvent], commands: [any BaseContextCommand]
  ) {
    var events = [any BaseEvent]()
    var commands = [any BaseContextCommand]()
    scenes.forEach { scene in
      switch true {
      case scene is any BaseEvent: events.append(scene as! any BaseEvent)  // register event handlers
      case scene is any BaseContextCommand: commands.append(scene as! any BaseContextCommand)  // register commands
      default: break
      }
    }
    return (events, commands)
  }
}

extension DiscordBotApp {
  public func onBoot() async throws {}  // default implementation
}
