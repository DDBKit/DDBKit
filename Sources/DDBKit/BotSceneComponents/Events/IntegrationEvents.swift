//
//  IntegrationEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct IntegrationCreateEvent: BaseEvent {
  public var action: (T?) async -> Void
  public typealias T = Gateway.IntegrationCreate
  public var eventType: Gateway.Event.EventType? = .integrationCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct IntegrationUpdateEvent: BaseEvent {
  public var action: (T?) async -> Void
  public typealias T = Gateway.IntegrationCreate
  public var eventType: Gateway.Event.EventType? = .integrationUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct IntegrationDeleteEvent: BaseEvent {
  public var action: (T?) async -> Void
  public typealias T = Gateway.IntegrationDelete
  public var eventType: Gateway.Event.EventType? = .integrationDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
