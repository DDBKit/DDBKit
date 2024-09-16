//
//  InitEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation

public struct IdentifyEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.Identify
  var eventType: Gateway.Event.EventType? = .identify
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct HelloEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.Hello
  var eventType: Gateway.Event.EventType? = .hello
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct ReadyEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = Gateway.Ready
  var eventType: Gateway.Event.EventType? = .ready
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
