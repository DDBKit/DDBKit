//
//  CommandOption.swift
//
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation
import DiscordModels

/// Generic option protocol
public protocol Option {
  var optionData: ApplicationCommand.Option { get set }
}

/// Signifies that a type can have choices
public protocol ChoiceOption: Option { }

/// Signifies that a type can have ranges
public protocol RangedOption: Option { }

/// Signifies that a type can have autocompletions provided
public protocol AutocompletableOption: Option { }
/// setting protocols public requires that their properties be public to match
/// so we'll just avoid that by using this internal type instead
internal protocol _AutocompletableOption: Option, AutocompletableOption { // swiftlint:disable:this type_name
  var autocompletion: ((StringIntDoubleBool) async -> [StringIntDoubleBool])? { get set }
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
// ``DiscordModels.ApplicationCommand.Option.Kind``
// ApplicationCommand.Option.Kind

/// A string option
public struct StringOption: Option, _AutocompletableOption, ChoiceOption {
  internal var autocompletion: ((StringIntDoubleBool) async -> [StringIntDoubleBool])?
  public var optionData: DiscordModels.ApplicationCommand.Option
  
  public init(name: String, description: String) {
    self.optionData = .init(type: .string, name: name, description: description)
  }
}

/// An integer option
public struct IntOption: Option, _AutocompletableOption, ChoiceOption, RangedOption {
  public var autocompletion: ((StringIntDoubleBool) async -> [StringIntDoubleBool])?
  public var optionData: DiscordModels.ApplicationCommand.Option
  
  public init(name: String, description: String) {
    self.optionData = .init(type: .integer, name: name, description: description)
  }
}

/// A boolean option
public struct BoolOption: Option {
  public var optionData: DiscordModels.ApplicationCommand.Option
  
  public init(name: String, description: String) {
    self.optionData = .init(type: .boolean, name: name, description: description)
  }
}

/// A user option
public struct UserOption: Option {
  public var optionData: DiscordModels.ApplicationCommand.Option
  
  public init(name: String, description: String) {
    self.optionData = .init(type: .user, name: name, description: description)
  }
}

/// A channel option
public struct ChannelOption: Option {
  public var optionData: DiscordModels.ApplicationCommand.Option
  
  public init(name: String, description: String) {
    self.optionData = .init(type: .channel, name: name, description: description)
  }
}

/// A role option
public struct RoleOption: Option {
  public var optionData: DiscordModels.ApplicationCommand.Option
  
  public init(name: String, description: String) {
    self.optionData = .init(type: .role, name: name, description: description)
  }
}

/// Any mentionable entity (users, roles)
public struct MentionableOption: Option {
  public var optionData: DiscordModels.ApplicationCommand.Option
  
  public init(name: String, description: String) {
    self.optionData = .init(type: .mentionable, name: name, description: description)
  }
}

/// A number option that can be non-integer between the same ranges
public struct DoubleOption: Option, _AutocompletableOption, ChoiceOption, RangedOption {
  public var autocompletion: ((StringIntDoubleBool) async -> [StringIntDoubleBool])?
  public var optionData: DiscordModels.ApplicationCommand.Option
  
  public init(name: String, description: String) {
    self.optionData = .init(type: .number, name: name, description: description)
  }
}

/// An uploadable attachment
public struct AttachmentOption: Option {
  public var optionData: DiscordModels.ApplicationCommand.Option
  
  public init(name: String, description: String) {
    self.optionData = .init(type: .attachment, name: name, description: description)
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
public extension AutocompletableOption {
  /// Allows configuration of a callback that provides autocomplete to users, return an array of choices.
  /// - Parameter completion: Autocomplete handler
  func autocompletions(_ completion: @escaping (StringIntDoubleBool) async -> [StringIntDoubleBool]) -> Self {
    var copy = self as! _AutocompletableOption // will always work
    copy.autocompletion = completion // set autocompletion callback on self
    copy.optionData.autocomplete = true
    return copy as! Self
  }
}

public extension ChoiceOption {
  func choices(_ choices: () -> ([StringIntDoubleBool])) -> Self {
    var copy = self
    let c = choices()
    copy.optionData.choices = c.map { .init(name: $0.asString, value: $0) }
    return copy
  }
}

public extension RangedOption {
  
}
// ApplicationCommand.Option(
//    type: <#T##ApplicationCommand.Option.Kind#>,
//    name: <#T##String#>,
//    name_localizations: <#T##[DiscordLocale : String]?#>,
//    description: <#T##String#>,
//    description_localizations: <#T##[DiscordLocale : String]?#>,
//    required: <#T##Bool?#>,
//    choices: <#T##[ApplicationCommand.Option.Choice]?#>,
//    options: <#T##[ApplicationCommand.Option]?#>,
//    channel_types: <#T##[DiscordChannel.Kind]?#>,
//    min_value: <#T##IntOrDouble?#>,
//    max_value: <#T##IntOrDouble?#>,
//    min_length: <#T##Int?#>,
//    max_length: <#T##Int?#>,
//    autocomplete: <#T##Bool?#>
// )

@resultBuilder
public struct CommandOptionsBuilder {
  public static func buildBlock(_ components: Option...) -> [Option] {
    return components
  }
}
