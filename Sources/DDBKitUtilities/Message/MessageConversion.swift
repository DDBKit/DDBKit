//
//  MessageConversion.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 25/09/2024.
//

import DiscordModels

// MARK: - Convert to DiscordBM message
//public extension Message {
//  var _createMessage: Payloads.CreateMessage {
//    let content = self.content.textualRepresentation.isEmpty ? nil : self.content.textualRepresentation
//    let embeds = self.embeds.map { $0.embed }
//    return .init(
//      content: content,
//      nonce: nil,
//      tts: <#T##Bool?#>,
//      embeds: embeds,
//      allowed_mentions: <#T##Payloads.AllowedMentions?#>,
//      message_reference: <#T##DiscordChannel.Message.MessageReference?#>,
//      components: <#T##[Interaction.ActionRow]?#>,
//      sticker_ids: <#T##[String]?#>,
//      files: <#T##[RawFile]?#>,
//      attachments: <#T##[Payloads.Attachment]?#>,
//      flags: <#T##IntBitField<DiscordChannel.Message.Flag>?#>,
//      enforce_nonce: <#T##Bool?#>,
//      poll: <#T##Payloads.CreatePollRequest?#>
//    )
//  }
//}
