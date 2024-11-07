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
  var preActions: [(CommandDescription, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] { get set }
  var postActions: [(CommandDescription, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] { get set }
}

/// A struct that contains read-only information about a command, to be used in extensions
public struct CommandDescription {
  public internal(set) var info: Payloads.ApplicationCommandCreate
  public internal(set) var scope: CommandGuildScope
}

@_spi(Extensions)
extension ExtensibleCommand {
  var _self: _ExtensibleCommand {
    self as! _ExtensibleCommand // will always work trust 💪
  }
}

@_spi(Extensions)
public extension ExtensibleCommand {
  func preAction(_ action: @escaping (CommandDescription, GatewayManager, DiscordCache, Interaction, DatabaseBranches) -> Void) -> Self {
    var copy = self._self
    copy.preActions.append(action)
    return copy as! Self
  }
  
  func postAction(_ action: @escaping (CommandDescription, GatewayManager, DiscordCache, Interaction, DatabaseBranches) -> Void) -> Self {
    var copy = self._self
    copy.postActions.append(action)
    return copy as! Self
  }
  
  var preActions: [(CommandDescription, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] {
    get {
      self._self.preActions
    }
    set {
      var copy = self._self
      copy.preActions = newValue
      self = copy as! Self
    }
  }
  var postActions: [(CommandDescription, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] {
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
