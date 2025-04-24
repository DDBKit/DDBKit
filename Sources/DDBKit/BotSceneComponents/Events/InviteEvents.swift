//
//  InviteEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct InviteCreateEvent: BaseEvent {
public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.InviteCreate
  public var eventType: Gateway.Event.EventType = .inviteCreate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct InviteDeleteEvent: BaseEvent {
public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.InviteDelete
  public var eventType: Gateway.Event.EventType = .inviteDelete
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}
