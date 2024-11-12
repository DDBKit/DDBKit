//
//  ThrowableContexts.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 25/10/2024.
//

import DiscordBM

public extension DiscordBotApp {
  /// Handles throws from commands unless a command already has it's own catch.
  /// - Parameter errorHandle: Handle closure
  func AssignGlobalCatch(_ errorHandle: @escaping (GatewayManager, Error, Interaction) async throws -> Void) {
    // if you've crashed here, you've accidentally used this in the bot initialiser.
    // use this in the boot function of your bot app.
    _BotInstances[self.bot.client.appId!]!.globalErrorHandle = errorHandle
  }
  
  @_spi(Extensions)
  func getExtension<T>(_ type: T.Type) -> T where T: DDBKitExtension {
    _BotInstances[self.bot.client.appId!]!.extensions.first(where: { $0 is T }) as! T
    // if this failed, you forgot to register the extension lol.
  }
}
