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
        let guildId: GuildSnowflake? = i.interaction.guild_id
        guard
          let userId = i.interaction.member?.user?.id ?? i.interaction.user?.id
        else {
          throw BucketRatelimiting.Error.noUserID
        }
        let ratelimiter = i.instance[ext: BucketRatelimiting.self]
        
        let name = (self as! BaseContextCommand).baseInfo.name
        
        try await ratelimiter.ratelimitChecked(guildId: guildId, userId: userId, command: name) 
      }
  }
}
