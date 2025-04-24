//
//  MessageEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct MessageCreateEvent: BaseEvent {
public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.MessageCreate
  public var eventType: Gateway.Event.EventType = .messageCreate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct MessageUpdateEvent: BaseEvent {
public var action: @Sendable (T) async -> Void
  public typealias T = DiscordChannel.PartialMessage
  public var eventType: Gateway.Event.EventType = .messageUpdate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct MessageDeleteEvent: BaseEvent {
public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.MessageDelete
  public var eventType: Gateway.Event.EventType = .messageDelete
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct MessageDeleteBulkEvent: BaseEvent {
public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.MessageDeleteBulk
  public var eventType: Gateway.Event.EventType = .messageDeleteBulk
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}


public struct MessageReactionAddEvent: BaseEvent {
public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.MessageReactionAdd
  public var eventType: Gateway.Event.EventType = .messageReactionAdd
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct MessageReactionRemoveEvent: BaseEvent {
public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.MessageReactionRemove
  public var eventType: Gateway.Event.EventType = .messageReactionRemove
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct MessageReactionRemoveAllEvent: BaseEvent {
public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.MessageReactionRemoveAll
  public var eventType: Gateway.Event.EventType = .messageReactionRemoveAll
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct MessageReactionRemoveEmojiEvent: BaseEvent {
public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.MessageReactionRemoveEmoji
  public var eventType: Gateway.Event.EventType = .messageReactionRemoveEmoji
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}


public struct TypingStartEvent: BaseEvent {
public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.TypingStart
  public var eventType: Gateway.Event.EventType = .typingStart
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}
