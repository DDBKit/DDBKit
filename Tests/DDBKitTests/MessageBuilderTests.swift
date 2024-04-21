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
    //
    let msg1 = Message {
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
    
    let expected1 = """
Italic: *true story*
Bold: **true story**
Strikethrough: ~~true story~~
Bold + Strikethrough: **~~true story~~**
"""
    
    XCTAssertEqual(msg1.content.textualRepresentation, expected1)
    
    let msg2 = Message {
      MessageContent {
        Heading {
          Text {
            Text("Welcome to ")
            Text("The Test")
              .italic()
            Text("!")
          }
          .underlined()
        }
        Heading("We're testing the Message DSL")
          .medium()
        Text("Actually scratch that")
          .strikethrough()
        NewLine()
        URL("https://llsc12.me")
          .disableLinking()
          .maskedWith {
            Text("check out this!")
              .bold()
          }
      }
    }
    
    let expected2 = """
# __Welcome to *The Test*!__
## We're testing the Message DSL
~~Actually scratch that~~
[**check out this!**](<https://llsc12.me>)
"""
    
    XCTAssertEqual(msg2.content.textualRepresentation, expected2)

  }
}
