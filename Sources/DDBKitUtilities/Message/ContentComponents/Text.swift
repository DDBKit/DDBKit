//
//  Text.swift
//  
//
//  Created by Lakhan Lothiyi on 21/04/2024.
//

import Foundation

// https://www.markdownguide.org/tools/discord/

@resultBuilder
public struct TextBuilder {
  public static func buildBlock(_ components: Text...) -> [Text] { components }
  public static func buildOptional(_ component: [Text]?) -> Text { Text.init(components: component ?? []) }
  public static func buildEither(first component: [Text]) -> Text { Text.init(components: component) }
  public static func buildEither(second component: [Text]) -> Text { Text.init(components: component) }
  public static func buildArray(_ components: [[Text]]) -> Text { Text(components: components.map { Text(components: $0) }) }
}

public struct Text: MessageContentComponent {
  var txt: String
  var fmt: FMTOptions
  
  
  public init(
    _ str: String,
    fmt: FMTOptions = []
  ) {
    self.fmt = fmt
    self.txt = str
  }
  
  init(
    fmt: FMTOptions = [],
    components: [Text]
  ) {
    self.fmt = fmt
    self.txt = components.reduce("", { partialResult, txt in
      return partialResult + txt.textualRepresentation.trimmingCharacters(in: .newlines)
    })
  }
  
  public init(
    fmt: FMTOptions = [],
    @TextBuilder components: () -> [Text]
  ) {
    self.fmt = fmt
    self.txt = components().reduce("", { partialResult, txt in
      return partialResult + txt.textualRepresentation.trimmingCharacters(in: .newlines)
    })
  }
  
  public var textualRepresentation: String {
    "\(fmt.startKey)\(txt)\(fmt.endKey)\(txt.isEmpty ? "" : "\n")"
  }
  
  public struct FMTOptions: OptionSet {
    public init(rawValue: UInt) { self.rawValue = rawValue }
    public let rawValue: UInt
    
    public static let bold = Self(rawValue: 1 << 0)
    public static let italic = Self(rawValue: 1 << 1)
    public static let strikethrough = Self(rawValue: 1 << 2)
    public static let underline = Self(rawValue: 1 << 3)
    public static let spoiler = Self(rawValue: 1 << 4)
    
    // rest in piece
    // here lies raunak
    public var startKey: String {
      var key: String = ""
      if self.contains(.bold) { key += "**" }
      if self.contains(.italic) { key += "*" }
      if self.contains(.strikethrough) { key += "~~" }
      if self.contains(.underline) { key += "__" }
      if self.contains(.spoiler) { key += "||" }
      return key
    }
    public var endKey: String {
      var key: String = ""
      if self.contains(.bold) { key += "**" }
      if self.contains(.italic) { key += "*" }
      if self.contains(.strikethrough) { key += "~~" }
      if self.contains(.underline) { key += "__" }
      if self.contains(.spoiler) { key += "||" }
      return String(key.reversed())
    }
  }
}

public extension Text {
  func bold() -> Self { var txt = self; txt.fmt.insert(.bold); return txt }
  func italic() -> Self { var txt = self; txt.fmt.insert(.italic); return txt }
  func strikethrough() -> Self { var txt = self; txt.fmt.insert(.strikethrough); return txt }
  func underlined() -> Self { var txt = self; txt.fmt.insert(.underline); return txt }
  func spoilered() -> Self { var txt = self; txt.fmt.insert(.spoiler); return txt }
}
