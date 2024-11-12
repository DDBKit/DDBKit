//
//  ContextCommand.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 15/10/2024.
//

@_spi(UserInstallableApps) import DiscordBM

public struct Context: BaseContextCommand, _ExtensibleCommand, IdentifiableCommand, LocalisedThrowable {  
  public var localThrowCatch: ((any Error, DiscordModels.Interaction) async throws -> Void)?
  
  @_spi(Extensions)
  public var id: (any Hashable)?
  
  var actions: ActionInterceptions = .init()
  
  public var modalReceives: [String : [(Interaction, InteractionExtras) async throws -> Void]] = [:]
  public var componentReceives: [String : [(Interaction, InteractionExtras) async throws -> Void]] = [:]
  
  public var guildScope: CommandGuildScope = .init(scope: .global, guilds: [])
  public var baseInfo: Payloads.ApplicationCommandCreate
  
  public func trigger(_ i: Interaction, _ instance: BotInstance) async throws {
    let e = InteractionExtras(instance, i)
    do {
      try await preAction(i, e)
      try await action(i, e)
      try await postAction(i, e)
    } catch {
      if let localThrowCatch { try await localThrowCatch(error, i) }
        // run error actions in order
      for errorAction in self.actions.errorActions {
        try? await errorAction(error, self, i, e)
      }
      if localThrowCatch == nil { throw error }
    }
  }
  
  var action: (Interaction, InteractionExtras) async throws -> Void
  
  public init(_ name: String, kind: Kind, action: @escaping (Interaction, InteractionExtras) async throws -> Void) {
    self.baseInfo = .init(
      name: name,
      name_localizations: nil,
      description: nil,
      description_localizations: nil,
      options: [],
      default_member_permissions: nil,
      dm_permission: nil,
      type: .init(rawValue: kind.rawValue),
      nsfw: nil
    )
    self.baseInfo.integration_types = [.guildInstall]
    self.baseInfo.contexts = [.guild]
    
    self.action = action
  }
  
  public enum Kind: UInt {
    case user = 2 // ApplicationCommand.Kind.user.rawValue
    case message = 3 // ApplicationCommand.Kind.message.rawValue
  }
  
  // MARK: - These pre and post actions are for use internally
  
  func preAction(_ i: Interaction, _ e: InteractionExtras) async throws {
    // do things like sending defer, processing, idk
    
    // run preActions in order
    for preAction in self.actions.preActions {
      try await preAction(
        self,
        i, e
      )
    }
  }
  func postAction(_ i: Interaction, _ e: InteractionExtras) async throws {
    // idk maybe register something internally, just here for completeness
    
    // run postActions in order
    for postAction in self.actions.postActions {
      try await postAction(
        self,
        i, e
      )
    }
  }
}
