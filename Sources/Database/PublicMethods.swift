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
      let current = _request(req)
      let modified = await transaction(current)
      _write(req, data: modified)
      return modified as Any?
    }
    transactions[id] = task
    let retValue = await transactions[id]?.value
    transactions.removeValue(forKey: id)
    return retValue as? T
  }
  
  /// Get a list of items available for a request.
  /// - Parameter req: Dummy request to locate keys with
  /// - Returns: Available items (requests to them)
  public func availableItems<T: DatabaseModel>(around req: FetchRequest<T>) -> [FetchRequest<T>] {
    let path = req.datapath.deletingLastPathComponent().deletingLastPathComponent()
    let ext = req.datapath.lastPathComponent
    let files = (try? FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: [], options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])) ?? []
    let keys: [String] = files.compactMap({ url in
      let file = url.appending(component: ext).path()
      guard FileManager.default.fileExists(atPath: file) else { return nil }
      return url.lastPathComponent
    })
    return keys.map { req._rerouted(to: $0) }
  }
  
  /// Get a list of keys available for a request.
  /// - Parameter req: Dummy request to locate keys with
  /// - Returns: Available items (by keys)
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
  
  // old func,
  //  public func find<T: DatabaseModel>(around req: FetchRequest<T>, filter: (T?) -> Bool) async throws -> [String] {
  //    let keys = availableKeys(around: req) // get the keys of values
  //    var filterPassKeys = [String]()
  //
  //    for key in keys {
  //      let rerouted = req._rerouted(to: key) // get request to each value from rerouted key
  //      let value = self._request(rerouted)
  //      if filter(value) {
  //        filterPassKeys.append(key)
  //      }
  //    }
  //    return filterPassKeys
  //  }
  
  /// Perform searches on db based on logic
  /// - Parameter req: Dummy request to locate keys with
  /// - Parameter filter: Perform logic on each item
  /// - Returns: Filtered array of items (by keys)
  public func findKeys<T: DatabaseModel>(around req: FetchRequest<T>, filter: @escaping (T?) -> Bool) async throws -> [String] {
    let keys: [String] = availableKeys(around: req)
    var filterPassKeys = [String]()
    
    // Using TaskGroup to parallelize the filter operation for each key
    await withTaskGroup(of: (String, Bool).self) { group in
      for key in keys {
        group.addTask {
          let rerouted = req._rerouted(to: key)
          let value = await self._request(rerouted) // Perform the async request
          return (key, filter(value)) // Return the key and whether it passes the filter
        }
      }
      
      // Collecting results from each task
      for await (key, passes) in group {
        if passes {
          filterPassKeys.append(key)
        }
      }
    }
    
    return filterPassKeys
  }
  
  /// Perform searches on db based on logic
  /// - Parameter req: Dummy request to locate keys with
  /// - Parameter filter: Perform logic on each item
  /// - Returns: Filtered array of items (requests to them)
  public func findItems<T: DatabaseModel>(around req: FetchRequest<T>, filter: @escaping (T?) -> Bool) async throws -> [FetchRequest<T>] {
    let keys: [String] = availableKeys(around: req)
    var filterPassKeys = [String]()
    
    // Using TaskGroup to parallelize the filter operation for each key
    await withTaskGroup(of: (String, Bool).self) { group in
      for key in keys {
        group.addTask {
          let rerouted = req._rerouted(to: key)
          let value = await self._request(rerouted) // Perform the async request
          return (key, filter(value)) // Return the key and whether it passes the filter
        }
      }
      
      // Collecting results from each task
      for await (key, passes) in group {
        if passes {
          filterPassKeys.append(key)
        }
      }
    }
    
    return filterPassKeys.map { req._rerouted(to: $0) }
  }
  
  /// Perform searches on db based on logic
  /// - Parameter req: Dummy request to locate keys with
  /// - Parameter filter: Perform logic on each item
  /// - Returns: Filtered array of item keys
  public func sort<T: DatabaseModel>(on req: FetchRequest<T>, compare: @escaping (T?, T?) -> Bool) async throws -> [String] {
    let keys = availableKeys(around: req)
    var sortedKeys: [String] = [] // Stores sorted keys
    
    // Process keys in batches to limit memory usage
    let batchSize = 100 // Adjust batch size as needed
    var batchStartIndex = 0
    
    while batchStartIndex < keys.count {
      let batchEndIndex = min(batchStartIndex + batchSize, keys.count)
      let batchKeys = Array(keys[batchStartIndex..<batchEndIndex])
      
      // Using TaskGroup to parallelize the retrieval operation within each batch
      await withTaskGroup(of: (String, T?).self) { group in
        for key in batchKeys {
          group.addTask {
            let rerouted = req._rerouted(to: key)
            let value = await self._request(rerouted) // Get the value
            await Task.yield()
            return (key, value) // Return both key and value
          }
        }
        
        // Collect and sort results within the batch
        for await result in group {
          // Perform insertion based on comparison with already sorted keys
          var inserted = false
          
          for (index, existingKey) in sortedKeys.enumerated() {
            await Task.yield()
            let existingValue = self._request(req._rerouted(to: existingKey))
            if compare(result.1, existingValue) {
              sortedKeys.insert(result.0, at: index) // Insert the current key in the correct position
              inserted = true
              break
            }
          }
          
          // If not inserted yet, it belongs at the end
          if !inserted {
            sortedKeys.append(result.0)
          }
        }
      }
      
      batchStartIndex += batchSize
    }
    
    return sortedKeys
  }
}
