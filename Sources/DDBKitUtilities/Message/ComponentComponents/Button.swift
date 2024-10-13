//
//  LinkButton.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 10/10/2024.
//

import DiscordBM

/// A button component, to be used in message components to take users to a link.
public struct Button: _MessageComponentsActionRowComponent {
  var component: DiscordModels.Interaction.ActionRow.Component {
    .button(self.object)
  }
  var object: Interaction.ActionRow.Button
  
  public init(_ label: String) {
    self.object = .init(style: .primary, label: label, custom_id: "")
  }
  public init(_ emoji: Emoji) {
    self.object = .init(style: .primary, emoji: emoji, custom_id: "")
  }
  public init(_ label: String, _ emoji: Emoji) {
    self.object = .init(style: .primary, label: label, emoji: emoji, custom_id: "")
  }
}

public extension Button {
  
  /// Disable the button from clicking.
  /// - Parameter bool: Disabled state
  func disabled(_ bool: Bool = true) -> Self {
    var copy = self
    copy.object.disabled = bool
    return copy
  }
  
  /// Sets the button style.
  /// - Parameter style: Button style
  func style(_ style: Interaction.ActionRow.Button.NonLinkStyle) -> Self {
    var copy = self
    copy.object.style = style.toStyle()
    return copy
  }
  
  /// Sets the button ID.
  /// - Parameter id: Button ID
  func id(_ id: String) -> Self {
    var copy = self
    copy.object.custom_id = id
    return copy
  }
}
