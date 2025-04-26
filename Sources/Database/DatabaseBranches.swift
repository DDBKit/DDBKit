//
//  DatabaseBranches.swift
//  Database
//
//  Created by Lakhan Lothiyi on 17/09/2024.
//

import DDBKit
import DiscordModels

extension InteractionExtras {
  public var branches: DatabaseBranches { DatabaseBranches(self.interaction) }
}

/// This struct contains pre-made requests based on the current interaction.
/// It's not advised to instanciate this yourself.
public struct DatabaseBranches {
  typealias Req = Database.FetchRequest

  /// Use to init from interaction and make requests based on context
  internal init(_ i: Interaction) {
    self.user = i.user?.id
    self.guild = i.guild_id
    self.channel = i.channel_id
  }

  /// Creates a DB request in the current user's context. This data is for the current user and shares across guilds and DMs.
  /// - Parameter type: Model Type
  /// - Returns: FetchRequest
  public func user<Model: DatabaseModel>(ofType type: Model.Type) throws
    -> Database.FetchRequest<Model>
  {
    guard let user else { throw DBBranchError.requiredDataUnavailableForBranch }
    return Database.FetchRequest.requestFor(user: user, ofType: type)
  }

  /// Creates a DB request in the current member's context. This data is for the current member of this guild only.
  /// - Parameter type: Model Type
  /// - Returns: FetchRequest
  public func member<Model: DatabaseModel>(ofType type: Model.Type) throws
    -> Database.FetchRequest<Model>
  {
    guard let user, let guild else { throw DBBranchError.requiredDataUnavailableForBranch }
    return Database.FetchRequest.requestFor(member: user, in: guild, ofType: type)
  }

  /// Creates a DB request in the current guild's context. This data is for the current guild only.
  /// - Parameter type: Model Type
  /// - Returns: FetchRequest
  public func guild<Model: DatabaseModel>(ofType type: Model.Type) throws
    -> Database.FetchRequest<Model>
  {
    guard let guild else { throw DBBranchError.requiredDataUnavailableForBranch }
    return Database.FetchRequest.requestFor(guild: guild, ofType: type)
  }

  /// Creates a DB request in the current channel's context. This data is for the current channel of this guild only.
  /// - Parameter type: Model Type
  /// - Returns: FetchRequest
  public func channel<Model: DatabaseModel>(ofType type: Model.Type) throws
    -> Database.FetchRequest<Model>
  {
    guard let channel, let guild else { throw DBBranchError.requiredDataUnavailableForBranch }
    return Database.FetchRequest.requestFor(channel: channel, in: guild, ofType: type)
  }

  /// Creates a DB request in global context. Available everywhere.
  /// - Parameter type: Model Type
  /// - Returns: FetchRequest
  public func global<Model: DatabaseModel>(ofType type: Model.Type) -> Database.FetchRequest<Model>
  {
    Database.FetchRequest.requestForBot(ofType: type)
  }

  // used in requests
  let user: UserSnowflake?
  let guild: GuildSnowflake?
  let channel: ChannelSnowflake?

  enum DBBranchError: Error {
    case requiredDataUnavailableForBranch
  }

  // MARK: - types of requests
  //  public static func requestFor(user: UserSnowflake, ofType type: Model.Type) -> Database.Database.FetchRequest<Model>
  //
  //  public static func requestFor(member: UserSnowflake, in guild: GuildSnowflake, ofType type: Model.Type) -> Database.Database.FetchRequest<Model>
  //
  //  public static func requestFor(guild: GuildSnowflake, ofType type: Model.Type) -> Database.Database.FetchRequest<Model>
  //
  //  public static func requestFor(channel: ChannelSnowflake, in guild: GuildSnowflake, ofType type: Model.Type) -> Database.Database.FetchRequest<Model>
  //
  //  public static func requestForBot(ofType type: Model.Type) -> Database.Database.FetchRequest<Model>
}
