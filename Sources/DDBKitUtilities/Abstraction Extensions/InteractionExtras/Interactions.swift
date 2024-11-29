//
//  Gateway+CommandResponses.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 26/09/2024.
//

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
  
  func respond(_ msg: () -> Message) async throws {
    try await self.client.createInteractionResponse(
      id: interaction.id,
      token: interaction.token,
      payload: .channelMessageWithSource(
        msg()._interactionResponseMessage
      )
    )
    .guardSuccess()
  }
  
  func respond(_ modal: () -> Modal) async throws {
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
}
