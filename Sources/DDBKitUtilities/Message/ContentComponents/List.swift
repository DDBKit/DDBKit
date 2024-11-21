//
//  List.swift
//  
//
//  Created by Lakhan Lothiyi on 21/04/2024.
//

import Foundation

public struct OrderedList: MessageContentComponent {
  var items: [Text]
  public init(
    @GenericBuilder<Text> listItems: () -> GenericTuple<Text>
  ) {
    self.items = listItems().values
  }
  public var textualRepresentation: String {
    let strings = items.enumerated().map { (i, txt) in
      "\(i + 1). \(txt.textualRepresentation)"
    }
//    return strings.joined(separator: "\n")
//    we don't join with a newline because any MessageContentComponent's textualRepresentation always ends in a newline
    return strings.joined(separator: "")
  }
}

public struct UnorderedList: MessageContentComponent {
  var items: [Text]
  public init(@GenericBuilder<Text> listItems: () -> GenericTuple<Text>) {
    self.items = listItems().values
  }
  public var textualRepresentation: String {
    let strings = items.enumerated().map { (_, txt) in
      "- \(txt.textualRepresentation)"
    }
//    return strings.joined(separator: "\n")
//    we don't join with a newline because any MessageContentComponent's textualRepresentation always ends in a newline
    return strings.joined(separator: "")
  }
}

