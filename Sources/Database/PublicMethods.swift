//
//  PublicMethods.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 15/10/2024.
//

import Foundation

extension Database {
  /// Creates a transaction where you can read and/or write to the entry.
  /// Be sure not to spend long in the transaction. Avoid doing long calculations
  /// and other tasks or else other instances awaiting a chance for reading and writing
  /// will have to wait long.
  /// - Parameter transaction: A closure where you can read the data and return modified data
  /// - Parameter req: The request to the DB you want to perform
  /// - Returns: The returned value from the transaction closure
  @discardableResult
  public func transaction<T: DatabaseModel>(_ req: FetchRequest<T>, transaction: @escaping (T?) async -> T?) async -> T? {
    let id = req.datahash
    /// suspend this transaction request until the existing one is done
    
    /// try a while loop and break out of it if theres an opportunity to do the transaction
    while true {
      if transactions[id] != nil {
        print("DB: existing transaction, awaiting")
        _ = await transactions[id]?.result
      } else {
        break
      }
    }
    
    let task = Task {
      let current = request(req)
      let modified = await transaction(current)
      write(req, data: modified)
      return modified as Any?
    }
    transactions[id] = task
    let retValue = await transactions[id]?.value
    transactions.removeValue(forKey: id)
    return retValue as? T
  }
  
  /// Get a list of keys available for a request.
  /// - Parameter req: Dummy request to locate keys with
  /// - Returns: Available keys
  public func availableKeys<T: DatabaseModel>(around req: FetchRequest<T>) -> [String] {
    let path = req.datapath.deletingLastPathComponent().deletingLastPathComponent()
    let ext = req.datapath.lastPathComponent
    let files = (try? FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: [], options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])) ?? []
    let keys: [String] = files.compactMap({ url in
      let file = url.appending(component: ext).path()
      guard FileManager.default.fileExists(atPath: file) else { return nil }
      return url.lastPathComponent
    })
    return keys
  }
}
