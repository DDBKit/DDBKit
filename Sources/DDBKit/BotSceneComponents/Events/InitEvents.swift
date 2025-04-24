//
//  InitEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct HelloEvent: BaseEvent {
  public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.Hello
  public var eventType: Gateway.Event.EventType = .hello
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}

public struct ReadyEvent: BaseEvent {
public var action: @Sendable (T) async -> Void
  public typealias T = Gateway.Ready
  public var eventType: Gateway.Event.EventType = .ready
  public init(_ action: @Sendable @escaping (T) async -> Void) { self.action = action }
}
