//
//  _InternalCommandComponent.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 17/09/2024.
//

import DiscordModels
import DiscordGateway
import DiscordHTTP

/// Give `Command` and `ComplexCommand` conformance so they can be used the same behind the scenes
protocol BaseCommand: BaseContextCommand {
  func autocompletion(
    _ i: Interaction,
    cmd: Interaction.ApplicationCommand,
    opt: Interaction.ApplicationCommand.Option,
    client: DiscordClient
  ) async
}

public protocol BaseContextCommand: BotScene { // used in context menus like users and messages, so lacks autocomplete
  var guildScope: CommandGuildScope { get set }
  var baseInfo: Payloads.ApplicationCommandCreate { get set }
  func trigger(_ i: Interaction, _ instance: BotInstance) async throws
  
  // contains callbacks for registering to the botinstance
  var modalReceives: [String: [@Sendable (InteractionExtras) async throws -> Void]] { get }
  var componentReceives: [String: [@Sendable (InteractionExtras) async throws -> Void]] { get }
}

/// This protocol provides a way to identify commands, this is only used
/// within the bot itself and is not exposed to discord. Best used in context
/// of an extension that requires binding to commands you specify.
public protocol IdentifiableCommand {
  /// The stable identity of the entity associated with this instance.
  @_spi(Extensions)
  var id: (any Hashable)? { get set }
}

extension IdentifiableCommand {
  /// Provide a command with an identifier used to allow extensions to
  /// easily find commands to bind to.
  /// - Parameter id: Any hashable type
  public func id(_ id: (any Hashable)?) -> Self {
    var copy = self
    copy.id = id
    return copy
  }
}

public struct CommandGuildScope: Sendable {
  var scope: ScopeType
  var guilds: [GuildSnowflake]
  
	public enum ScopeType: Sendable {
    case global
    case local
  }
}
