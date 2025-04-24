//
//  DiscordMessage.swift
//  
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation
import DiscordModels
import NIOCore

/// Stores things like message content, any embeds, etc
public struct Message: Sendable {
  // MARK: - our types we keep track of the message state with
  public var content: MessageContent
  public var embeds: [MessageEmbed]
  public var attachments: [MessageAttachment]
  public var components: MessageComponents
  public var stickers: [MessageSticker]
  public var poll: MessagePoll?
  
  // MARK: - discord types we'll be sending off
  var _nonce: StringOrInt?
  var _content: String? { self.content.textualRepresentation.isEmpty ? nil : self.content.textualRepresentation }
  var _tts: Bool? // set by modifier
  var _embeds: [Embed] { self.embeds.map(\.embed) }
  var _allowed_mentions: Payloads.AllowedMentions?
  var _message_reference: DiscordChannel.Message.MessageReference?
  var _components: [Interaction.ActionRow]? {
    self.components.rows.reduce([Interaction.ActionRow]()) { partialResult, row in
      var partialResult = partialResult
      partialResult.append(Interaction.ActionRow(components: (row as! _ActionRowProtocol).components.map { ($0 as! _MessageComponentsActionRowComponent).component }))
      return partialResult
    }
  }
  var _sticker_ids: [String]? { self.stickers.map { $0.id } }
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
  var _flags: IntBitField<DiscordChannel.Message.Flag> = .init()
  var _enforce_nonce: Bool?
  var _poll: Payloads.CreatePollRequest? { self.poll?.poll }
}

// MARK: - Public modifiers
public extension Message {
  /// Whether or not to enable text-to-speech on this message.
  func tts(_ enabled: Bool = true) -> Self {
    var copy = self
    copy._tts = true
    return copy
  }
  
  /// Whether or not this message is ephemeral.
  func ephemeral(_ enabled: Bool = true) -> Self {
    var copy = self
    if enabled {
      copy._flags.insert(.ephemeral)
    } else {
      copy._flags.remove(.ephemeral)
    }
    return copy
  }
  
  /// Message flags manual configuration, this will override previous modifiers.
  func flags(_ flags: IntBitField<DiscordChannel.Message.Flag>) -> Self {
    var copy = self
    copy._flags = flags
    return copy
  }
  
  /// Sets the allowed mentions for this message
  func allowedMentions(
    _ kind: [DiscordChannel.AllowedMentions.Kind]? = nil,
    roles: [RoleSnowflake]? = nil,
    users: [UserSnowflake]? = nil,
    repliedUser: Bool? = true
  ) -> Self {
    var copy = self
    copy._allowed_mentions = .init(
      parse: kind,
      roles: roles,
      users: users,
      replied_user: repliedUser
    )
    return copy
  }
}

/// All kinds of data in a `Message` object must conform to this
public protocol MessageComponent: Sendable { }
