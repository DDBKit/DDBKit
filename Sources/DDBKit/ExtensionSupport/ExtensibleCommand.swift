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

@_spi(Extensions)
public extension ExtensibleCommand {
  var baseInfo: Payloads.ApplicationCommandCreate {
    get {
      (self as! BaseContextCommand).baseInfo
    }
    set {
      var copy = (self as! BaseContextCommand)
      copy.baseInfo = newValue
      self = copy as! Self
    }
  }
  
  var guildScope: CommandGuildScope {
    get {
      (self as! BaseContextCommand).guildScope
    }
    set {
      var copy = (self as! BaseContextCommand)
      copy.guildScope = newValue
      self = copy as! Self
    }
  }
}
