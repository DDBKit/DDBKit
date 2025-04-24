//
//  Heading.swift
//  
//
//  Created by Lakhan Lothiyi on 21/04/2024.
//

import Foundation

public struct Heading: MessageContentComponent {
  public var textualRepresentation: String {
    "\(size.rawValue) \(txt.textualRepresentation.trimmingCharacters(in: .newlines))\n"
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
  
	public enum HeadingSize: String, Sendable {
    case large = "#"
    case medium = "##"
    case small = "###"
  }
}

public extension Heading {
  func large() -> Self { var h = self; h.size = .large; return h }
  func medium() -> Self { var h = self; h.size = .medium; return h }
  func small() -> Self { var h = self; h.size = .small; return h }
}
