//
//  IntegrationTypeOptions.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 15/10/2024.
//

@_spi(UserInstallableApps) import DiscordModels
import Foundation

// misc modifiers go here

extension Context {
  /// Whether or not this command can be used in DMs.
  public func isUsableInDMS(_ usable: Bool) -> Self {
    var copy = self
    copy.baseInfo.dm_permission = usable
    return copy
  }

  public func defaultPermissionRequirement(_ perms: [Permission]) -> Self {
    var copy = self
    copy.baseInfo.default_member_permissions = Optional(perms).map({ .init($0) })  // Optional is part of a weird type requirement
    return copy
  }

  /// Whether or not this command is NSFW.
  public func isNSFW(_ nsfw: Bool) -> Self {
    var copy = self
    copy.baseInfo.nsfw = nsfw
    return copy
  }

  /// How and where this command can be utilised.
  public func integrationType(_ type: IType, contexts: IContexts) -> Self {
    var copy = self
    copy.baseInfo.integration_types = type.map(\.value)
    copy.baseInfo.contexts = contexts.map(\.value)
    return copy
  }

  public typealias IType = [Self.IntegrationKind]
  public typealias IContexts = [Self.ContextKind]

  public struct IntegrationTypeOptions: OptionSet, Sendable {
    public let rawValue: UInt
    public init(rawValue: UInt) {
      self.rawValue = rawValue
    }
    static let guildInstall = IntegrationTypeOptions(rawValue: 1 << 0)
    static let userInstall = IntegrationTypeOptions(rawValue: 1 << 1)
  }

  public enum IntegrationKind {
    case guildInstall  // 0
    case userInstall  // 1

    var value: DiscordApplication.IntegrationKind {
      return switch self {
      case .guildInstall: .guildInstall
      case .userInstall: .userInstall
      }
    }
  }
  public enum ContextKind {
    case guild  // 0
    case botDm  // 1
    case privateChannel  // 2

    var value: Interaction.ContextKind {
      switch self {
      case .guild: .guild
      case .botDm: .botDm
      case .privateChannel: .privateChannel
      }
    }
  }

  /// Scopes this command to global use or local to a set of servers.
  /// Intended to make development and testing easier.
  /// This will only be used on registration of a command at launch.
  /// - Parameters:
  ///   - scope: The local or global scope
  ///   - guilds: The guild snowflakes to add onto the array of guilds to target
  public func guildScope(
    _ scope: CommandGuildScope.ScopeType,
    _ guilds: [GuildSnowflake] = []
  ) -> Self {
    var copy = self
    copy.guildScope.scope = scope
    copy.guildScope.guilds.append(contentsOf: guilds)
    return copy
  }

  /// Receive modals under this custom ID.
  /// - Parameters:
  ///   - id: Modal custom ID
  ///   - event: Event callback
  public func modal(
    on id: String, _ event: @Sendable @escaping (InteractionExtras) async throws -> Void
  ) -> Self {
    var copy = self
    copy.modalReceives.append(event, to: id)
    return copy
  }

  /// Receive all modal events, intended for manual handling control.
  /// - Parameters:
  ///   - event: Event callback
  public func modal(_ event: @Sendable @escaping (InteractionExtras) async throws -> Void) -> Self {
    var copy = self
    copy.modalReceives.append(event, to: "")
    return copy
  }

  /// Receive component interactions under this custom ID.
  /// - Parameters:
  ///   - id: Modal custom ID
  ///   - event: Event callback
  public func component(
    on id: String, _ event: @Sendable @escaping (InteractionExtras) async throws -> Void
  ) -> Self {
    var copy = self
    copy.componentReceives.append(event, to: id)
    return copy
  }

  /// Receive all component interaction events, intended for manual handling control.
  /// - Parameters:
  ///   - event: Event callback
  public func component(_ event: @Sendable @escaping (InteractionExtras) async throws -> Void)
    -> Self
  {
    var copy = self
    copy.componentReceives.append(event, to: "")
    return copy
  }
}

extension Context.IType {
  /// Specifies guild and user installs
  public static var all: Self { [.guildInstall, .userInstall] }
}
extension Context.IContexts {
  /// Specifies bot DMs, guilds, and user DMs
  public static var all: Self { [.botDm, .guild, .privateChannel] }
}
