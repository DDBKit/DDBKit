//
//  GuildTargeting.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 04/10/2024.
//

// i put this stuff here bc it applies to groups and commands
// also groups have a different implementation

public extension Command {
  /// Scopes this command to global use or local to a set of servers.
  /// Intended to make development and testing easier.
  /// This will only be used on registration of a command at launch.
  /// - Parameters:
  ///   - scope: The local or global scope
  ///   - guilds: The guild snowflakes to add onto the array of guilds to target
  func guildScope(
    _ scope: CommandGuildScope.ScopeType,
    _ guilds: [GuildSnowflake] = []
  ) -> Self {
    var copy = self
    copy.guildScope.scope = scope
    copy.guildScope.guilds.append(contentsOf: guilds)
    return copy
  }
}

public extension Group {
  /// Scopes this group's nested commands to global use or local to a set of servers.
  /// Intended to make development and testing easier.
  /// This will only be used on registration of a command at launch.
  /// - Parameters:
  ///   - scope: The local or global scope
  ///   - guilds: The guild snowflakes to add onto the array of guilds to target
  func guildScope(
    _ scope: CommandGuildScope.ScopeType,
    _ guilds: [GuildSnowflake] = []
  ) -> Self {
    var copy = self
    // we can assume no inner groups since the group result builder auto expands
    for index in copy.scene.indices {
      if var command = copy.scene[index] as? BaseCommand {
        command.guildScope.scope = scope
        command.guildScope.guilds.append(contentsOf: guilds)
        copy.scene[index] = command
      }
    }
    return copy
  }
}
