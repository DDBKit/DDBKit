//
//  Subcommand.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 07/10/2024.
//

import DiscordBM

/// A subcommand to a base or group
public struct Subcommand: BaseInfoType, LocalisedThrowable {
  @_spi(Extensions)
  public var localThrowCatch:
    (@Sendable (any Error, DiscordModels.Interaction) async throws -> Void)?

  var options: [Option] = []
  var baseInfo: ApplicationCommand.Option
  var action: @Sendable (InteractionExtras) async throws -> Void

  func trigger(
    _ i: Interaction,
    _ e: InteractionExtras,
    _ actions: ActionInterceptions,
    _ cmdInstance: BaseContextCommand
  ) async throws {
    do {
      try await action(e)
    } catch {
      if let localThrowCatch {
        try await localThrowCatch(error, i)
      } else {
        throw error
      }
    }
  }

  public init(_ name: String, action: @Sendable @escaping (InteractionExtras) async throws -> Void)
  {
    self.action = action

    self.baseInfo = .init(
      type: .subCommand,
      name: name,
      name_localizations: nil,
      description: "This subcommand has no description.",
      description_localizations: nil,
      options: []
    )
  }

  func autocompletion(
    _ i: Interaction, cmd: Interaction.ApplicationCommand,
    opt: Interaction.ApplicationCommand.Option, client: DiscordClient
  ) async {
    guard opt.value != nil else { return }
    /// no point doing work if no value is present to derive autocompletions from
    // find autocompletable options
    let autocompletableOptions = self.options.compactMap { $0 as? _AutocompletableOption }

    // find applicable option in autocompletable options
    let option = autocompletableOptions.first(where: { $0.optionData.name == opt.name })
    // run autocompletions callback

    let autocompletionsValues = await option?.autocompletion?(opt, cmd)

    // return these choices
    _ = try? await client.createInteractionResponse(
      id: i.id, token: i.token,
      payload: .autocompleteResult(.init(choices: autocompletionsValues ?? [])))
  }
}
