//
//  BotInstance.swift
//
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation

// this internal class keeps track of declared events and handles actions 
class BotInstance {
  static var shared = BotInstance()
  private init() { self.bot = nil; self.rawEvents = [] }
  
  /// bot instance we keep to interact with if needed
  let bot: GatewayManager?
  
  // declared events the user wants to receive
  let rawEvents: [any BaseEvent]
  
  init(bot: GatewayManager, rawEvents: [any BaseEvent]) {
    self.bot = bot
    self.rawEvents = rawEvents
  }
  
  func sendEvent(_ event: Gateway.Event) {
    // now that we got an event, we should look for all events that match
    let matchedEvents = rawEvents.filter { $0.typeMatchesEvent(event) }
    
    // now we have all appropriate events. go through them all and trigger action
    matchedEvents.forEach { match in
      Task(priority: .userInitiated) { /// we use a task because we don't want many of the same event doing long tasks and blocking the event queue
        await match.handle(event.data) // FIXME: how do we get type safety based on chosen event
      }
    }
  }
}
