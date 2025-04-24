//
//  DiscordBotAppProtocol.swift
//
//
//  Created by Lakhan Lothiyi on 22/03/2024.
//

import DiscordBM
import Foundation
import AsyncHTTPClient

/// This protocol is applied to the struct that your bot runs with.
@MainActor
public protocol DiscordBotApp {
  /// Set this to either a `BotGatewayManager` or `ShardingGatewayManager`
  var bot: Bot { get set }
  /// Set this to a `DiscordCache` instance
  var cache: Cache { get set }
  /// Useful typealiases
  typealias Bot = GatewayManager
  typealias Cache = DiscordCache
  
  /// Scenes
  @MainActor @BotSceneBuilder var body: [any BotScene] { get }
  
  /// Initialization
  init() async
  /// Allows you to make configurations to the bot after initialisation and before bot connection.
  func onBoot() async throws
}

nonisolated(unsafe) public var _BotInstances: [ApplicationSnowflake: BotInstance] = [:]
