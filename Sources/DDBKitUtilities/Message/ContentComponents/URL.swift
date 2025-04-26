//
//  Link.swift
//
//
//  Created by Lakhan Lothiyi on 21/04/2024.
//

import Foundation

public struct Link: MessageContentComponent {
  public var textualRepresentation: String {
    var url = self.url
    if disableLink { url = "<\(url)>" }
    if let maskedText {
      let mask = maskedText.textualRepresentation.trimmingCharacters(in: .newlines)
      url = "[\(mask)](\(url))"
    }
    return url + "\n"
  }

  var url: String
  var disableLink: Bool
  var maskedText: Text?

  public init(_ url: String, disableLinking: Bool = false) {
    self.url = url
    self.disableLink = disableLinking
    self.maskedText = nil
  }
}

extension Link {
  public func disableEmbedding() -> Self {
    var u = self
    u.disableLink = true
    return u
  }
  public func maskedWith(_ txt: () -> Text) -> Self {
    var u = self
    u.maskedText = txt()
    return u
  }
}
