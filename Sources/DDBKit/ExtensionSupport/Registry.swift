//
//  Registry.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 22/10/2024.
//

import DiscordModels

var _ExtensionInstances: [ApplicationSnowflake: [DDBKitExtension]] = [:]

extension DiscordBotApp {
  public func RegisterExtension(_ e: DDBKitExtension) {
    _BotInstances[self.bot.client.appId!]!.extensions.append(e)
    // hey bro you cant register an extension before the bot has been initialised
    // do it in `boot() async throws` instead.
  }
}

extension BotInstance {
  public var extensions: [DDBKitExtension] {
    get {
      _ExtensionInstances[self.id] ?? []
    }
    set {
      _ExtensionInstances[self.id] = newValue
    }
  }
  
  @_spi(Extensions)
  public func getExtension<T>(of type: T.Type) -> T where T: DDBKitExtension {
    if let t = _BotInstances[self.bot.client.appId!]?.extensions.first(where: { $0 is T }) as? T {
      return t
    }
    fatalError("Extension of type \(type) not found")
    // if this failed, you forgot to register the extension lol.
  }
  
  public subscript<T>(ext type: T.Type) -> T where T: DDBKitExtension {
    self.getExtension(of: type)
  }
}
