//
//  BotInstance+Exposed.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 21/11/2024.
//

@_spi(Extensions)
public extension BotInstance {
  /// Read-only bot gateway instance
  var bot: GatewayManager { _bot }
  /// Read-only gateway cache instance
  var cache: DiscordCache { _cache }
  
  
  // exposed
  
  var events: [any BaseEvent] {
    get {
      _events
    }
    set {
      _events = newValue
    }
  }
  
  // we want to expose commands as `ExtensibleCommand` for ease of use
  var commands: [any ExtensibleCommand] {
    get {
      _commands.map { $0 as! any ExtensibleCommand }
    }
    set {
      _commands = newValue.map { $0 as! BaseContextCommand }
    }
  }
}
