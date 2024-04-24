//
//  SceneComponent.swift
//
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import Foundation

/// Ok so the whole idea of `SceneComponent`s are that they
/// are command or event equivalents but offer more functionality.
/// Like more contextual data or more utilities

protocol SceneComponent: BotScene {
  var context: SceneContext { get set }
}

/// Contains relevant scene data
struct SceneContext {
    let id: String
    // Other properties if needed
}

