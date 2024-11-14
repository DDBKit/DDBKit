//
//  PresenceEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct PresenceUpdateEvent: BaseEvent {
  public var action: (T) async -> Void
  public typealias T = Gateway.PresenceUpdate
  public var eventType: Gateway.Event.EventType = .presenceUpdate
  public init(_ action: @escaping (T) async -> Void) { self.action = action }
}

public struct RequestPresenceUpdateEvent: BaseEvent {
  public var action: (T) async -> Void
  public typealias T = Gateway.Identify.Presence
  public var eventType: Gateway.Event.EventType = .requestPresenceUpdate
  public init(_ action: @escaping (T) async -> Void) { self.action = action }
}

public struct UserUpdateEvent: BaseEvent {
  public var action: (T) async -> Void
  public typealias T = DiscordUser
  public var eventType: Gateway.Event.EventType = .userUpdate
  public init(_ action: @escaping (T) async -> Void) { self.action = action }
}


public struct VoiceStateUpdateEvent: BaseEvent {
  public var action: (T) async -> Void
  public typealias T = VoiceState
  public var eventType: Gateway.Event.EventType = .voiceStateUpdate
  public init(_ action: @escaping (T) async -> Void) { self.action = action }
}

public struct RequestVoiceStateUpdateEvent: BaseEvent {
  public var action: (T) async -> Void
  public typealias T = VoiceStateUpdate
  public var eventType: Gateway.Event.EventType = .requestVoiceStateUpdate
  public init(_ action: @escaping (T) async -> Void) { self.action = action }
}


public struct VoiceServerUpdateEvent: BaseEvent {
  public var action: (T) async -> Void
  public typealias T = Gateway.VoiceServerUpdate
  public var eventType: Gateway.Event.EventType = .voiceServerUpdate
  public init(_ action: @escaping (T) async -> Void) { self.action = action }
}
