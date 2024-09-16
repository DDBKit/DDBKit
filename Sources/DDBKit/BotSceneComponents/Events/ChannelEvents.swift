//
//  ChannelEvents.swift
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
