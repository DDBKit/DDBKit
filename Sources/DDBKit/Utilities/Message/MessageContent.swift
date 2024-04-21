//
//  MessageContent.swift
//  
//
//  Created by Lakhan Lothiyi on 19/04/2024.
//

import Foundation

@resultBuilder
public struct MessageUtilityBuilder<T> {
  public static func buildBlock(_ components: T...) -> [T] { components }
}

public protocol MessageContentComponent {
  var textualRepresentation: String { get }
}

// MARK: - Components
/// https://www.markdownguide.org/tools/discord/
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
    @MessageUtilityBuilder<Text> components: () -> [Text]
  ) {
    self.fmt = fmt
    self.txt = components().reduce("", { partialResult, txt in
      return partialResult + txt.textualRepresentation
    })
  }
  
  public var textualRepresentation: String {
    "\(fmt.startKey)\(txt)\(fmt.endKey)"
  }
  
  public struct FMTOptions: OptionSet {
    public init(rawValue: UInt) { self.rawValue = rawValue }
    public let rawValue: UInt
    
    public static let bold = Self(rawValue: 1 << 0)
    public static let italic = Self(rawValue: 1 << 1)
    public static let strikethrough = Self(rawValue: 1 << 2)
    
    // rest in piece
    // here lies raunak
    public var startKey: String {
      var key: String = ""
      if self.contains(.bold) { key += "**" }
      if self.contains(.italic) { key += "*" }
      if self.contains(.strikethrough) { key += "~~" }
      return key
    }
    public var endKey: String {
      var key: String = ""
      if self.contains(.bold) { key += "**" }
      if self.contains(.italic) { key += "*" }
      if self.contains(.strikethrough) { key += "~~" }
      return String(key.reversed())
    }
  }
}

extension Text {
  func bold() -> Self { var txt = self; txt.fmt.insert(.bold); return txt }
  func italic() -> Self { var txt = self; txt.fmt.insert(.italic); return txt }
  func strikethrough() -> Self { var txt = self; txt.fmt.insert(.strikethrough); return txt }
}

public struct NewLine: MessageContentComponent {
  public var textualRepresentation: String { "\n" }
  public init() {}
}

public struct Heading: MessageContentComponent {
  public var textualRepresentation: String {
    "\(size.rawValue) \(txt.textualRepresentation)"
  }
  
  var size: HeadingSize
  var txt: Text
  
  public init(_ str: String, size: HeadingSize = .large) {
    self.txt = .init(str)
    self.size = size
  }
  
  public init(
    size: HeadingSize = .large,
    _ txt: () -> Text
  ) {
    self.size = size
    self.txt = txt()
  }
  
  public enum HeadingSize: String {
    case large = "#"
    case medium = "##"
    case small = "###"
  }
}

public struct OrderedList: MessageContentComponent {
  var items: [String]
  public init(@MessageUtilityBuilder<String> listItems: () -> [String]) {
    self.items = listItems()
  }
  public var textualRepresentation: String {
    let strings = items.enumerated().map { (i, str) in
      "\(i + 1). \(str)"
    }
    return strings.joined(separator: "\n")
  }
}

public struct UnorderedList: MessageContentComponent {
  var items: [String]
  public init(@MessageUtilityBuilder<String> listItems: () -> [String]) {
    self.items = listItems()
  }
  public var textualRepresentation: String {
    let strings = items.map { str in
      "- \(str)"
    }
    return strings.joined(separator: "\n")
  }
}

