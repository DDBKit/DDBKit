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
  
  public init(_ str: String, fmt: FMTOptions = []) { self.txt = str; self.fmt = fmt }
  
  public var textualRepresentation: String { txt }
  
  public struct FMTOptions: OptionSet {
    public init(rawValue: UInt) { self.rawValue = rawValue }
    public let rawValue: UInt
    
    static let bold = Self(rawValue: 1 << 0)
  }
}


public struct Heading: MessageContentComponent {
  public var textualRepresentation: String {
    "\(size.rawValue) \(txt)"
  }
  
  var size: HeadingSize
  var txt: String
  
  public init(_ str: String, size: HeadingSize = .large) {
    self.txt = str
    self.size = size
  }
  
  init(txt: () -> Text, size: HeadingSize = .large) {
    self.size = size
    self.txt = txt().textualRepresentation
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

