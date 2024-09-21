//
//  StageEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct StageInstanceCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = StageInstance
  var eventType: Gateway.Event.EventType? = .stageInstanceCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct StageInstanceDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = StageInstance
  var eventType: Gateway.Event.EventType? = .stageInstanceDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct StageInstanceUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = StageInstance
  var eventType: Gateway.Event.EventType? = .stageInstanceUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
