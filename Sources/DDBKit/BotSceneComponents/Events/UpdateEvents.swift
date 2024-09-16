//
//  PresenceEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct PresenceUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.PresenceUpdate
  var eventType: Gateway.Event.EventType? = .presenceUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct RequestPresenceUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.Identify.Presence
  var eventType: Gateway.Event.EventType? = .requestPresenceUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct UserUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = DiscordUser
  var eventType: Gateway.Event.EventType? = .userUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct VoiceStateUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = VoiceState
  var eventType: Gateway.Event.EventType? = .voiceStateUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct RequestVoiceStateUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = VoiceStateUpdate
  var eventType: Gateway.Event.EventType? = .requestVoiceStateUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct VoiceServerUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.VoiceServerUpdate
  var eventType: Gateway.Event.EventType? = .voiceServerUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
