//
//  MessageBuilderTests.swift
//
//
//  Created by Lakhan Lothiyi on 19/04/2024.
//

import Foundation

import XCTest
@testable import DDBKit
@testable import Database

final class DDBKitTests: XCTestCase {
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
          .disableLinking()
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
          .disableLinking()
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
        }
      }
    }
    
    XCTAssertEqual(msg.embeds[0].title, random ? "wagwan" : nil)
  }
  
  func testEgg() async {
    // define a model to store data with
    struct UserNotes: DatabaseModel {
      var notes: [String]
    }
    
    let db = Database.shared // singleton instance
    // prepare a request for user llsc12
    let req = Database.FetchRequest.requestFor(user: .init("381538809180848128"), ofType: UserNotes.self)
    
    // transactions give us access to the model instance for the lifetime of this closure
    // we shouldn't do anything aside from reading and writing data in this closure
    // or else other transactions to this model have to wait until you're done
    // hence why we use await when instanciating a transaction
    await db.transaction(req) { notesObject in
      var obj = notesObject ?? .init(notes: []) // init if it doesnt exist already
      // make changes to our instance
      obj.notes = [
        "finish the db",
        "show echo an example of transaction"
      ]
      // return the instance we've changed and the db will save it
      return obj
    }
    // now that we're done, another pending transaction can initiate :3
    
  }
}
