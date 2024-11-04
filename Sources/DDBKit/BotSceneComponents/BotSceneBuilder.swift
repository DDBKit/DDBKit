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
  
  // Builds an optional component, returning an empty tuple if nil
  public static func buildOptional(_ component: [BotScene]?) -> BotScene {
    Group(scene: component ?? [])
  }
  
  // For conditional logic: if the first option is selected, return it
  public static func buildEither(first component: [BotScene]) -> BotScene {
    Group(scene: component)
  }
  
  // For conditional logic: if the second option is selected, return it
  public static func buildEither(second component: [BotScene]) -> BotScene {
    Group(scene: component)
  }
  
  // Build an array of T directly into a tuple
  public static func buildArray(_ components: [[BotScene]]) -> BotScene {
    Group(scene: components.flatMap { $0 })
  }
  
  // Build a single component
  public static func buildExpression(_ expression: BotScene) -> BotScene {
    expression
  }
  
  public static func expandScenes(_ scenes: [BotScene]) -> [BotScene] {
    var expandedScenes = [BotScene]()
    for scene in scenes {
      if let group = scene as? Group {
        expandedScenes.append(contentsOf: expandScenes(group.scene))
      } else {
        expandedScenes.append(scene)
      }
    }
    return expandedScenes
  }
}
