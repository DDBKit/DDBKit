//
//  Config.swift
//
//
//  Created by Lakhan Lothiyi on 11/11/2024.
//

@_spi(Extensions) import DDBKit
import Database
import Foundation

@propertyWrapper
public struct Config<Value: Sendable & Codable>: Codable, Sendable {
  private var value: Value
  private let name: String
  private let description: String

  public var wrappedValue: Value {
    get { value }
    set { value = newValue }
  }

  public init(name: String, description: String, initialValue: Value) {
    self.name = name
    self.description = description
    self.value = initialValue
  }

  // Codable implementation
  private enum CodingKeys: String, CodingKey {
    case value
    case metadata
  }

  private enum MetadataKeys: String, CodingKey {
    case name
    case description
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.value = try container.decode(Value.self, forKey: .value)

    let metadataContainer = try container.nestedContainer(
      keyedBy: MetadataKeys.self, forKey: .metadata)
    self.name = try metadataContainer.decode(String.self, forKey: .name)
    self.description = try metadataContainer.decode(String.self, forKey: .description)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(value, forKey: .value)

    var metadataContainer = container.nestedContainer(keyedBy: MetadataKeys.self, forKey: .metadata)
    try metadataContainer.encode(name, forKey: .name)
    try metadataContainer.encode(description, forKey: .description)
  }
}

public protocol EnumOptionType: RawRepresentable, CaseIterable, Codable {
  var rawValue: String { get }
}

/// Protocols for defining configuration options
/// GuildConfiguration
/// ChannelConfiguration
/// MemberConfiguration
/// RoleConfiguration
/// UserConfiguration
