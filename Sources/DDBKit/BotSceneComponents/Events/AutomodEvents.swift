//
//  AutomodEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

public struct AutoModerationRuleCreateEvent: BaseEvent {
  public var action: (T) async -> Void
  public typealias T = AutoModerationRule
  public var eventType: Gateway.Event.EventType = .autoModerationRuleCreate
}

public struct AutoModerationRuleUpdateEvent: BaseEvent {
  public var action: (T) async -> Void
  public typealias T = AutoModerationRule
  public var eventType: Gateway.Event.EventType = .autoModerationRuleUpdate
  public init(_ action: @escaping (T) async -> Void) { self.action = action }
}

public struct AutoModerationRuleRemoveEvent: BaseEvent {
  public var action: (T) async -> Void
  public typealias T = AutoModerationRule
  public var eventType: Gateway.Event.EventType = .autoModerationRuleDelete
  public init(_ action: @escaping (T) async -> Void) { self.action = action }
}


public struct AutoModerationActionExecutionEvent: BaseEvent {
  public var action: (T) async -> Void
  public typealias T = AutoModerationActionExecution
  public var eventType: Gateway.Event.EventType = .autoModerationActionExecution
  public init(_ action: @escaping (T) async -> Void) { self.action = action }
}
