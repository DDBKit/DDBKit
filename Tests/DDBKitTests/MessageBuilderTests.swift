//
//  MessageBuilderTests.swift
//
//
//  Created by Lakhan Lothiyi on 19/04/2024.
//

import Foundation

import XCTest
@testable import DDBKit

final class DDBKitTests: XCTestCase {
  func testMessageBuilders() throws {
    let msg = Message {
      MessageContent {
        Text("Italic: ")
        Text("true story")
          .italic()
        NewLine()
        Text("Bold: ")
        Text("true story")
          .bold()
        NewLine()
        Text("Strikethrough: ")
        Text("true story")
          .strikethrough()
        NewLine()
        Text("Bold + Strikethrough: ")
        Text("true story")
          .bold()
          .strikethrough()
      }
    }
    
    let expected = """
Italic: *true story*
Bold: **true story**
Strikethrough: ~~true story~~
Bold + Strikethrough: **~~true story~~**
"""
    
    XCTAssertEqual(msg.content.textualRepresentation, expected)
  }
}
