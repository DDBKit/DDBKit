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
    return .init(
      content: _content,
      nonce: nil,
      tts: _tts,
      embeds: _embeds,
      allowed_mentions: _allowed_mentions,
      message_reference: _message_reference,
      components: _components,
      sticker_ids: _sticker_ids,
      files: _files,
      attachments: _attachments,
      flags: _flags,
      enforce_nonce: nil,
      poll: _poll
    )
  }
  var _editWebhookMessage: Payloads.EditWebhookMessage {
    return .init(
      content: _content,
      embeds: _embeds,
      allowed_mentions: _allowed_mentions,
      components: _components,
      files: _files,
      attachments: _attachments
    )
  }
  
  var _interactionResponseMessage: Payloads.InteractionResponse.Message {
    return .init(
      tts: _tts,
      content: _content,
      embeds: _embeds,
      allowedMentions: _allowed_mentions,
      flags: _flags,
      components: _components,
      attachments: _attachments,
      files: _files,
      poll: _poll
    )
  }
  
  var _editMessage: Payloads.EditMessage {
    return .init(
      content: _content,
      embeds: _embeds,
      flags: _flags,
      allowed_mentions: _allowed_mentions,
      components: _components,
      files: _files,
      attachments: _attachments
    )
  }
}
