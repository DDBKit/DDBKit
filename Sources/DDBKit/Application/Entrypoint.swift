//
//  Entrypoint.swift
//  
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation

extension DiscordBotApp {
  
  public static func main() async throws {
    // Default implementation for main function
    let bot = await Self.init()
    try await bot.run()
  }
  
  public func run() async throws {
    // first init the environment to capture events and process commands
    let sceneData = readScene(scenes: self.body)
    BotInstance.shared = .init(bot: self.bot, rawEvents: sceneData.events)
    
    // then connect the bot
    await bot.connect()
    
    // and finally, begin receiving events
    for await event in await self.bot.events {
      BotInstance.shared.sendEvent(event)
    }
  }
}

internal extension DiscordBotApp {
  /// Reads the declared scene
  /// - Parameter scenes: Scene data
  /// - Returns: Separated scenes
  func readScene(scenes: [any BotScene]) -> (events: [any BaseEvent], a: Void) {
    var events = [any BaseEvent]()
    scenes.forEach { scene in
      switch true {
      case scene is any BaseEvent: events.append(scene as! any BaseEvent) // register raw event handlers
      default: break
      }
    }
    return (events, ())
  }
}
