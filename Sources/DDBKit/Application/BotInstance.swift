//
//  BotInstance.swift
//
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation
import DiscordBM

// this internal class keeps track of declared events and handles actions.
// the entrypoint file contains a local declaration of it in the run() func.
public class BotInstance {
  /// avoid this, for testing.
  private init() {
    self._bot = nil
    self.events = []
    self.commands = []
    self.id = try! .makeFake()
  }
  
  /// bot instance we keep to interact with if needed
  let _bot: GatewayManager?
  
  // declared events the user wants to receive
  let events: [any BaseEvent]
  let commands: [any BaseCommand]
  
  var modalReceives: [String: [(DiscordModels.Interaction, DiscordModels.Interaction.ModalSubmit, DatabaseBranches) async -> Void]] = [:]
  var componentReceives: [String: [(DiscordModels.Interaction, DiscordModels.Interaction.MessageComponent, DatabaseBranches) async -> Void]] = [:]
  
  /// Unique stable identifier for the app
  public let id: ApplicationSnowflake
  
  init(bot: GatewayManager, events: [any BaseEvent], commands: [any BaseCommand]) {
    self._bot = bot
    self.events = events
    self.commands = commands
    // Hey! If you found your bot crashing here, your token is invalid or you forgor
    self.id = .init(.init(bot.identifyPayload.token.value.split(separator: ".", maxSplits: 1).first!))
    
    // register modal and component id receives
    commands.forEach { cmd in
      cmd.modalReceives.keys.forEach { key in
        (cmd.modalReceives[key] ?? []).forEach { value in
          self.modalReceives.append(value, to: key)
        }
      }
    }
    commands.forEach { cmd in
      cmd.componentReceives.keys.forEach { key in
        (cmd.componentReceives[key] ?? []).forEach { value in
          self.componentReceives.append(value, to: key)
        }
      }
    }
  }
  
  func sendEvent(_ event: Gateway.Event) {
    // MARK: - Interactions (cmds etc.)
    if event.isOfType(.interactionCreate) {
      // handle externally
      self.handleInteractionCreate(event)
    }
    
    // MARK: - Events (anything else)
    // now that we got an event, we should look for all events that match
    let matchedEvents = events.filter { $0.typeMatchesEvent(event) }
    
    // now we have all appropriate events. go through them all and trigger action
    matchedEvents.forEach { match in
      Task(priority: .userInitiated) {
        /// we use a task because we don't want many of the same event doing long tasks and blocking the event queue
        await match.handle(event.data) // FIXME: how do we get type safety based on chosen event
      }
    }
  }
}
