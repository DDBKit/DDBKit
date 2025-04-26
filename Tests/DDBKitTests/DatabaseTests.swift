//
//  DatabaseTests.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/09/2024.
//

import Foundation
import XCTest

@testable import DDBKit
@testable import DDBKitUtilities
@testable import Database

struct UserNotes: DatabaseModel {
  var notes: [String]
}

final class DatabaseTests: XCTestCase {
  func testTransactions() async throws {
    // define a model to store data with

    let db = Database.shared  // singleton instance
    // prepare a request for user llsc12
    let req = Database.FetchRequest.requestFor(user: .init("324565"), ofType: UserNotes.self)

    // transactions give us access to the model instance for the lifetime of this closure
    // we shouldn't do anything aside from reading and writing data in this closure
    // or else other transactions to this model have to wait until you're done
    // hence why we use await when instanciating a transaction
    await db.transaction(req) { notesObject in
      var obj = notesObject ?? .init(notes: [])  // init if it doesnt exist already
      // make changes to our instance
      obj.notes = [
        "finish the db",
        "show echo an example of transaction",
      ]
      // return the instance we've changed and the db will save it
      return obj
    }
    // now that we're done, another pending transaction can initiate :3

    // since the database is basically a big queue of single transactions,
    // you'll always want to defer or something when using db transactions.
  }
}
