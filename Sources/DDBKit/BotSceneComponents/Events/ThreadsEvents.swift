//
//  ThreadsEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct ThreadCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordChannel
  var eventType: Gateway.Event.EventType? = .threadCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ThreadUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordChannel
  var eventType: Gateway.Event.EventType? = .threadUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ThreadDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.ThreadDelete
  var eventType: Gateway.Event.EventType? = .threadDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct ThreadSyncListEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.ThreadListSync
  var eventType: Gateway.Event.EventType? = .threadSyncList
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ThreadMemberUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.ThreadMemberUpdate
  var eventType: Gateway.Event.EventType? = .threadMemberUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ThreadMembersUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.ThreadMembersUpdate
  var eventType: Gateway.Event.EventType? = .threadMembersUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
