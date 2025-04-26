//
//  Events.swift
//
//
//  Created by Lakhan Lothiyi on 18/04/2024.
//

import Foundation

public struct WebhooksEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.WebhooksUpdate
  public var eventType: Gateway.Event.EventType = .webhooksUpdate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct ApplicationCommandPermissionsUpdateEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = GuildApplicationCommandPermissions
  public var eventType: Gateway.Event.EventType = .applicationCommandPermissionsUpdate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}
