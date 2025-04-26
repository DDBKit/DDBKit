//
//  ThreadsEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct ThreadCreateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = DiscordChannel
  public var eventType: Gateway.Event.EventType = .threadCreate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct ThreadUpdateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = DiscordChannel
  public var eventType: Gateway.Event.EventType = .threadUpdate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct ThreadDeleteEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.ThreadDelete
  public var eventType: Gateway.Event.EventType = .threadDelete
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct ThreadSyncListEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.ThreadListSync
  public var eventType: Gateway.Event.EventType = .threadSyncList
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct ThreadMemberUpdateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.ThreadMemberUpdate
  public var eventType: Gateway.Event.EventType = .threadMemberUpdate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct ThreadMembersUpdateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.ThreadMembersUpdate
  public var eventType: Gateway.Event.EventType = .threadMembersUpdate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}
