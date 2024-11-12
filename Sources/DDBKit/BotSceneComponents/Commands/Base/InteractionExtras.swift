//
//  InteractionExtras.swift
//  
//
//  Created by Lakhan Lothiyi on 12/11/2024.
//


import DiscordModels
import DiscordGateway
import DiscordHTTP

public struct InteractionExtras {
  @_spi(Extensions)
  public var instance: BotInstance
  public var interaction: Interaction
  internal init(_ instance: BotInstance, _ interaction: Interaction) {
    self.instance = instance
    self.interaction = interaction
  }
  
  public var gateway: any GatewayManager {
    self.instance.bot
  }
  public var client: any DiscordClient {
    self.instance.bot.client
  }
  public var cache: DiscordCache {
    self.instance.cache
  }
  
  public func getExtension<T>(_ type: T.Type) -> T where T: DDBKitExtension  {
    self.instance.extensions.first(where: { $0 is T })! as! T
  }
}