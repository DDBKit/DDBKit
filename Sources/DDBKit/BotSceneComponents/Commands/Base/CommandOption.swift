//
//  CommandOption.swift
//
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import DiscordModels
import Foundation

/// Generic option protocol
public protocol Option: Sendable {
  var optionData: ApplicationCommand.Option { get set }
}

/// Signifies that a type can have choices
public protocol ChoiceOption: Option {}

/// Signifies that a type can have ranges
public protocol RangedOption: Option {}

public protocol LengthLimitedOption: Option {}

/// Signifies that a type can have autocompletions provided
public protocol AutocompletableOption: Option {}
/// setting protocols public requires that their properties be public to match
/// so we'll just avoid that by using this internal type instead
internal protocol _AutocompletableOption: Option, AutocompletableOption {  // swiftlint:disable:this type_name
  var autocompletion:
    (
      @Sendable (
        Interaction.ApplicationCommand.Option, Interaction.ApplicationCommand
      ) async -> [ApplicationCommand.Option.Choice]
    )?
  { get set }
}

// MARK: - Define all kinds of options
// below are unfinished option types
// subCommand // 1
// subCommandGroup // 2
// user // 6
// channel // 7
// role // 8
// mentionable // 9
// attachment // 11
// __undocumented(UInt)
// ``ApplicationCommand.Option.Kind``
// ApplicationCommand.Option.Kind

/// A string option
public struct StringOption: Option, _AutocompletableOption, ChoiceOption,
  LengthLimitedOption
{
  internal var autocompletion:
    (
      @Sendable (
        Interaction.ApplicationCommand.Option, Interaction.ApplicationCommand
      ) async -> [ApplicationCommand.Option.Choice]
    )?
  @_spi(Extensions) public var optionData: ApplicationCommand.Option

  public init(name: String, description: String) {
    self.optionData = .init(type: .string, name: name, description: description)
  }
}

/// An integer option
public struct IntOption: Option, _AutocompletableOption, ChoiceOption,
  RangedOption
{
  internal var autocompletion:
    (
      @Sendable (
        Interaction.ApplicationCommand.Option, Interaction.ApplicationCommand
      ) async -> [ApplicationCommand.Option.Choice]
    )?
  @_spi(Extensions) public var optionData: ApplicationCommand.Option

  public init(name: String, description: String) {
    self.optionData = .init(
      type: .integer,
      name: name,
      description: description
    )
  }
}

/// A boolean option
public struct BoolOption: Option {
  @_spi(Extensions) public var optionData: ApplicationCommand.Option

  public init(name: String, description: String) {
    self.optionData = .init(
      type: .boolean,
      name: name,
      description: description
    )
  }
}

/// A user option
public struct UserOption: Option {
  @_spi(Extensions) public var optionData: ApplicationCommand.Option

  public init(name: String, description: String) {
    self.optionData = .init(type: .user, name: name, description: description)
  }
}

/// A channel option
public struct ChannelOption: Option {
  @_spi(Extensions) public var optionData: ApplicationCommand.Option

  public init(name: String, description: String) {
    self.optionData = .init(
      type: .channel,
      name: name,
      description: description
    )
  }
}

/// A role option
public struct RoleOption: Option {
  @_spi(Extensions) public var optionData: ApplicationCommand.Option

  public init(name: String, description: String) {
    self.optionData = .init(type: .role, name: name, description: description)
  }
}

/// Any mentionable entity (users, roles)
public struct MentionableOption: Option {
  @_spi(Extensions) public var optionData: ApplicationCommand.Option

  public init(name: String, description: String) {
    self.optionData = .init(
      type: .mentionable,
      name: name,
      description: description
    )
  }
}

/// A number option that can be non-integer between the same ranges
public struct DoubleOption: Option, _AutocompletableOption, ChoiceOption,
  RangedOption
{
  internal var autocompletion:
    (
      @Sendable (
        Interaction.ApplicationCommand.Option, Interaction.ApplicationCommand
      ) async -> [ApplicationCommand.Option.Choice]
    )?
  @_spi(Extensions) public var optionData: ApplicationCommand.Option

  public init(name: String, description: String) {
    self.optionData = .init(type: .number, name: name, description: description)
  }
}

/// An uploadable attachment
public struct AttachmentOption: Option {
  @_spi(Extensions) public var optionData: ApplicationCommand.Option

  public init(name: String, description: String) {
    self.optionData = .init(
      type: .attachment,
      name: name,
      description: description
    )
  }
}

// MARK: - Global option modifiers
extension Option {
  /// Configures whether or not the option is required to use the command
  /// - Parameter isRequired: requirement
  public func required(_ isRequired: Bool = true) -> Self {
    var copy = self
    copy.optionData.required = isRequired
    return copy
  }
}

// MARK: - Specialised option modifiers
extension AutocompletableOption {
  /// Allows configuration of a callback that provides autocomplete to users, return an array of `choice` objects.
  /// - Parameter completion: Autocomplete handler
  public func autocompletions(
    _ completion: @Sendable @escaping
    (Interaction.ApplicationCommand.Option, Interaction.ApplicationCommand)
      async -> [ApplicationCommand.Option.Choice]

  ) -> Self {
    var copy = self as! _AutocompletableOption  // will always work
    copy.autocompletion = completion  // set autocompletion callback on self
    copy.optionData.autocomplete = true
    return copy as! Self
  }

  /// Allows configuration of a callback that provides autocomplete to users, return an array of choices.
  /// - Parameter completion: Autocomplete handler
  public func autocompletions(
    _ completion: @Sendable @escaping (StringIntDoubleBool?) async ->
      [StringIntDoubleBool]
  ) -> Self {
    var copy = self as! _AutocompletableOption  // will always work
    copy.autocompletion = { option, _ in
      let options = await completion(option.value)  // generally discord returns empty strings
      return options.map { .init(name: $0.asString, value: $0) }
    }
    copy.optionData.autocomplete = true
    return copy as! Self
  }
}

extension ChoiceOption {
  public func choices(_ choices: () -> ([StringIntDoubleBool])) -> Self {
    var copy = self
    let c = choices()
    copy.optionData.choices = c.map { .init(name: $0.asString, value: $0) }
    return copy
  }

  public func choices(_ choices: () -> [ApplicationCommand.Option.Choice])
    -> Self
  {
    var copy = self
    copy.optionData.choices = choices()
    return copy
  }
}

extension RangedOption {
  // use range and closedrange types to set min and max values

  /// Sets the ranged values for the option
  /// - Parameter range: Range
  /// - Returns: Self
  public func range(_ range: Range<Int>) -> Self {
    var copy = self
    copy.optionData.min_value = .int(range.lowerBound)
    copy.optionData.max_value = .int(range.upperBound)
    return copy
  }
  /// Sets the ranged values for the option
  /// - Parameter range: ClosedRange
  /// - Returns: Self
  public func range(_ range: ClosedRange<Int>) -> Self {
    var copy = self
    copy.optionData.min_value = .int(range.lowerBound)
    copy.optionData.max_value = .int(range.upperBound)
    return copy
  }

  /// Sets the ranged values for the option
  /// - Parameter range: Range
  /// - Returns: Self
  public func range(_ range: Range<Double>) -> Self {
    var copy = self
    copy.optionData.min_value = .double(range.lowerBound)
    copy.optionData.max_value = .double(range.upperBound)
    return copy
  }
  /// Sets the ranged values for the option
  /// - Parameter range: ClosedRange
  /// - Returns: Self
  public func range(_ range: ClosedRange<Double>) -> Self {
    var copy = self
    copy.optionData.min_value = .double(range.lowerBound)
    copy.optionData.max_value = .double(range.upperBound)
    return copy
  }
}

extension LengthLimitedOption {
  /// Sets the length range of the option
  public func length(_ range: Range<Int>) -> Self {
    var copy = self
    copy.optionData.min_length = range.lowerBound
    copy.optionData.max_length = range.upperBound
    return copy
  }
}

@resultBuilder
public struct CommandOptionsBuilder {
  public static func buildBlock(_ components: Option...) -> [Option] {
    return components
  }
}
