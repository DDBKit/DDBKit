//
//  MessageConversion.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 25/09/2024.
//

import DiscordModels

// MARK: - Convert to DiscordBM message
public extension Message {
  var _createMessage: Payloads.CreateMessage {
    let content = self.content.textualRepresentation.isEmpty ? nil : self.content.textualRepresentation
    let embeds = self.embeds.map { $0.embed }
    return .init(
      content: content,
      nonce: nil,
      tts: nil, // we should add this soon
      embeds: embeds,
      allowed_mentions: nil, // we should add this soon
      message_reference: nil, // we should add this soon
      components: nil, // we should add this soon
      sticker_ids: nil, // we should add this soon
      files: nil, // we should add this soon
      attachments: nil, // we should add this soon
      flags: nil, // we should add this soon
      enforce_nonce: nil, // we should add this soon
      poll: nil // we should add this soon
    )
  }
  var _editWebhookMessage: Payloads.EditWebhookMessage {
    let content = self.content.textualRepresentation.isEmpty ? nil : self.content.textualRepresentation
    let embeds = self.embeds.map { $0.embed }
    return .init(
      content: content,
      embeds: embeds,
      allowed_mentions: nil, // we should add this soon
      components: nil, // we should add this soon
      files: nil, // we should add this soon
      attachments: nil // we should add this soon
    )
  }
}
