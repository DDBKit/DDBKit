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
    self._cache = nil
    self.events = []
    self.commands = []
    self.id = try! .makeFake()
  }
  
  /// bot instance we keep to interact with if needed
  let _bot: GatewayManager!
  let _cache: DiscordCache!
  
  public var globalErrorHandle: ((Error, InteractionExtras) async throws -> Void)?
  
  // declared events the user wants to receive
  public var events: [any BaseEvent]
  public var commands: [any BaseContextCommand] // basecommand inherits from basecontextcommand btw
  
  public var modalReceives: [String: [(InteractionExtras) async throws -> Void]] = [:]
  public var componentReceives: [String: [(InteractionExtras) async throws -> Void]] = [:]
  
  /// Unique stable identifier for the app
  public let id: ApplicationSnowflake
  
  init(bot: GatewayManager, cache: DiscordCache, events: [any BaseEvent], commands: [any BaseContextCommand]) {
    self._bot = bot
    self._cache = cache
    self.events = events
    self.commands = commands
    // Hey! If you found your bot crashing here, your token is invalid or you forgor
    self.id = bot.client.appId!
    
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

@_spi(Extensions)
public extension BotInstance {
  /// Read-only bot gateway instance
  var bot: GatewayManager { _bot }
  /// Read-only gateway cache instance
  var cache: DiscordCache { _cache }
}
