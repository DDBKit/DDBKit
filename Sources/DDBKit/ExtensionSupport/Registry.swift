//
//  Registry.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 22/10/2024.
//

import DiscordModels

var _ExtensionInstances: [ApplicationSnowflake: [DDBKitExtension]] = [:]

extension DiscordBotApp {
  mutating public func RegisterExtension(_ e: DDBKitExtension) {
    self.extensions.append(e)
  }
  
  var extensions: [DDBKitExtension] {
    get {
      _ExtensionInstances[self.bot.client.appId!] ?? []
    }
    set {
      _ExtensionInstances[self.bot.client.appId!] = newValue
    }
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
