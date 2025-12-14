//
//  Modifiers.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 11/11/2024.
//

import DiscordBM
import Foundation

@_spi(Extensions)
extension ExtensibleCommand {
  public func preAction(
    _ action: @Sendable @escaping (BaseContextCommand, InteractionExtras) async throws -> Void
  ) -> Self {
    var copy = self
    copy._preActions.append(action)
    return copy
  }

  public func postAction(
    _ action: @Sendable @escaping (BaseContextCommand, InteractionExtras) async throws -> Void
  ) -> Self {
    var copy = self
    copy._postActions.append(action)
    return copy
  }

  public func catchAction(
    _ action:
      @Sendable @escaping (any Error, BaseContextCommand, InteractionExtras) async throws ->
      Void
  ) -> Self {
    var copy = self
    copy._errorActions.append(action)
    return copy
  }

  public func boot(
    _ action: @Sendable @escaping (BaseContextCommand, BotInstance) async throws -> Void
  ) -> Self {
    var copy = self
    copy._bootActions.append(action)
    return copy
  }

  var _errorActions:
    [@Sendable (any Error, BaseContextCommand, InteractionExtras) async throws -> Void]
  {
    get {
      self._self.actions.errorActions
    }
    set {
      var copy = self._self
      copy.actions.errorActions = newValue
      self = copy as! Self
    }
  }
  var _preActions: [@Sendable (BaseContextCommand, InteractionExtras) async throws -> Void] {
    get {
      self._self.actions.preActions
    }
    set {
      var copy = self._self
      copy.actions.preActions = newValue
      self = copy as! Self
    }
  }
  var _postActions: [@Sendable (BaseContextCommand, InteractionExtras) async throws -> Void] {
    get {
      self._self.actions.postActions
    }
    set {
      var copy = self._self
      copy.actions.postActions = newValue
      self = copy as! Self
    }
  }
  var _bootActions: [@Sendable (BaseContextCommand, BotInstance) async throws -> Void] {
    get {
      self._self.actions.bootActions
    }
    set {
      var copy = self._self
      copy.actions.bootActions = newValue
      self = copy as! Self
    }
  }
}

extension ExtensibleCommand {
  var _self: _ExtensibleCommand {
    return self as! _ExtensibleCommand  // will always work trust
  }
}
