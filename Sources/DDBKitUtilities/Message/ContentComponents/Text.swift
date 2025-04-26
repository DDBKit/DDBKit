//
//  Text.swift
//
//
//  Created by Lakhan Lothiyi on 21/04/2024.
//

import Foundation

// https://www.markdownguide.org/tools/discord/

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

  public init(
    fmt: FMTOptions = [],
    @GenericBuilder<Text> components: () -> GenericTuple<Text>
  ) {
    self.fmt = fmt
    self.txt = components().values.reduce(
      "",
      { partialResult, txt in
        return partialResult + txt.textualRepresentation.trimmingCharacters(in: .newlines)
      })
  }

  public var textualRepresentation: String {
    "\(fmt.startKey)\(txt)\(fmt.endKey)\(txt.isEmpty ? "" : "\n")"
  }

  public struct FMTOptions: OptionSet, Sendable {
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

extension Text {
  public func bold() -> Self {
    var txt = self
    txt.fmt.insert(.bold)
    return txt
  }
  public func italic() -> Self {
    var txt = self
    txt.fmt.insert(.italic)
    return txt
  }
  public func strikethrough() -> Self {
    var txt = self
    txt.fmt.insert(.strikethrough)
    return txt
  }
  public func underlined() -> Self {
    var txt = self
    txt.fmt.insert(.underline)
    return txt
  }
  public func spoilered() -> Self {
    var txt = self
    txt.fmt.insert(.spoiler)
    return txt
  }
}
