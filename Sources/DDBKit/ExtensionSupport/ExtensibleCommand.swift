//
//  ExtensibleCommand.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 23/10/2024.
//

import DiscordBM

/// This protocol defines commands that can expose methods to extensions.
@_spi(Extensions)
public protocol ExtensibleCommand {
}

protocol _ExtensibleCommand: ExtensibleCommand {
  var preActions: [(CommandDescription, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] { get set }
  var postActions: [(CommandDescription, GatewayManager, DiscordCache, Interaction, DatabaseBranches) async throws -> Void] { get set }
}

/// A struct that contains read-only information about a command, to be used in extensions
@_spi(Extensions)
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
