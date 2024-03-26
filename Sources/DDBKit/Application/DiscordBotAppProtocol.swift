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
  var bot: Bot { get set }
  typealias Bot = BotGatewayManager
  @BotSceneBuilder var body: [BotScene] { get }
  
  init() async
}




