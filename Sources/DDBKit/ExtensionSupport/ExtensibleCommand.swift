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
  var actions: ActionInterceptions { get set }
}

@_spi(Extensions)
public struct ActionInterceptions {
  var preActions: [(BaseContextCommand, InteractionExtras) async throws -> Void] = []
  var postActions: [(BaseContextCommand, InteractionExtras) async throws -> Void] = []
  var errorActions: [(any Error, BaseContextCommand, InteractionExtras) async throws -> Void] = []
  var bootActions: [(BaseContextCommand, BotInstance) async throws -> Void] = []
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
