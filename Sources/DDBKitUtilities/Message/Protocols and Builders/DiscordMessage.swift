//
//  DiscordMessage.swift
//  
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation
import DiscordModels
import NIOCore

@resultBuilder
public struct MessageComponentBuilder {
  public static func buildBlock(_ components: MessageComponent...) -> [MessageComponent] { components }
}

/// Stores things like message content, any embeds, etc
public struct Message {
  /// our types we keep track of the message state with
  public var content: MessageContent
  public var embeds: [MessageEmbed]
  public var attachments: [MessageAttachment]
  /// discord types we'll be sending off
  
//  var _nonce: StringOrInt?
  var _content: String? { self.content.textualRepresentation.isEmpty ? nil : self.content.textualRepresentation }
  var _tts: Bool? // set by modifier
  var _embeds: [Embed] { self.embeds.map(\.embed) }
  var _allowed_mentions: Payloads.AllowedMentions?
  var _message_reference: DiscordChannel.Message.MessageReference?
  var _components: [Interaction.ActionRow]?
  var _sticker_ids: [String]?
  var _files: [RawFile]? { self.attachments.map { RawFile(data: $0.data, filename: $0.filename) } }
  var _attachments: [Payloads.Attachment]? { self.attachments.enumerated().compactMap {
    if $0.element.use == .embed { return nil } // the user wants to use this in an embed
    return Payloads.Attachment(
      index: $0.offset,
      filename: $0.element.filename,
      description: $0.element.description,
      ephemeral: $0.element.ephemeral
    ) }
  }
  var _flags: IntBitField<DiscordChannel.Message.Flag>?
  var _enforce_nonce: Bool?
  var _poll: Payloads.CreatePollRequest?
}

// MARK: - Public modifiers
public extension Message {
  /// Whether or not to enable text-to-speech on this message
  func tts(_ enabled: Bool = true) -> Self {
    var copy = self
    copy._tts = true
    return copy
  }
  
  /// Message flags
  func flags(_ flags: IntBitField<DiscordChannel.Message.Flag>) -> Self {
    var copy = self
    copy._flags = flags
    return copy
  }
}

/// All kinds of data in a `Message` object must conform to this
public protocol MessageComponent { }

