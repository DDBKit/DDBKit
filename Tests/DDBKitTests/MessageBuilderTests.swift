//
//  MessageBuilderTests.swift
//
//
//  Created by Lakhan Lothiyi on 19/04/2024.
//

import Foundation

import XCTest
@testable @_spi(Extension) import DDBKit
@testable import DDBKitUtilities
@testable import Database

final class MessageBuilderTests: XCTestCase {
  func testMessageBuilderSimpleContent() throws {
    let msg = Message {
      MessageContent {
        Text {
          Text("Italic: ")
          Text("true story")
            .italic()
        }
        Text {
          Text("Bold: ")
          Text("true story")
            .bold()
        }
        Text {
          Text("Strikethrough: ")
          Text("true story")
            .strikethrough()
        }
        Text {
          Text("Bold + Strikethrough: ")
          Text("true story")
            .bold()
            .strikethrough()
        }
      }
    }
    
    let expected1 = """
Italic: *true story*
Bold: **true story**
Strikethrough: ~~true story~~
Bold + Strikethrough: **~~true story~~**
"""
    
    XCTAssertEqual(msg.content.textualRepresentation, expected1)
  }
  
  func testMessageBuilderComplexContent() throws {
    let msg = Message {
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
        Link("https://llsc12.me")
          .disableEmbedding()
          .maskedWith {
            Text("check out this!")
              .bold()
          }
      }
    }
    
    let expected = """
# __Welcome to *The Test*!__
## We're testing the Message DSL
~~Actually scratch that~~
[**check out this!**](<https://llsc12.me>)
"""
    
    XCTAssertEqual(msg.content.textualRepresentation, expected)
  }
  
  func testMessageBuilderLineBreaksContent() throws {
    let msg = Message {
      MessageContent {
        Text {
          Text("1, 2")
          Text(", 3, 4")
        }
        Text("text 1")
        Text("text 2")
      }
    }
    
    let expected = """
1, 2, 3, 4
text 1
text 2
"""
    
    XCTAssertEqual(msg.content.textualRepresentation, expected)
  }
  
  func testMessageBuilderContentConditionalBranches() throws {
    let random = Bool.random()
    let msg = Message {
      MessageContent {
        if random {
          Text {
            Text("1, 2")
            Text(", 3, 4")
          }
        }
        Text("text 1")
        Text("text 2")
      }
    }
    
    let expected1 = """
text 1
text 2
"""
    
    let expected2 = """
1, 2, 3, 4
text 1
text 2
"""
    if random {
      XCTAssertEqual(msg.content.textualRepresentation, expected2)
    } else {
      XCTAssertEqual(msg.content.textualRepresentation, expected1)
    }
  }
  
  func testMessageBuilderComplexBlocksContent() throws {
let msg = Message {
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
    Link("https://llsc12.me")
      .disableEmbedding()
      .maskedWith {
        Text("check out this!")
          .bold()
      }
    Blockquote {
      Heading {
        Text("Blockquote!")
          .underlined()
      }
      .medium()
      Text("yep, we got em")
    }
    Code("wagwan")
    Codeblock("""
for i in 0...10 {
print(i)
}
print("done!")
"""
    )
    .language("swift")
  }
}
    
    let expected = """
# __Welcome to *The Test*!__
## We're testing the Message DSL
~~Actually scratch that~~
[**check out this!**](<https://llsc12.me>)
> ## __Blockquote!__
> yep, we got em
`wagwan`
```swift
for i in 0...10 {
  print(i)
}
print("done!")
```
"""
    
    XCTAssertEqual(msg.content.textualRepresentation, expected)
  }
  
  func testMessageBuilderEmbedConditionalBranches() throws {
    let random = Bool.random()
    let msg = Message {
      MessageEmbed {
        if random {
          Title("wagwan")
        } else {
          Title("heyyy")
        }
        Description("hiiiiiii :3")
      }
      .setColor(.cyan)
      .setURL("https://llsc12.me")
    }
    
    XCTAssertEqual(msg.embeds[0].title, "heyyy")
  }
  
  func testMessageBuilderEmbedLoops() throws {
    let msg = Message {
      MessageEmbed {
        for i in 1...10 {
          Field("number", i.description)
        }
      }
      .setColor(.cyan)
      .setURL("https://llsc12.me")
    }
    
//    XCTAssertEqual(msg.embeds[0].title, "heyyy")
    print(msg)
  }
  
  func testGM() {
    let msg = Message {
      MessageContent {
        Heading("gm")
        Text("gm")
      }
      MessageComponents {
        ActionRow {
          Button("hi mom")
            .id("mom-btn")
        }
      }
    }
    print(msg)
  }
}
