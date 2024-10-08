//
//  Untitled.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 02/10/2024.
//

import DiscordBM

public extension GatewayManager {
  // Reactions
  func addReaction(
    to msg: Gateway.MessageCreate,
    with emoji: Reaction
  ) async throws {
    try await self.client.addMessageReaction(channelId: msg.channel_id, messageId: msg.id, emoji: emoji)
      .guardSuccess()
  }
  
  func removeAllReactions(of msg: Gateway.MessageCreate) async throws {
    try await self.client.deleteAllMessageReactions(channelId: msg.channel_id, messageId: msg.id)
      .guardSuccess()
  }
  
  func removeOwnReactions(
    of msg: Gateway.MessageCreate,
    with emoji: Reaction
  ) async throws {
    try await self.client.deleteOwnMessageReaction(channelId: msg.channel_id, messageId: msg.id, emoji: emoji)
      .guardSuccess()
  }
  
  func removeReactions(
    of user: DiscordUser,
    on msg: Gateway.MessageCreate,
    with emoji: Reaction
  ) async throws {
    try await self.client.deleteUserMessageReaction(channelId: msg.channel_id, messageId: msg.id, emoji: emoji, userId: user.id)
      .guardSuccess()
  }
  
  func removeReactions(
    by emoji: Reaction,
    on msg: Gateway.MessageCreate
  ) async throws {
    try await self.client.deleteAllMessageReactionsByEmoji(channelId: msg.channel_id, messageId: msg.id, emoji: emoji)
      .guardSuccess()
  }
  
  func listReactions(
    by emoji: Reaction,
    on msg: Gateway.MessageCreate,
    after: UserSnowflake? = nil,
    limit: Int? = nil
  ) async throws -> [DiscordUser] {
    let res = try await self.client.listMessageReactionsByEmoji(channelId: msg.channel_id, messageId: msg.id, emoji: emoji, after: after, limit: limit)
    try res.guardSuccess()
    return try res.decode()
  }
}
