//
//  InteractionExtras.swift
//
//
//  Created by Lakhan Lothiyi on 12/11/2024.
//

import DiscordGateway
import DiscordHTTP
import DiscordModels

public struct InteractionExtras: Sendable {
  // core stuff
  @_spi(Extensions)
  public var instance: BotInstance
  public var interaction: Interaction
  var _options: [Interaction.ApplicationCommand.Option]?

  internal init(
    _ instance: BotInstance, _ interaction: Interaction,
    _ options: [Interaction.ApplicationCommand.Option]? = nil
  ) {
    self.instance = instance
    self.interaction = interaction
    self._options = options
    // if in the case we need to override the options (eg for subcommand context correction)
    // we set _options to the new options and options will read from it over the original options
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

  public func getExtension<T>(_ type: T.Type) -> T where T: DDBKitExtension {
    self.instance.extensions.first(where: { $0 is T })! as! T
  }
}
