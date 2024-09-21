//
//  Database.swift
//
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import Foundation
import DiscordModels

struct DBPaths {
  private static let dbDirectory: URL = {
    // we get the executable path first
    guard let execPath = Bundle.main.executableURL?.deletingLastPathComponent() else { fatalError("DB: Unable to get the current executable directory.") }
    // store stuff in db directory
    let dbPath = execPath.appendingPathComponent("db", isDirectory: true)
    return dbPath
  }()
  
  // we use `try!` because we should be able to make directories, this
  // is bad if we cant so we might as well go down trying
  
  static let Users: Self = {
    let path = Self.dbDirectory.appendingPathComponent("users", isDirectory: true)
    try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
    return .init(url: path)
  }()
  static let Guilds: Self = {
    let path = Self.dbDirectory.appendingPathComponent("guilds", isDirectory: true)
    try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
    return .init(url: path)
  }()
  static let Bot: Self = {
    let path = Self.dbDirectory.appendingPathComponent("bot", isDirectory: true)
    try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
    return .init(url: path)
  }()
  
  var url: URL
}

// this database library is for storing data associated with entities
// such as discord users, servers, channels and such.

public actor Database {
  public static let shared = Database()
  static let decoder = JSONDecoder()
  static let encoder = JSONEncoder()
  
  /// `Int` is a Hash of the filepath that is being used. These tasks
  /// contain the reading and writing being done to the database.
  /// Only one transaction can be active at a time
  var transactions = [Int: Task<Any?, Never>]()

  /// Reads file from the file in the db
  /// - Parameter url: URL of file to read
  /// - Returns: The file contents or nil
  func requestData(for url: URL) -> Data? { try? Data(contentsOf: url) }
  
  /// writes file to the db
  /// - Parameter url: URL of file to write
  func writeData(for url: URL, data: Data?) { try? data?.write(to: url) }
  
  /// Requests data and decodes it if possible
  /// - Parameters:
  ///   - url: URL to read from
  ///   - type: the type of the data
  /// - Returns: the model or nil
  func request<T: DatabaseModel>(_ req: FetchRequest<T>) -> T? {
    guard let d = requestData(for: req.datapath) else { return nil }
    return try? Self.decoder.decode(req.type, from: d)
  }
  
  func write<T: DatabaseModel>(_ req: FetchRequest<T>, data: T?) {
    let d = try? Self.encoder.encode(data)
    writeData(for: req.datapath, data: d)
  }
  
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
        let _ = await transactions[id]?.result
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
}

extension Database {
  /// ~/db/users/<UserSnowflake>/<ModelType>.json for user specific data
  /// ~/db/guilds/<GuildSnowflake>/<ModelType>.json for server specific data
  /// ~/db/guilds/<GuildSnowflake>/<UserSnowflake>/<ModelType>.json for member specific data (data for users per guild) (done)
  /// ~/db/guilds/<GuildSnowflake>/<ChannelSnowflake>/<ModelType>.json for channel specific data
  /// ~/db/bot/<ModelType>.json
  public struct FetchRequest<Model: DatabaseModel> {
    var type: Model.Type
    var datapath: URL
    var datahash: Int { datapath.hashValue }
    
    /// Constructs a request representing the path to the file and its types
    ///
    /// we construct the filename and stuff with the types for typesafety
    /// - Parameters:
    ///   - type: The model type to fetch
    ///   - url: the path to the model (not incl. the file)
    private init(type: Model.Type, url: URL) {
      self.type = type
      try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
      self.datapath = url
        .appendingPathComponent("\(type)", isDirectory: false)
        .appendingPathExtension("json")
    }

    public static func requestFor(user: UserSnowflake, ofType type: Model.Type) -> FetchRequest<Model> {
      let url = DBPaths.Users.url
        .appendingPathComponent(user.rawValue, isDirectory: true)
      return FetchRequest<Model>(type: type, url: url)
    }
    public static func requestFor(guild: GuildSnowflake, ofType type: Model.Type) -> FetchRequest<Model> {
      let url = DBPaths.Guilds.url
        .appendingPathComponent(guild.rawValue, isDirectory: true)
      return FetchRequest<Model>(type: type, url: url)
    }
    public static func requestFor(member: UserSnowflake, in guild: GuildSnowflake, ofType type: Model.Type) -> FetchRequest<Model> {
      let url = DBPaths.Guilds.url
        .appendingPathComponent(guild.rawValue, isDirectory: true)
        .appendingPathComponent("members", isDirectory: true)
        .appendingPathComponent(member.rawValue, isDirectory: true)
      return FetchRequest<Model>(type: type, url: url)
    }
    public static func requestFor(channel: ChannelSnowflake, in guild: GuildSnowflake, ofType type: Model.Type) -> FetchRequest<Model> {
      let url = DBPaths.Guilds.url
        .appendingPathComponent(guild.rawValue, isDirectory: true)
        .appendingPathComponent("channels", isDirectory: true)
        .appendingPathComponent(channel.rawValue, isDirectory: true)
      return FetchRequest<Model>(type: type, url: url)
    }
    public static func requestForBot(ofType type: Model.Type) -> FetchRequest<Model> {
      let url = DBPaths.Bot.url
      return FetchRequest<Model>(type: type, url: url)
    }
  }
  
}



/// This protocol is required to use `@DatabaseInterface` property wrapper.
/// Types conforming to it can be stored in an interface.
public protocol DatabaseModel: Codable {}
