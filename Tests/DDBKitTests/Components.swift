//
//  Components.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//

import XCTest
@testable import DDBKit
@testable import DDBKitUtilities

final class ModelTests: XCTestCase {
  func testModels() {
    let modal = Modal("modal test") {
      TextField("wagwan")
        .required(true)
    }
    
    print(modal)
    
    let gm = MessageComponents {
      ActionRow {
        if false {
          TextField("wagawan")
        } else {
          TextField("meow")
        }
        TextField("moo")
        TextField("moo")
        TextField("moo")
      }
    }
    print(gm)
  }
  
  func testComponents() {
    struct DataStruct {
      var repo: String?
      var depiction: String?
    }
    let data = DataStruct(repo: nil, depiction: nil)
    let msg = Message {
      MessageContent {
        Text("buttons!")
      }
      MessageComponents {
        ActionRow {
          if let depiction = data.depiction {
            LinkButton("View Depiction", Emoji(id: "1294780376354656377", name: "depiction"), url: depiction)
          }
          if let repo = data.repo {
            LinkButton("Add Repo to Sileo", Emoji(id: "1294780391542095944", name: "sileo"), url: "https://repos.slim.rocks/repo/?repoUrl=" + repo + "&manager=sileo")
            LinkButton("Add Repo to Zebra", Emoji(name: "zebra"), url: "https://repos.slim.rocks/repo/?repoUrl=" + repo + "&manager=zebra")
            LinkButton("Other Package Managers", Emoji(id: "1294780403055329300", name: "other"), url: "https://repos.slim.rocks/repo/?repoUrl=" + repo)
          }
        }
      }
    }
    let obj = msg._createMessage
    print(obj)
  }
}
