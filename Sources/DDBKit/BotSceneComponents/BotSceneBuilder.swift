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
    var scenes = [BotScene]()
    components.forEach { scene in
      if let group = scene as? Group {
        // scene was group, extract
        scenes.append(contentsOf: expandGroup(group: group))
      } else {
        // scene didnt contain children
        scenes.append(scene)
      }
    }
    return scenes
  }
  
  
  
  private static func expandGroup(group: Group) -> [BotScene] { group.scene }
}
