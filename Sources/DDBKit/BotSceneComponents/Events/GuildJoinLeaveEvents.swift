//
//  GuildJoinLeaveEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct GuildCreateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.GuildCreate
  public var eventType: Gateway.Event.EventType = .guildCreate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildUpdateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Guild
  public var eventType: Gateway.Event.EventType = .guildUpdate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildDeleteEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = UnavailableGuild
  public var eventType: Gateway.Event.EventType = .guildDelete
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}
