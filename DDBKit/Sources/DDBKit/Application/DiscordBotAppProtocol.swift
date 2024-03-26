//
//  DiscordBotAppProtocol.swift
//
//
//  Created by Lakhan Lothiyi on 22/03/2024.
//

import DiscordBM
import Foundation
import AsyncHTTPClient
import SwiftUI

/// This protocol is applied to the struct that your bot runs with.
public protocol DiscordBotApp {
  var bot: Bot { get set }
  typealias Bot = BotGatewayManager
  @BotSceneBuilder var body: [BotScene] { get }
  
  /// This is the entrypoint for your bot, use the `run() async throws` method to begin running the bot.
  static func main() async throws
  
  init() async
}

class BotInstance {
  static var i = BotInstance()
  private init() { self.bot = nil; self.rawEvents = [] }
  
  /// bot instance we keep to interact with if needed
  let bot: BotGatewayManager?
  
  // declared events the user wants to receive
  let rawEvents: [Event]
  
  init(bot: BotGatewayManager, rawEvents: [Event]) {
    self.bot = bot
    self.rawEvents = rawEvents
  }
  
  func sendEvent(_ event: Gateway.Event) {
    // now that we got an event, we should look for all events that match
    let matchedEvents = rawEvents.filter { $0.typeMatchesEvent(event) }
    
    // now we have all appropriate events. go through them all and trigger action
    matchedEvents.forEach { match in
      Task(priority: .userInitiated) { /// we use a task because we don't want many of the same event doing long tasks and blocking the event queue
        await match.action(event.data) // FIXME: how do we get type safety based on chosen event
      }
    }
  }
}

extension DiscordBotApp {
  
  public static func main() async throws {
    // Default implementation for main function
    let bot = await Self.init()
    try await bot.run()
  }
  
  public func run() async throws {
    // first init the environment to capture events and process commands
    let sceneData = readScene(scenes: self.body)
    BotInstance.i = .init(bot: self.bot, rawEvents: sceneData.events)
    
    // then connect the bot
    await bot.connect()
    
    // and finally, begin receiving events
    for await event in await self.bot.events {
      BotInstance.i.sendEvent(event)
    }
  }
}

internal extension DiscordBotApp {
  func readScene(scenes: [any BotScene]) -> (events: [Event], a: Void) {
    var events = [Event]()
    scenes.forEach { scene in
      if let event = scene as? Event {
        events.append(event)
      }
    }
    return (events, ())
  }
}
