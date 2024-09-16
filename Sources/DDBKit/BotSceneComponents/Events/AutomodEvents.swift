//
//  AutomodEvents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

public struct AutoModerationRuleCreateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = AutoModerationRule
  var eventType: Gateway.Event.EventType? = .autoModerationRuleCreate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct AutoModerationRuleUpdateEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = AutoModerationRule
  var eventType: Gateway.Event.EventType? = .autoModerationRuleUpdate
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}

public struct AutoModerationRuleRemoveEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = AutoModerationRule
  var eventType: Gateway.Event.EventType? = .autoModerationRuleDelete
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}


public struct AutoModerationActionExecutionEvent: BaseEvent {
  var action: (T?) async -> Void
  public typealias T = AutoModerationActionExecution
  var eventType: Gateway.Event.EventType? = .autoModerationActionExecution
  public init(_ action: @escaping (T?) async -> Void) { self.action = action }
}
