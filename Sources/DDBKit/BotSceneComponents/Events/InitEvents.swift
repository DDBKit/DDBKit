//
//  InitEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct IdentifyEvent: BaseEvent {
  public var action: (T?) async -> Void
  public typealias T = Gateway.Identify
  public var eventType: Gateway.Event.EventType? = .identify
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct HelloEvent: BaseEvent {
  public var action: (T?) async -> Void
  public typealias T = Gateway.Hello
  public var eventType: Gateway.Event.EventType? = .hello
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ReadyEvent: BaseEvent {
  public var action: (T?) async -> Void
  public typealias T = Gateway.Ready
  public var eventType: Gateway.Event.EventType? = .ready
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
