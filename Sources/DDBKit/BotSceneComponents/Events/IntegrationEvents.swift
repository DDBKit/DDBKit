//
//  IntegrationEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct IntegrationCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.IntegrationCreate
  var eventType: Gateway.Event.EventType? = .integrationCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct IntegrationUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.IntegrationCreate
  var eventType: Gateway.Event.EventType? = .integrationUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct IntegrationDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.IntegrationDelete
  var eventType: Gateway.Event.EventType? = .integrationDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
