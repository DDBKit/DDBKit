//
//  Codeblock.swift
//
//
//  Created by Lakhan Lothiyi on 21/04/2024.
//

import Foundation

public struct Codeblock: MessageContentComponent {
  var txt: String
  var lang: String
  public init(_ str: String, lang: String = "") {
    self.txt = str
    self.lang = lang
  }
  
  public var textualRepresentation: String {
    return """
```\(lang)
\(txt)
```

"""
  }
}

public extension Codeblock {
  func language(_ lang: String) -> Self { var c = self; c.lang = lang; return c }
}
