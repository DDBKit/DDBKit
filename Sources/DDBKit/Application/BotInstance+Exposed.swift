//
//  BotInstance+Exposed.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 21/11/2024.
//

@_spi(Extensions)
extension BotInstance {
  /// Read-only bot gateway instance
  public var bot: GatewayManager { _bot }
  /// Read-only gateway cache instance
  public var cache: DiscordCache { _cache }

  // exposed

  public var events: [any BaseEvent] {
    get {
      _events
    }
    set {
      _events = newValue
    }
  }

  // we want to expose commands as `ExtensibleCommand` for ease of use
  public var commands: [any ExtensibleCommand] {
    get {
      _commands.map { $0 as! any ExtensibleCommand }
    }
    set {
      _commands = newValue.map { $0 as! BaseContextCommand }
    }
  }
}
