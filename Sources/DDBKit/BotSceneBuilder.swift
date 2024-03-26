//
//  BotSceneBuilder.swift
//
//
//  Created by Lakhan Lothiyi on 22/03/2024.
//

import Foundation
import DiscordBM

public protocol BotScene {
}


@resultBuilder 
public struct BotSceneBuilder {
  public static func buildBlock(_ components: BotScene...) -> [BotScene] {
    components
  }
}
