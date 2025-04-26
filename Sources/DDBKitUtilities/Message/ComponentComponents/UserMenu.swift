//
//  StringMenu.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 10/10/2024.
//

import DiscordBM

/// A dropdown component, to be used in message components to select users.
public struct UserMenu: _MessageComponentsActionRowComponent {
  var component: Interaction.ActionRow.Component {
    .userSelect(self.object)
  }
  var object: Interaction.ActionRow.SelectMenu

  public init(_ placeholder: String? = nil) {
    self.object = .init(
      custom_id: "",
      placeholder: placeholder,
      default_values: nil,
      min_values: nil,
      max_values: nil,
      disabled: nil
    )
  }
}

extension UserMenu {

  /// Disable the button from clicking.
  /// - Parameter bool: Disabled state
  public func disabled(_ bool: Bool = true) -> Self {
    var copy = self
    copy.object.disabled = bool
    return copy
  }

  /// Sets the number of choices to choose from.
  /// - Parameter choicesRange: Range
  public func choices(_ choicesRange: Range<Int>) -> Self {
    var copy = self
    copy.object.min_values = choicesRange.lowerBound
    copy.object.max_values = choicesRange.upperBound
    return copy
  }
  /// Sets the number of choices to choose from.
  /// - Parameter choicesRange: Range
  public func choices(_ choicesRange: ClosedRange<Int>) -> Self {
    var copy = self
    copy.object.min_values = choicesRange.lowerBound
    copy.object.max_values = choicesRange.upperBound
    return copy
  }

  /// Set the default selected values of the menu.
  /// - Parameter values: Default values
  public func defaultValues(_ values: [ChannelSnowflake]) -> Self {
    var copy = self
    copy.object.default_values = values.map { .init(id: $0) }
    return copy
  }

  /// Sets the button ID.
  /// - Parameter id: Button ID
  public func id(_ id: String) -> Self {
    var copy = self
    copy.object.custom_id = id
    return copy
  }
}
