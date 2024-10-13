//
//  StringMenu.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 10/10/2024.
//

import DiscordBM

/// A dropdown component, to be used in message components to select a string value.
public struct StringMenu: _MessageComponentsActionRowComponent {
  var component: DiscordModels.Interaction.ActionRow.Component {
    .stringSelect(self.object)
  }
  var object: Interaction.ActionRow.StringSelectMenu
  
  public init(_ placeholder: String? = nil, @GenericBuilder<StringMenuOption> _ options: () -> GenericTuple<StringMenuOption>) {
    self.object = .init(
      custom_id: "",
      options: options().values.map(\.obj),
      placeholder: placeholder,
      min_values: nil,
      max_values: nil,
      disabled: nil
    )
  }
}

public extension StringMenu {
  
  /// Disable the button from clicking.
  /// - Parameter bool: Disabled state
  func disabled(_ bool: Bool = true) -> Self {
    var copy = self
    copy.object.disabled = bool
    return copy
  }
  
  /// Sets the number of choices to choose from.
  /// - Parameter choicesRange: Range
  func choices(_ choicesRange: Range<Int>) -> Self {
    var copy = self
    copy.object.min_values = choicesRange.lowerBound
    copy.object.max_values = choicesRange.upperBound
    return copy
  }
  /// Sets the number of choices to choose from.
  /// - Parameter choicesRange: Range
  func choices(_ choicesRange: ClosedRange<Int>) -> Self {
    var copy = self
    copy.object.min_values = choicesRange.lowerBound
    copy.object.max_values = choicesRange.upperBound
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

public struct StringMenuOption {
  var obj: Interaction.ActionRow.StringSelectMenu.Option
  
  public init(_ label: String) {
    self.obj = .init(
      label: label,
      value: label,
      description: nil,
      emoji: nil,
      default: nil
    )
  }
}

public extension StringMenuOption {
  /// Add a description to this menu option
  /// - Parameter str: Description
  func description(_ str: String) -> Self {
    var copy = self
    copy.obj.description = str
    return self
  }
  
  /// Set an emoji for this option
  /// - Parameter emoji: Emoji
  func emoji(_ emoji: Emoji) -> Self {
    var copy = self
    copy.obj.emoji = emoji
    return self
  }
  
  /// Set this option as the default option
  /// - Parameter bool: Default bool
  func `default`(_ bool: Bool) -> Self {
    var copy = self
    copy.obj.default = bool
    return self
  }
}

