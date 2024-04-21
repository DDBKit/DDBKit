//
//  Blockquote.swift
//
//
//  Created by Lakhan Lothiyi on 21/04/2024.
//

import Foundation

public struct Blockquote: MessageContentComponent {
  var txt: String
  public init(
    @MessageUtilityBuilder<MessageContentComponent>
    components: () -> [MessageContentComponent]
  ) {
    self.txt = components().reduce("", { partialResult, txt in
      return partialResult + txt.textualRepresentation
    })
  }
  
  public var textualRepresentation: String {
    txt
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .components(separatedBy: "\n")
      .map { "> " + $0 }
      .joined(separator: "\n")
      .appending("\n")
  }
}
