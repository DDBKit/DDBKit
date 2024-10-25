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
  }
}
extension BotInstance {
  var extensions: [DDBKitExtension] {
    get {
      _ExtensionInstances[self.id] ?? []
    }
    set {
      _ExtensionInstances[self.id] = newValue
    }
  }
}

public protocol DDBKitExtension {
  
}
