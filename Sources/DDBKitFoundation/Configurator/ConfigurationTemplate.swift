//
//  ConfigurationTemplate.swift
//
//
//  Created by Lakhan Lothiyi on 11/11/2024.
//

@_spi(Extensions) import DDBKit
import Database
import Foundation

public protocol ConfigurationTemplate: DatabaseModel, Codable {
  func toDictionary() -> [String: Any]
  static func fromDictionary(_ dict: [String: Any]) throws -> Self

  init()
}

extension ConfigurationTemplate {
  public func toDictionary() -> [String: Any] {
    let data = try! enc.encode(self)
    let serialized = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    return serialized
  }

  public static func fromDictionary(_ dict: [String: Any]) throws -> Self {
    let obj = try dec.decode(Self.self, from: JSONSerialization.data(withJSONObject: dict))
    return obj
  }

  // extract properties marked with Config attribute, then get name and descriptions
  public func mirror() {
  }
}

private let enc = JSONEncoder()
private let dec = JSONDecoder()
