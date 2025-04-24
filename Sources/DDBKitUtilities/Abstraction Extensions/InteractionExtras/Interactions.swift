//
//  Interactions.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 26/09/2024.
//

import DiscordBM
import DDBKit

public extension InteractionExtras {
  // MARK: Create Interaction response
  func respond(with type: Payloads.InteractionResponse) async throws {
    try await self.client.createInteractionResponse(
      id: interaction.id,
      token: interaction.token,
      payload: type
    )
    .guardSuccess()
  }
  
  func respond(_ msg: @Sendable () -> Message) async throws {
    try await self.client.createInteractionResponse(
      id: interaction.id,
      token: interaction.token,
      payload: .channelMessageWithSource(
        msg()._interactionResponseMessage
      )
    )
    .guardSuccess()
  }
  
  func respond(_ modal: @Sendable () -> Modal) async throws {
    try await self.client.createInteractionResponse(
      id: interaction.id,
      token: interaction.token,
      payload: .modal(
        modal().modal
      )
    )
    .guardSuccess()
  }
  
  func respond(with msg: String) async throws {
    try await self.client.createInteractionResponse(
      id: interaction.id,
      token: interaction.token,
      payload: .channelMessageWithSource(
        .init(content: msg)
      ))
    .guardSuccess()
  }
  
  // MARK: Create Followup Response
  func followup(with type: Payloads.ExecuteWebhook) async throws {
    try await self.client.createFollowupMessage(
      token: interaction.token,
      payload: type
    )
    .guardSuccess()
  }
  
  func followup(_ msg: () -> Message) async throws {
    try await self.client.createFollowupMessage(
      token: interaction.token,
      payload: msg()._webhookResponseMessage
    )
    .guardSuccess()
  }
  
  func followup(with msg: String) async throws {
    try await self.client.createFollowupMessage(
      token: interaction.token,
      payload: .init(content: msg)
    )
    .guardSuccess()
  }
  
  // MARK: Edit Interaction response
  func editResponse(_ msg: () -> Message) async throws {
    try await self.client.updateOriginalInteractionResponse(
      token: interaction.token,
      payload: msg()._editWebhookMessage
    )
    .guardSuccess()
  }
  
  func editResponse(with msg: String) async throws {
    try await self.client.updateOriginalInteractionResponse(
      token: interaction.token,
      payload: .init(content: msg)
    )
    .guardSuccess()
  }
  
  // MARK: Delete Interaction response
  func deleteResponse() async throws {
    try await self.client.deleteOriginalInteractionResponse(token: interaction.token)
      .guardSuccess()
  }
  
  // MARK: Options
  
  /// Get the value given for a user option.
  /// Returns `nil` if it was not provided for an optional option, or if DiscordBM could not get the value
  func getUser(from option: String) async -> DiscordUser? {
    guard let id = try? self.options?.option(named: option)?.requireString() else { return nil }
    guard let value = try? await self.client.getUser(id: .init(id)).decode() else { return nil }
    return value
  }
  
  /// Get the value given for a role option.
  /// Returns `nil` if it was not provided for an optional option, or if DiscordBM could not get the value
  func getRole(from option: String) async -> Role? {
    guard let id = try? self.options?.option(named: option)?.requireString() else { return nil }
    // guild id will probably never be nil
    // you can use commands with role options in DMs, they are just broken and will not work no matter what
    guard let value = try? await self.client.listGuildRoles(id: self.interaction.guild_id!).decode() else { return nil }
    return value.first { $0.id.rawValue == id }
  }
  
  /// Get the value given for a string option.
  /// Returns `nil` if it was not provided for an optional option, or if DiscordBM could not get the value
  func getString(from option: String) async -> String? {
    guard let value = try? self.options?.option(named: option)?.requireString() else { return nil }
    return value
  }
  
  /// Get the value given for a bool option.
  /// Returns `nil` if it was not provided for an optional option, or if DiscordBM could not get the value
  func getBool(from option: String) async -> Bool? {
    guard let value = try? self.options?.option(named: option)?.requireBool() else { return nil }
    return value
  }
  
  /// Get the value given for an int option.
  /// Returns `nil` if it was not provided for an optional option, or if DiscordBM could not get the value
  func getInteger(from option: String) async -> Int? {
    guard let value = try? self.options?.option(named: option)?.requireInt() else { return nil }
    return value
  }
  
  /// Get the value given for a double option.
  /// Returns `nil` if it was not provided for an optional option, or if DiscordBM could not get the value
  func getDouble(from option: String) async -> Double? {
    guard let value = try? self.options?.option(named: option)?.requireDouble() else { return nil }
    return value
  }
  
  /// Get the value given for an attachment option.
  /// Returns `nil` if it was not provided for an optional option, or if DiscordBM could not get the value
  func getAttachment(from option: String) async -> DiscordChannel.Message.Attachment? {
    guard let value = await self.getString(from: option) else { return nil }
    return self.attachments.values.first { $0.id.rawValue == value }
  }
}
