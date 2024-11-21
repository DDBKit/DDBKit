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
