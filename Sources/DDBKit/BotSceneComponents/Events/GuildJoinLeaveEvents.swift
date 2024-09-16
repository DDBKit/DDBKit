//
//  GuildJoinLeaveEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct GuildCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildCreate
  var eventType: Gateway.Event.EventType? = .guildCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Guild
  var eventType: Gateway.Event.EventType? = .guildUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = UnavailableGuild
  var eventType: Gateway.Event.EventType? = .guildDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
