//
//  SceneComponent.swift
//
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import Foundation

public struct Group: BotScene {
  public init(@BotSceneBuilder body: () -> [BotScene]) {
    self.scene = body()
  }
  var scene: [BotScene]
}
