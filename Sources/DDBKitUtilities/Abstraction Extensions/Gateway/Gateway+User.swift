//
//  Gateway+User.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 02/10/2024.
//

import DiscordBM

public extension GatewayManager {
  // banning
  func ban(user: DiscordUser, from guild: PartialGuild, reason: String? = nil, deletingMessages: Duration? = nil) async throws {
    let time = deletingMessages?.components.seconds == nil ? nil : Int(deletingMessages!.components.seconds)
    try await self.client.banUserFromGuild(guildId: guild.id, userId: user.id, reason: reason, payload: .init(delete_message_seconds: time))
      .guardSuccess()
  }
  // kicking
  func kick(user: DiscordUser, from guild: PartialGuild, reason: String? = nil) async throws {
    try await self.client.deleteGuildMember(guildId: guild.id, userId: user.id, reason: reason)
      .guardSuccess()
  }
}
