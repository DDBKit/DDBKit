//
//  Code.swift
//  
//
//  Created by Lakhan Lothiyi on 21/04/2024.
//

import Foundation

public struct Code: MessageContentComponent {
  var txt: String
  public init(_ str: String) {
    self.txt = str
  }
  
  public var textualRepresentation: String {
    return "`\(txt)`\n"
  }
}
