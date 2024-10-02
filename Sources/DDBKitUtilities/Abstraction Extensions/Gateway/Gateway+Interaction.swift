//
//  Gateway+CommandResponses.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 26/09/2024.
//

import DiscordBM

// MARK: Create Interaction response
public extension GatewayManager {
  func createInteractionResponse(to i: Interaction, type: Payloads.InteractionResponse) async throws {
    try await self.client.createInteractionResponse(id: i.id, token: i.token, payload: type)
      .guardSuccess()
  }
  
  func updateOriginalInteractionResponse(of i: Interaction, msg: () -> Message) async throws {
    try await self.client.updateOriginalInteractionResponse(token: i.token, payload: msg()._editWebhookMessage)
      .guardSuccess()
  }
}

