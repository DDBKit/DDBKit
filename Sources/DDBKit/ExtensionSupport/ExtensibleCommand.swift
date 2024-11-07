//
//  ExtensibleCommand.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 23/10/2024.
//

import DiscordBM
import Foundation

/// This protocol defines commands that can expose methods to extensions.
@_spi(Extensions)
public protocol ExtensibleCommand {
}

protocol _ExtensibleCommand: ExtensibleCommand {
  var preActions: [(BaseContextCommand, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] { get set }
  var postActions: [(BaseContextCommand, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] { get set }
  var errorActions: [(any Error, BaseContextCommand, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] { get set }
}

/// A struct that contains read-only information about a command, to be used in extensions
//public struct CommandDescription {
//  public internal(set) var info: Payloads.ApplicationCommandCreate
//  public internal(set) var scope: CommandGuildScope
//}

@_spi(Extensions)
extension ExtensibleCommand {
  var _self: _ExtensibleCommand {
    self as! _ExtensibleCommand // will always work trust 💪
  }
}

@_spi(Extensions)
public extension BaseContextCommand {
  var preActions: [(BaseContextCommand, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] {
    get {
      let e = self as! _ExtensibleCommand
      return e.preActions
    }
    set {
      var e = self as! _ExtensibleCommand
      e.preActions = newValue
      self = e as! Self
    }
  }
  var postActions: [(BaseContextCommand, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] {
    get {
      let e = self as! _ExtensibleCommand
      return e.postActions
    }
    set {
      var e = self as! _ExtensibleCommand
      e.postActions = newValue
      self = e as! Self
    }
  }
}

@_spi(Extensions)
public extension ExtensibleCommand {
  func preAction(_ action: @escaping (BaseContextCommand, GatewayManager, DiscordCache, Interaction, DatabaseBranches) -> Void) -> Self {
    var copy = self
    copy.preActions.append(action)
    return copy
  }
  
  func postAction(_ action: @escaping (BaseContextCommand, GatewayManager, DiscordCache, Interaction, DatabaseBranches) -> Void) -> Self {
    var copy = self
    copy.postActions.append(action)
    return copy
  }
  
  func catchAction(_ action: @escaping (any Error, BaseContextCommand, GatewayManager, DiscordCache, Interaction, DatabaseBranches) -> Void) -> Self {
    var copy = self
    copy.errorActions.append(action)
    return copy
  }
  
  func boot(_ action: @escaping (BaseContextCommand) async throws -> Void) -> Self {
    let cmd = (self as! BaseContextCommand)
    Task { @MainActor in
      try! await action(cmd)
    }
    return self
  }
  
  var errorActions: [(any Error, BaseContextCommand, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] {
    get {
      self._self.errorActions
    }
    set {
      var copy = self._self
      copy.errorActions = newValue
      self = copy as! Self
    }
  }
  var preActions: [(BaseContextCommand, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] {
    get {
      self._self.preActions
    }
    set {
      var copy = self._self
      copy.preActions = newValue
      self = copy as! Self
    }
  }
  var postActions: [(BaseContextCommand, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] {
    get {
      self._self.postActions
    }
    set {
      var copy = self._self
      copy.postActions = newValue
      self = copy as! Self
    }
  }
}
