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
      tts: _tts, // we should add this soon
      embeds: _embeds,
      allowed_mentions: _allowed_mentions, // we should add this soon
      message_reference: _message_reference, // we should add this soon
      components: _components, // we should add this soon
      sticker_ids: _sticker_ids, // we should add this soon
      files: _files, // we should add this soon
      attachments: _attachments, // we should add this soon
      flags: _flags, // we should add this soon
      enforce_nonce: nil, // we should add this soon
      poll: _poll // we should add this soon
    )
  }
  var _editWebhookMessage: Payloads.EditWebhookMessage {
    return .init(
      content: _content,
      embeds: _embeds,
      allowed_mentions: _allowed_mentions, // we should add this soon
      components: _components, // we should add this soon
      files: _files, // we should add this soon
      attachments: _attachments // we should add this soon
    )
  }
  
  var _interactionResponseMessage: Payloads.InteractionResponse.Message {
    return .init(
      tts: nil, // we should add this soon
      content: _content,
      embeds: _embeds,
      allowedMentions: _allowed_mentions, // we should add this soon
      flags: _flags, // we should add this soon
      components: _components, // we should add this soon
      attachments: _attachments, // we should add this soon
      files: _files, // we should add this soon
      poll: _poll // we should add this soon
    )
  }
}
