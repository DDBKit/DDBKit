//
//  BucketRatelimitingExtension.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 07/11/2024.
//

import Foundation
@_spi(Extensions) import DDBKit

/// An extension that manages rate limiting for Discord bot commands using a bucket system.
/// Each user (or user+guild combination) gets their own bucket to track their command usage.
public actor BucketRatelimiting: DDBKitExtension {
  /// Storage for all active rate limit buckets, keyed by user or guild+user identifiers
  private var buckets: [String: Bucket] = [:]
  
  /// The default configuration used for new rate limit buckets
  public private(set) var defaultConfig: RateLimitConfig
  
  /// Creates a new rate limiting manager with the specified default configuration
  /// - Parameter defaultConfig: Configuration to use for new buckets. Defaults to 5 uses per 60 seconds.
  public init(defaultConfig: RateLimitConfig = .init()) {
    self.defaultConfig = defaultConfig
  }
  
  /// Generates a unique key for storing rate limit buckets
  /// - Parameters:
  ///   - guildId: Optional Discord guild (server) ID
  ///   - userId: Discord user ID
  /// - Returns: A string key combining guild (if present) and user IDs
  private func getBucketKey(guildId: GuildSnowflake?, userId: UserSnowflake, command: String) -> String {
    if let guildId = guildId {
      return "\(guildId.rawValue):\(userId.rawValue):\(command)"
    }
    return "\(userId.rawValue):\(command)"
  }
  
  /// Checks if a user is within rate limits and records usage if allowed
  /// - Parameters:
  ///   - guildId: Optional Discord guild (server) ID
  ///   - userId: Discord user ID
  ///   - command: Name of the command being executed
  /// - Throws: `Error.ratelimited` with next available use time if rate limited
  public func ratelimitChecked(guildId: GuildSnowflake?, userId: UserSnowflake, command: String) async throws {
    let bucketKey = getBucketKey(guildId: guildId, userId: userId, command: command)
    
    if var bucket = buckets[bucketKey] {
      let (allowed, nextUse) = bucket.canUse()
      if allowed {
        bucket.recordUse()
        buckets[bucketKey] = bucket
        return
      }
      throw Error.ratelimited(nextUse: nextUse)
    } else {
      var bucket = Bucket(config: defaultConfig)
      bucket.recordUse()
      buckets[bucketKey] = bucket
    }
  }
  
  /// Updates the default configuration for new rate limit buckets
  /// - Parameter config: New configuration to use
  public func updateConfig(_ config: RateLimitConfig) {
    self.defaultConfig = config
  }
  
  /// Removes rate limiting state for a specific user (or user+guild combination)
  /// - Parameters:
  ///   - guildId: Optional Discord guild (server) ID
  ///   - userId: Discord user ID
  public func clearBucket(guildId: GuildSnowflake?, userId: UserSnowflake, command: String) {
    let key = getBucketKey(guildId: guildId, userId: userId, command: command)
    buckets.removeValue(forKey: key)
  }
  
  /// Removes all rate limiting state, effectively resetting all buckets
  public func clearAllBuckets() {
    buckets.removeAll()
  }
  
  /// Configuration settings for a rate limit bucket
  public struct RateLimitConfig {
    /// Maximum number of times a command can be used within the time window
    public let maxUses: Int
    /// Duration in seconds for the rolling time window
    public let timeWindow: TimeInterval
    
    /// Creates a new rate limit configuration
    /// - Parameters:
    ///   - maxUses: Maximum allowed uses within time window. Defaults to 5.
    ///   - timeWindow: Duration of the time window in seconds. Defaults to 60.
    public init(maxUses: Int = 5, timeWindow: TimeInterval = 60) {
      self.maxUses = maxUses
      self.timeWindow = timeWindow
    }
  }
  
  /// Internal representation of a rate limit bucket for tracking usage
  private struct Bucket {
    /// Array of command uses with their timestamps
    var uses: [(timestamp: Date, count: Int)]
    /// Configuration settings for this bucket
    let config: RateLimitConfig
    
    /// Creates a new empty bucket with the specified configuration
    /// - Parameter config: Rate limit settings for this bucket
    init(config: RateLimitConfig) {
      self.config = config
      self.uses = []
    }
    
    /// Checks if another command use is allowed within the rate limit
    /// - Returns: A tuple containing whether the use is allowed and when the next use will be available
    mutating func canUse() -> (allowed: Bool, nextUse: Date) {
      let now = Date()
      uses = uses.filter { now.timeIntervalSince($0.timestamp) < config.timeWindow }
      let totalUses = uses.reduce(0) { $0 + $1.count }
      
      if totalUses < config.maxUses {
        return (true, now)
      } else {
        // Calculate when the oldest use will expire
        let oldestUse = uses.min(by: { $0.timestamp < $1.timestamp })!
        let nextUse = oldestUse.timestamp.addingTimeInterval(config.timeWindow)
        return (false, nextUse)
      }
    }
    
    /// Records a command use in the bucket
    mutating func recordUse() {
      uses.append((timestamp: Date(), count: 1))
    }
  }
  
  enum Error: LocalizedError {
    /// Thrown when a user has exceeded their rate limit
    /// - Parameter nextUse: Date when the next command use will be allowed
    case ratelimited(nextUse: Date)
    /// Thrown when a user ID cannot be determined for rate limiting
    case noUserID
    
    var errorDescription: String? {
      return switch self {
      case .ratelimited(let nextUse):
        "You are being rate limited. Please try again \(DiscordUtils.timestamp(date: nextUse, style: .relativeTime))."
      case .noUserID:
        "No user ID was found for this interaction; you cannot use this command."
      }
    }
  }
}
