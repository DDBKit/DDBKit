//
//  TextField.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//

import DiscordBM

/// A text field component, to be used in modals.
public struct TextField: _MessageComponentsActionRowComponent {
  var component: Interaction.ActionRow.Component {
    .textInput(self.object)
  }
  var object: Interaction.ActionRow.TextInput
  public init(_ label: String) {
    self.object = .init(custom_id: "", style: .short, label: label)
  }
}

extension TextField {
  /// A custom identifier to target this component
  /// - Parameter id: ID
  public func id(_ id: String) -> Self {
    var copy = self
    copy.object.custom_id = id
    return copy
  }

  /// The style of text field to use.
  /// - Parameter style: Short or paragraph
  public func style(_ style: Interaction.ActionRow.TextInput.Style) -> Self {
    var copy = self
    copy.object.style = style
    return copy
  }

  // its better to have this in the initialiser
  //  / Label to describe the field with.s
  //  / - Parameter lbl: Label string
  //  func label(_ lbl: String) -> Self {
  //    var copy = self
  //    copy.object.label = lbl
  //    return copy
  //  }

  /// Minimum and maximum length that the field value can be.
  /// - Parameter range: Closed range
  public func length(_ range: ClosedRange<Int>) -> Self {
    var copy = self
    copy.object.max_length = range.upperBound
    copy.object.min_length = range.lowerBound
    return copy
  }
  /// Minimum and maximum length that the field value can be.
  /// - Parameter range: Range
  public func length(_ range: Range<Int>) -> Self {
    var copy = self
    copy.object.max_length = range.upperBound
    copy.object.min_length = range.lowerBound
    return copy
  }

  /// Whether or not the field is required to be satisfied.
  /// - Parameter bool: Required
  public func required(_ bool: Bool) -> Self {
    var copy = self
    copy.object.required = bool
    return copy
  }

  /// The default value to fill into the field.
  /// - Parameter value: String
  public func defaultValue(_ value: String) -> Self {
    var copy = self
    copy.object.value = value
    return copy
  }

  /// The placeholder text to show when the field is empty.
  /// - Parameter value: Placeholder
  public func placeholder(_ value: String) -> Self {
    var copy = self
    copy.object.placeholder = value
    return copy
  }
}
