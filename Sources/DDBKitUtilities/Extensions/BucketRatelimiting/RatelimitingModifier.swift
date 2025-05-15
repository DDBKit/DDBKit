//
//  RatelimitingModifier.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 07/11/2024.
//

@_spi(Extensions) import DDBKit
import Foundation

// In your command modifier
extension ExtensibleCommand {
	/// Ratelimit this command by uses per a window of time. Register the extension before using this!
	/// - Parameter config: A custom limit for this command. If nil, the default config will be used.
	public func ratelimited(_ config: BucketRatelimiting.RateLimitConfig? = nil)
		-> Self
	{
		self
			.preAction { _, i in
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
				try await ratelimiter.ratelimitChecked(
					guildId: guildId,
					userId: userId,
					command: name,
					config: config
				)
			}
	}
}
