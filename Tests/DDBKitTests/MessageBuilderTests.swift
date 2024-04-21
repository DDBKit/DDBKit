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
  func testExample() throws {
    let msg = Message {
      MessageContent {
        Heading("wagwan")
        Heading("true story", size: .medium)
        Text("rate my testing")
        UnorderedList {
          "hi"
          "im"
          "a"
          "list"
        }
      }
      
      MessageEmbed()
    }
    
    print(msg.content.textualRepresentation)
  }
}
