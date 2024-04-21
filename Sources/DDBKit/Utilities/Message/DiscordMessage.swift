//
//  DiscordMessage.swift
//  
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation

public struct Message {
  public var content: MessageContent
  public var embeds: [MessageEmbed]
  
  /// Initializes a message with content and embeds
  /// - Parameter components: Message components
  public init(
    @MessageUtilityBuilder<MessageComponent>
    components: () -> [MessageComponent]
  ) {
    let components = components()
    self.content = (components.last(where: {$0 is MessageContent}) as? MessageContent) ?? .init(message: {})
    self.embeds = components.filter { $0 is MessageEmbed } as? [MessageEmbed] ?? []
  }
  
  /// Initializes a message's content
  /// - Parameter message: Message content components
  public init(
    @MessageUtilityBuilder<MessageContentComponent>
    message: () -> [MessageContentComponent]
  ) {
    self.content = .init(message: message)
    self.embeds = []
  }
}

public protocol MessageComponent {
}

public struct MessageContent: MessageComponent {
  
  public init(
    @MessageUtilityBuilder<MessageContentComponent>
    message: () -> [MessageContentComponent]
  ) {
    self.components = message()
  }
  
  var components: [MessageContentComponent]
  
  /// Combines all components into a final string to use in discord
  public var textualRepresentation: String {
    self.components.reduce("") { partialResult, component in
      return partialResult + component.textualRepresentation
    }
    .trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

public struct MessageEmbed: MessageComponent {
  public init() {}
}
