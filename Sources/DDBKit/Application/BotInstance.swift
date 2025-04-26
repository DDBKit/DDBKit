//
//  BotInstance.swift
//
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import DiscordBM
import Foundation

// this internal class keeps track of declared events and handles actions.
// the entrypoint file contains a local declaration of it in the run() func.
// TODO: not use unchecked sendable, pls make it sendable :c
public final class BotInstance: @unchecked Sendable {
  /// avoid this, for testing.
  private init() {
    self._bot = nil
    self._cache = nil
    self._events = []
    self._commands = []
    self.id = try! .makeFake()
  }

  /// bot instance we keep to interact with if needed
  let _bot: GatewayManager!
  let _cache: DiscordCache!

  // global error handling
  public var globalErrorHandle: (@Sendable (Error, InteractionExtras) async throws -> Void)?

  // declared events the user wants to receive
  var _events: [any BaseEvent]
  var _commands: [any BaseContextCommand]  // basecommand inherits from basecontextcommand btw

  // modal and component id receives
  public var modalReceives: [String: [@Sendable (InteractionExtras) async throws -> Void]] = [:]
  public var componentReceives: [String: [@Sendable (InteractionExtras) async throws -> Void]] = [:]

  /// Unique stable identifier for the app
  public let id: ApplicationSnowflake

  init(
    bot: GatewayManager, cache: DiscordCache, events: [any BaseEvent],
    commands: [any BaseContextCommand]
  ) {
    self._bot = bot
    self._cache = cache
    self._events = events
    self._commands = commands
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
}
