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
  func testModels()  {
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
}
