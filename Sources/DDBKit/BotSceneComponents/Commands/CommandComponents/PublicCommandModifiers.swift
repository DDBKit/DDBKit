//
//  PublicCommandModifiers.swift
//  
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation
@_spi(UserInstallableApps) import DiscordModels

// misc modifiers go here

public extension Command {
  // add these at some point
  //  self.baseInfo = .init(
  //    name_localizations: <#T##[DiscordLocale : String]?#>,
  //    description_localizations: <#T##[DiscordLocale : String]?#>,
  //  )
  
  /// Add options to the command.
  /// - Parameter options: StringOption IntOption BoolOption UserOption ChannelOption RoleOption MentionableOption DoubleOption AttachmentOption
  func addingOptions(
    @CommandOptionsBuilder
    options: () -> [Option]
  ) -> Self {
    var copy = self
    copy.options.append(contentsOf: options())
    copy.baseInfo.options = copy.baseInfo.options ?? []
    copy.baseInfo.options = copy.options.map(\.optionData)
    return copy
  }
  
  /// The command's description.
  func description(_ description: String) -> Self {
    var copy = self
    copy.baseInfo.description = description
    return copy
  }
  
  /// Whether or not this command can be used in DMs.
  func isUsableInDMS(_ usable: Bool) -> Self {
    var copy = self
    copy.baseInfo.dm_permission = usable
    return copy
  }
  
  func defaultPermissionRequirement(_ perms: [Permission]) -> Self {
    var copy = self
    copy.baseInfo.default_member_permissions = Optional(perms).map({ .init($0) }) // Optional is part of a weird type requirement
    return copy
  }
  
  /// Whether or not this command is NSFW.
  func isNSFW(_ nsfw: Bool) -> Self {
    var copy = self
    copy.baseInfo.nsfw = nsfw
    return copy
  }
  
  /// How and where this command can be utilised.
  func integrationType(_ type: IType, contexts: IContexts) -> Self {
    var copy = self
    copy.baseInfo.integration_types = type.map(\.value)
    copy.baseInfo.contexts = contexts.map(\.value)
    return copy
  }
  
  typealias IType = [Self.IntegrationKind]
  typealias IContexts = [Self.ContextKind]
  
  struct IntegrationTypeOptions: OptionSet, Sendable {
    public let rawValue: UInt
    public init(rawValue: UInt) {
      self.rawValue = rawValue
    }
    static let guildInstall    = IntegrationTypeOptions(rawValue: 1 << 0)
    static let userInstall  = IntegrationTypeOptions(rawValue: 1 << 1)
  }
  
  
  enum IntegrationKind {
    case guildInstall // 0
    case userInstall // 1
    
    var value: DiscordApplication.IntegrationKind {
      return switch self {
      case .guildInstall: .guildInstall
      case .userInstall: .userInstall
      }
    }
  }
  enum ContextKind {
    case guild // 0
    case botDm // 1
    case privateChannel // 2
    
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
  func guildScope(
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
  func modal(on id: String, _ event: @escaping (InteractionExtras) async throws -> Void) -> Self {
    var copy = self
    copy.modalReceives.append(event, to: id)
    return copy
  }
  
  /// Receive all modal events, intended for manual handling control.
  /// - Parameters:
  ///   - event: Event callback
  func modal(_ event: @escaping (InteractionExtras) async throws -> Void) -> Self {
    var copy = self
    copy.modalReceives.append(event, to: "")
    return copy
  }
  
  /// Receive component interactions under this custom ID.
  /// - Parameters:
  ///   - id: Modal custom ID
  ///   - event: Event callback
  func component(on id: String, _ event: @escaping (InteractionExtras) async throws -> Void) -> Self {
    var copy = self
    copy.componentReceives.append(event, to: id)
    return copy
  }
  
  /// Receive all component interaction events, intended for manual handling control.
  /// - Parameters:
  ///   - event: Event callback
  func component(_ event: @escaping (InteractionExtras) async throws -> Void) -> Self {
    var copy = self
    copy.componentReceives.append(event, to: "")
    return copy
  }
}

public extension Command.IType {
  /// Specifies guild and user installs
  static var all: Self { [.guildInstall, .userInstall] }
}
public extension Command.IContexts {
  /// Specifies bot DMs, guilds, and user DMs
  static var all: Self { [.botDm, .guild, .privateChannel] }
}
