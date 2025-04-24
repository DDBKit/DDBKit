//
//  InteractionEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct InteractionCreateEvent: BaseEvent {
public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.Ready
  public var eventType: Gateway.Event.EventType = .interactionCreate
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}
