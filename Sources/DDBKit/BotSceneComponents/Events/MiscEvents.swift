//
//  Events.swift
//
//
//  Created by Lakhan Lothiyi on 18/04/2024.
//

import Foundation

public struct WebhooksEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.WebhooksUpdate
  var eventType: Gateway.Event.EventType? = .webhooksUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct ApplicationCommandPermissionsUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = GuildApplicationCommandPermissions
  var eventType: Gateway.Event.EventType? = .applicationCommandPermissionsUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
