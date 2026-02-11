//
//  ContextCommand.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 15/10/2024.
//

@_spi(UserInstallableApps) import DiscordBM

public struct Context: BaseContextCommand, _ExtensibleCommand, IdentifiableCommand,
  LocalisedThrowable
{
  public var localThrowCatch:
    (@Sendable (any Error, DiscordModels.Interaction) async throws -> Void)?

  @_spi(Extensions)
  public nonisolated(unsafe) var id: (any Hashable)?

  var actions: ActionInterceptions = .init()

  @_spi(Extensions)
  public var modalReceives: [String: [@Sendable (InteractionExtras) async throws -> Void]] = [:]
  @_spi(Extensions)
  public var componentReceives: [String: [@Sendable (InteractionExtras) async throws -> Void]] = [:]

  @_spi(Extensions)
  public var guildScope: CommandGuildScope = .init(scope: .global, guilds: [])
  @_spi(Extensions)
  public var baseInfo: Payloads.ApplicationCommandCreate

  @_spi(Extensions)
  public func trigger(_ i: Interaction, _ instance: BotInstance) async throws {
    let e = InteractionExtras(instance, i)
    do {
      try await preAction(e)
      try await action(e)
      try await postAction(e)
    } catch {
      if let localThrowCatch { try await localThrowCatch(error, i) }
      // run error actions in order
      for errorAction in self.actions.errorActions {
        try? await errorAction(error, self, e)
      }
      if localThrowCatch == nil { throw error }
    }
  }

  var action: @Sendable (InteractionExtras) async throws -> Void

  public init(
    _ name: String, kind: ApplicationCommand.Kind, action: @Sendable @escaping (InteractionExtras) async throws -> Void
  ) {
    self.baseInfo = .init(
      name: name,
      name_localizations: nil,
      description: nil,
      description_localizations: nil,
      options: [],
      default_member_permissions: nil,
      dm_permission: nil,
	  type: kind,
      nsfw: nil
    )
    self.baseInfo.integration_types = [.guildInstall]
    self.baseInfo.contexts = [.guild]

    self.action = action
  }

  // MARK: - These pre and post actions are for use internally

  func preAction(_ e: InteractionExtras) async throws {
    // do things like sending defer, processing, idk

    // run preActions in order
    for preAction in self.actions.preActions {
      try await preAction(self, e)
    }
  }
  func postAction(_ e: InteractionExtras) async throws {
    // idk maybe register something internally, just here for completeness

    // run postActions in order
    for postAction in self.actions.postActions {
      try await postAction(self, e)
    }
  }
}
