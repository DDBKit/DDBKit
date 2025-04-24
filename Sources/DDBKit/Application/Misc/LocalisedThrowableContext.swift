//
//  LocalisedThrowableContext.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 25/10/2024.
//

public protocol LocalisedThrowable {
  var localThrowCatch: (@Sendable (Error, Interaction) async throws -> Void)? { get set }
}

public extension LocalisedThrowable {
  func `catch`(_ errorHandle: @Sendable @escaping (Error, Interaction) async throws -> Void) -> Self {
    var copy = self
    copy.localThrowCatch = errorHandle
    return copy
  }
}
