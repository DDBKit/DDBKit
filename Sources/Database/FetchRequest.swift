//
//  FetchRequest.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 15/10/2024.
//


import Foundation
import DiscordModels

extension Database {
  /// ~/db/users/<UserSnowflake>/<ModelType>.json for user specific data
  /// ~/db/guilds/<GuildSnowflake>/<ModelType>.json for server specific data
  /// ~/db/guilds/<GuildSnowflake>/<UserSnowflake>/<ModelType>.json for member specific data (data for users per guild) (done)
  /// ~/db/guilds/<GuildSnowflake>/<ChannelSnowflake>/<ModelType>.json for channel specific data
  /// ~/db/bot/<ModelType>.json
	public struct FetchRequest<Model: DatabaseModel>: Sendable {
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
    
    func _rerouted(to key: String) -> Self {
      var copy = self
      let ext = copy.datapath.lastPathComponent
      copy.datapath = copy.datapath.deletingLastPathComponent().deletingLastPathComponent().appending(components: key, ext)
      return copy
    }
    
    var _key: String {
      datapath.deletingLastPathComponent().lastPathComponent
    }
  }
}
