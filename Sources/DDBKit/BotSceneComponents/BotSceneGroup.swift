//
//  SceneComponent.swift
//
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import Foundation

/// this gets flattened in the ``BotSceneBuilder``

/// Container scene for Events and Commands or any other kind of scene
public struct Group: BotScene {
  public init(@BotSceneBuilder body: () -> [BotScene]) {
    self.scene = body()
  }
  var scene: [BotScene]
  
  init(scene: [BotScene]) {
    self.scene = scene
  }
}
