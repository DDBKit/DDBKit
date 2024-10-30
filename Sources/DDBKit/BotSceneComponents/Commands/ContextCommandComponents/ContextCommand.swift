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
  
  var preActions: [(CommandDescription, any DiscordGateway.GatewayManager, DiscordGateway.DiscordCache, Interaction, DatabaseBranches) async throws -> Void] = []
  var postActions: [(CommandDescription, any DiscordGateway.GatewayManager, DiscordGateway.DiscordCache, Interaction, DatabaseBranches) async throws -> Void] = []
  
  var modalReceives: [String : [(Interaction, Interaction.ModalSubmit, DatabaseBranches) async throws -> Void]] = [:]
  var componentReceives: [String : [(Interaction, Interaction.MessageComponent, DatabaseBranches) async throws -> Void]] = [:]
  
  var guildScope: CommandGuildScope = .init(scope: .global, guilds: [])
  var baseInfo: Payloads.ApplicationCommandCreate
  
  func trigger(_ i: Interaction) async throws {
    switch i.data {
    case .applicationCommand(let j):
      let k: DatabaseBranches = .init(i)
      do {
        try await preAction(i)
        try await action(i, j, k)
        try await postAction(i)
      } catch {
        if let localThrowCatch { try await localThrowCatch(error, i) }
        else { throw error }
      }
    default: break
    }
  }
  
  var action: (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async throws -> Void

  
  public init(_ name: String, kind: Kind, action: @escaping (Interaction, Interaction.ApplicationCommand, DatabaseBranches) async throws -> Void) {
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
  
  func preAction(_ interaction: Interaction) async throws {
    // do things like sending defer, processing, idk
  }
  func postAction(_ interaction: Interaction) async throws {
    // idk maybe register something internally, just here for completeness
  }
}
