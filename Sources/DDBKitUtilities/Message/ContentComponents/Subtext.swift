//
//  Subtext.swift
//  DDBKit
//
//  Created by tiramisu on 2/21/25.
//

import Foundation

public struct Subtext: MessageContentComponent {
  var txt: String
  public init(_ str: String) {
    self.txt = str
  }

  public var textualRepresentation: String {
    return "-# \(txt)\n"
  }
}
