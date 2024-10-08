//
//  List.swift
//  
//
//  Created by Lakhan Lothiyi on 21/04/2024.
//

import Foundation

public struct OrderedList: MessageContentComponent {
  var items: [Text]
  public init(@TextBuilder listItems: () -> [Text]) {
    self.items = listItems()
  }
  public var textualRepresentation: String {
    let strings = items.enumerated().map { (i, txt) in
      "\(i + 1). \(txt.textualRepresentation)"
    }
    return strings.joined(separator: "\n")
  }
}

public struct UnorderedList: MessageContentComponent {
  var items: [Text]
  public init(@TextBuilder listItems: () -> [Text]) {
    self.items = listItems()
  }
  public var textualRepresentation: String {
    let strings = items.enumerated().map { (_, txt) in
      "- \(txt.textualRepresentation)"
    }
    return strings.joined(separator: "\n")
  }
}
