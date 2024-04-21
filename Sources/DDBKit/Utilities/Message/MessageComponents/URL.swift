//
//  URL.swift
//
//
//  Created by Lakhan Lothiyi on 21/04/2024.
//

import Foundation

public struct URL: MessageContentComponent {
  public var textualRepresentation: String {
    var url = self.url
    if disableLink { url = "<\(url)>" }
    if let maskedText {
      url = "[\(maskedText.textualRepresentation)](\(url))"
    }
    return url
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

public extension URL {
  func disableLinking() -> Self { var u = self; u.disableLink = true; return u }
  func maskedWith(_ txt: () -> Text) -> Self { var u = self; u.maskedText = txt(); return u }
}
