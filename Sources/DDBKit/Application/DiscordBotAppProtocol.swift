//
//  DiscordBotAppProtocol.swift
//
//
//  Created by Lakhan Lothiyi on 22/03/2024.
//

import DiscordBM
import Foundation
import AsyncHTTPClient
import SwiftUI

/// This protocol is applied to the struct that your bot runs with.
public protocol DiscordBotApp {
  /// Set this to either a `BotGatewayManager` or `ShardingGatewayManager`
  var bot: Bot { get set }
  var cache: Cache { get set }
  typealias Bot = GatewayManager
  typealias Cache = DiscordCache
  @BotSceneBuilder var body: [BotScene] { get }
  
  init() async
}
