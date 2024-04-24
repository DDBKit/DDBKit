//
//  DiscordMessage.swift
//  
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation

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
