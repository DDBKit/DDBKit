//
//  RatelimitingModifier.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 07/11/2024.
//

import Foundation
@_spi(Extensions) import DDBKit

// In your command modifier
public extension ExtensibleCommand {
  func ratelimited(_ config: BucketRatelimiting.RateLimitConfig? = nil) -> Self {
    self
      .preAction { cmd, i in
        // Get the guild id and user id
        let guildId: GuildSnowflake? = i.interaction.guild_id
        guard
          let userId = i.interaction.member?.user?.id ?? i.interaction.user?.id
        else {
          throw BucketRatelimiting.Error.noUserID
        }
        // Get the extension instance
        let ratelimiter = i.instance[ext: BucketRatelimiting.self]
        
        // Get the command name
        let name = (self as! BaseContextCommand).baseInfo.name
        
        // Check the ratelimit
        try await ratelimiter.ratelimitChecked(guildId: guildId, userId: userId, command: name)
      }
  }
}
