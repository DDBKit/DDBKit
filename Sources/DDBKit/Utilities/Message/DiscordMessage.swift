//
//  DiscordMessage.swift
//  
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation
import DiscordModels

@resultBuilder
public struct MessageComponentBuilder {
  public static func buildBlock(_ components: MessageComponent...) -> [MessageComponent] { components }
}

@resultBuilder
public struct MessageContentBuilder {
  public static func buildBlock(_ components: MessageContentComponent...) -> [MessageContentComponent] { components }
  public static func buildOptional(_ component: [any MessageContentComponent]?) -> any MessageContentComponent { FlattenedComponent(components: component ?? []) }
  public static func buildEither(first component: [any MessageContentComponent]) -> any MessageContentComponent { FlattenedComponent(components: component) }
  public static func buildEither(second component: [any MessageContentComponent]) -> any MessageContentComponent { FlattenedComponent(components: component) }
  
  /// Used internally to flatten conditional branches to text. reduces code complexity.
  public struct FlattenedComponent: MessageContentComponent {
    var components: [any MessageContentComponent]
    init(components: [any MessageContentComponent]) {
      self.components = components
    }
    
    public var textualRepresentation: String {
      self.components.reduce("") { partialResult, component in
        return partialResult + component.textualRepresentation
      }
    }
  }
}

@resultBuilder
public struct MessageEmbedBuilder {
  public static func buildBlock(_ components: MessageEmbedComponent...) -> [MessageEmbedComponent] { components }
  public static func buildOptional(_ component: [any MessageEmbedComponent]?) -> any MessageEmbedComponent { EmbedTuple(component ?? []) }
  public static func buildEither(first component: [any MessageEmbedComponent]) -> any MessageEmbedComponent { EmbedTuple(component) }
  public static func buildEither(second component: [any MessageEmbedComponent]) -> any MessageEmbedComponent { EmbedTuple(component) }
  
  /// used internally to allow logic
  public struct EmbedTuple: MessageEmbedComponent {
    var contained: [any MessageEmbedComponent]
    
    init(_ contained: [any MessageEmbedComponent]) {
      self.contained = contained
    }
  }
}

/// Stores things like message content, any embeds, etc
public struct Message {
  public var content: MessageContent
  public var embeds: [MessageEmbed]
  
//  public var nonce: StringOrInt?
  public var tts: Bool?
//  public var embeds: [Embed]?
//  public var allowed_mentions: AllowedMentions?
  public var message_reference: DiscordChannel.Message.MessageReference?
//  public var components: [Interaction.ActionRow]?
  public var sticker_ids: [String]?
  public var files: [RawFile]?
//  public var attachments: [Attachment]?
  public var flags: IntBitField<DiscordChannel.Message.Flag>?
  public var enforce_nonce: Bool?
//  public var poll: CreatePollRequest?
  
  /// Initializes a message with content and embeds
  /// - Parameter components: Message components
  public init(
    @MessageComponentBuilder
    components: () -> [MessageComponent]
  ) {
    let components = components()
    self.content = (components.last(where: {$0 is MessageContent}) as? MessageContent) ?? .init(message: { })
    self.embeds = components.filter { $0 is MessageEmbed } as? [MessageEmbed] ?? []
  }
  
  /// Initializes a message's content
  /// - Parameter message: Message content components
  public init(
    @MessageContentBuilder
    message: () -> [MessageContentComponent]
  ) {
    self.content = .init(message: message)
    self.embeds = []
  }
}

/// All kinds of data in a `message` object must conform to this
public protocol MessageComponent { }


// MARK: - Convert to DiscordBM message
//public extension Message {
//  var _createMessage: Payloads.CreateMessage {
//    .init(
//      content: <#T##String?#>,
//      nonce: <#T##StringOrInt?#>,
//      tts: <#T##Bool?#>,
//      embeds: <#T##[Embed]?#>,
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
