//
//  Database.swift
//
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import Foundation
import DiscordModels

// this database library is for storing data associated with entities
// such as discord users, servers, channels and such.
public actor Database {
  public static var shared = Database()
  init(basePath: URL? = nil) {
    precondition(Bundle.main.executableURL != nil, "Something seems to be wrong, please manually specify a database root path.")
    DBPaths.dbDirectory = basePath?.appendingPathComponent("db", isDirectory: true) ?? DBPaths.dbDirectory
  }
  
  static let decoder = JSONDecoder()
  static let encoder = JSONEncoder()
  
  /// `Int` is a Hash of the filepath that is being used. These tasks
  /// contain the reading and writing being done to the database.
  /// Only one transaction can be active at a time
  var transactions = [Int: Task<(any Sendable)?, Never>]()

  /// Reads file from the file in the db
  /// - Parameter url: URL of file to read
  /// - Returns: The file contents or nil
  func _requestData(for url: URL) -> Data? { try? Data(contentsOf: url) }
  
  /// writes file to the db
  /// - Parameter url: URL of file to write
  func _writeData(for url: URL, data: Data?) {
    if data != nil, String(data: data!, encoding: .utf8) == "null" { // check if blank files have been written
      try? FileManager.default.removeItem(at: url)
      return
    }
    try? data?.write(to: url)
  }
  
  /// Requests data and decodes it if possible
  /// - Parameters:
  ///   - url: URL to read from
  ///   - type: the type of the data
  /// - Returns: the model or nil
  func _request<T: DatabaseModel>(_ req: FetchRequest<T>) -> T? {
    guard let d = _requestData(for: req.datapath) else { return nil }
    return try? Self.decoder.decode(req.type, from: d)
  }
  
  func _write<T: DatabaseModel>(_ req: FetchRequest<T>, data: T?) {
    let d = try? Self.encoder.encode(data)
    _writeData(for: req.datapath, data: d)
  }
}
