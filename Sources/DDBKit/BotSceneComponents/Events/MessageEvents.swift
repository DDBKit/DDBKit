//
//  MessageEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct MessageCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageCreate
  var eventType: Gateway.Event.EventType? = .messageCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct MessageUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordChannel.PartialMessage
  var eventType: Gateway.Event.EventType? = .messageUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct MessageDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageDelete
  var eventType: Gateway.Event.EventType? = .messageDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct MessageDeleteBulkEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageDeleteBulk
  var eventType: Gateway.Event.EventType? = .messageDeleteBulk
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct MessageReactionAddEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageReactionAdd
  var eventType: Gateway.Event.EventType? = .messageReactionAdd
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct MessageReactionRemoveEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageReactionRemove
  var eventType: Gateway.Event.EventType? = .messageReactionRemove
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct MessageReactionRemoveAllEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageReactionRemoveAll
  var eventType: Gateway.Event.EventType? = .messageReactionRemoveAll
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct MessageReactionRemoveEmojiEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.MessageReactionRemoveEmoji
  var eventType: Gateway.Event.EventType? = .messageReactionRemoveEmoji
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct TypingStartEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.TypingStart
  var eventType: Gateway.Event.EventType? = .typingStart
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
