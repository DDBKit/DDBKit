//
//  SentEvent.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 21/11/2024.
//

import DiscordBM

extension BotInstance {
  func sendEvent(_ event: Gateway.Event) {
    // MARK: - Interactions (cmds etc.)
    if event.isOfType(.interactionCreate) {
      // handle externally
      self.handleInteractionCreate(event)
    }

    // MARK: - Events (anything else)
    // now that we got an event, we should look for all events that match
    let matchedEvents = _events.filter { $0.typeMatchesEvent(event) }

    // now we have all appropriate events. go through them all and trigger action
    matchedEvents.forEach { match in
      Task(priority: .userInitiated) {
        await match.handle(event.data)
      }
    }
  }
}
