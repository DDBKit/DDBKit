//
//  Description.swift
//  
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import Foundation

public struct Description: MessageEmbedComponent {
  var text: String
  public init(@TextBuilder components: () -> [Text]) {
    self.text = components().reduce("", { partialResult, txt in
      return partialResult + txt.textualRepresentation
        .trimmingCharacters(in: .newlines) + "\n"
    }).trimmingCharacters(in: .whitespacesAndNewlines)
  }
  public init(_ txt: String) {
    self.text = txt
  }
  public init(
    @MessageContentBuilder
    message: () -> [MessageContentComponent]
  ) {
    self.text = message().reduce("") { partialResult, component in
      return partialResult + component.textualRepresentation
    }
    .trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
