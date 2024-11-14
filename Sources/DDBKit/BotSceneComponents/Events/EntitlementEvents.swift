//
//  EntitlementEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct EntitlementCreateEvent: BaseEvent {
  public var action: (T) async -> Void
  public typealias T = Entitlement
  public var eventType: Gateway.Event.EventType = .entitlementCreate
  public init(_ action: @escaping (T) async -> Void) { self.action = action }
}

public struct EntitlementUpdateEvent: BaseEvent {
  public var action: (T) async -> Void
  public typealias T = Entitlement
  public var eventType: Gateway.Event.EventType = .entitlementUpdate
  public init(_ action: @escaping (T) async -> Void) { self.action = action }
}

public struct EntitlementDeleteEvent: BaseEvent {
  public var action: (T) async -> Void
  public typealias T = Entitlement
  public var eventType: Gateway.Event.EventType = .entitlementDelete
  public init(_ action: @escaping (T) async -> Void) { self.action = action }
}
