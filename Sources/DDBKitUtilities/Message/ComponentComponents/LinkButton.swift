//
//  LinkButton.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 10/10/2024.
//

import DiscordBM

/// A button component, to be used in message components to take users to a link.
public struct LinkButton: _MessageComponentsActionRowComponent {
  var component: Interaction.ActionRow.Component {
    .button(self.object)
  }
  var object: Interaction.ActionRow.Button
  
  public init(_ label: String, url: String) {
    self.object = .init(label: label, url: url)
  }
  public init(_ emoji: Emoji, url: String) {
    self.object = .init(emoji: emoji, url: url)
  }
  public init(_ label: String, _ emoji: Emoji, url: String) {
    self.object = .init(label: label, emoji: emoji, url: url)
  }
}

public extension LinkButton {
  
  /// Disable the button from clicking.
  /// - Parameter bool: Disabled state
  func disabled(_ bool: Bool = true) -> Self {
    var copy = self
    copy.object.disabled = bool
    return copy
  }
  
//  /// Sets the button style.
//  /// - Parameter style: Button style
//  func style(_ style: Interaction.ActionRow.Button.Style) -> Self {
//    var copy = self
//    copy.object.style = style
//    return copy
//  }
  
//  /// Sets the button ID.
//  /// - Parameter id: Button ID
//  func id(_ id: String) -> Self {
//    var copy = self
//    copy.object.custom_id = id
//    return copy
//  }
}
