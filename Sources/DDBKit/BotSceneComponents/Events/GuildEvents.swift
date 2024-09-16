//
//  GuildEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct GuildBanAddEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildBan
  var eventType: Gateway.Event.EventType? = .guildBanAdd
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildBanRemoveEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildBan
  var eventType: Gateway.Event.EventType? = .guildBanRemove
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildEmojisUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildEmojisUpdate
  var eventType: Gateway.Event.EventType? = .guildEmojisUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildStickersUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildStickersUpdate
  var eventType: Gateway.Event.EventType? = .guildStickersUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildIntegrationsUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildIntegrationsUpdate
  var eventType: Gateway.Event.EventType? = .guildIntegrationsUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildMemberAddEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildMemberAdd
  var eventType: Gateway.Event.EventType? = .guildMemberAdd
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildMemberUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildMemberAdd
  var eventType: Gateway.Event.EventType? = .guildMemberUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildMemberRemoveEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildMemberRemove
  var eventType: Gateway.Event.EventType? = .guildMemberRemove
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildMembersChunkEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildMembersChunk
  var eventType: Gateway.Event.EventType? = .guildMembersChunk
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct RequestGuildMembersEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.RequestGuildMembers
  var eventType: Gateway.Event.EventType? = .requestGuildMembers
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildRoleCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildRole
  var eventType: Gateway.Event.EventType? = .guildRoleCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildRoleUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildRole
  var eventType: Gateway.Event.EventType? = .guildRoleUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildRoleDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.GuildRoleDelete
  var eventType: Gateway.Event.EventType? = .guildRoleDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildScheduledEventCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = GuildScheduledEvent
  var eventType: Gateway.Event.EventType? = .guildScheduledEventCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildScheduledEventUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = GuildScheduledEvent
  var eventType: Gateway.Event.EventType? = .guildScheduledEventUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct GuildScheduledEventDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = GuildScheduledEvent
  var eventType: Gateway.Event.EventType? = .guildScheduledEventDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct GuildAuditLogEntryCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = AuditLog.Entry
  var eventType: Gateway.Event.EventType? = .guildAuditLogEntryCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
