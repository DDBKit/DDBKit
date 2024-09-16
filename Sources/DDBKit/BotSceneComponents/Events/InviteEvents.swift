//
//  InviteEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct InviteCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.InviteCreate
  var eventType: Gateway.Event.EventType? = .inviteCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct InviteDeleteEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.InviteDelete
  var eventType: Gateway.Event.EventType? = .inviteDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
