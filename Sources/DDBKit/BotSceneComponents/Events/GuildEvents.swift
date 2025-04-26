//
//  GuildEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct GuildBanAddEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.GuildBan
  public var eventType: Gateway.Event.EventType = .guildBanAdd
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildBanRemoveEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.GuildBan
  public var eventType: Gateway.Event.EventType = .guildBanRemove
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildEmojisUpdateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.GuildEmojisUpdate
  public var eventType: Gateway.Event.EventType = .guildEmojisUpdate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildStickersUpdateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.GuildStickersUpdate
  public var eventType: Gateway.Event.EventType = .guildStickersUpdate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildIntegrationsUpdateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.GuildIntegrationsUpdate
  public var eventType: Gateway.Event.EventType = .guildIntegrationsUpdate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildMemberAddEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.GuildMemberAdd
  public var eventType: Gateway.Event.EventType = .guildMemberAdd
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildMemberUpdateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.GuildMemberAdd
  public var eventType: Gateway.Event.EventType = .guildMemberUpdate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildMemberRemoveEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.GuildMemberRemove
  public var eventType: Gateway.Event.EventType = .guildMemberRemove
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildMembersChunkEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.GuildMembersChunk
  public var eventType: Gateway.Event.EventType = .guildMembersChunk
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct RequestGuildMembersEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.RequestGuildMembers
  public var eventType: Gateway.Event.EventType = .requestGuildMembers
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildRoleCreateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.GuildRole
  public var eventType: Gateway.Event.EventType = .guildRoleCreate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildRoleUpdateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.GuildRole
  public var eventType: Gateway.Event.EventType = .guildRoleUpdate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildRoleDeleteEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.GuildRoleDelete
  public var eventType: Gateway.Event.EventType = .guildRoleDelete
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildScheduledEventCreateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = GuildScheduledEvent
  public var eventType: Gateway.Event.EventType = .guildScheduledEventCreate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildScheduledEventUpdateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = GuildScheduledEvent
  public var eventType: Gateway.Event.EventType = .guildScheduledEventUpdate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildScheduledEventDeleteEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = GuildScheduledEvent
  public var eventType: Gateway.Event.EventType = .guildScheduledEventDelete
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct GuildAuditLogEntryCreateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = AuditLog.Entry
  public var eventType: Gateway.Event.EventType = .guildAuditLogEntryCreate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}
