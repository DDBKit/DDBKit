//
//  Entrypoint.swift
//
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation
import DiscordBM

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
    let cmds = sceneData.commands.map(\.baseInfo)
    try await bot.client
      .bulkSetApplicationCommands(payload: cmds)
      .guardSuccess()
    
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
  func readScene(scenes: [any BotScene]) -> (events: [any BaseEvent], commands: [any BaseCommand]) {
    var events = [any BaseEvent]()
    var commands = [any BaseCommand]()
    scenes.forEach { scene in
      switch true {
      case scene is any BaseEvent: events.append(scene as! any BaseEvent) // register event handlers
      case scene is any BaseCommand: commands.append(scene as! any BaseCommand) // register commands
      default: break
      }
    }
    return (events, commands)
  }
}
