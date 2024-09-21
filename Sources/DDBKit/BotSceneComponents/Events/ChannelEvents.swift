//
//  ChannelEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct ChannelCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordChannel
  var eventType: Gateway.Event.EventType? = .channelCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ChannelUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordChannel
  var eventType: Gateway.Event.EventType? = .channelUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ChannelDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordChannel
  var eventType: Gateway.Event.EventType? = .channelDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ChannelPinsUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.ChannelPinsUpdate
  var eventType: Gateway.Event.EventType? = .channelPinsUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
