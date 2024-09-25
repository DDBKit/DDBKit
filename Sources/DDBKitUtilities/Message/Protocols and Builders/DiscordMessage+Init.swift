//
//  DiscordMessage+Init.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 25/09/2024.
//

extension Message {
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
  
  /// Initializes a message's content directly
  /// - Parameter message: Message content components
  public init(
    @MessageContentBuilder
    message: () -> [MessageContentComponent]
  ) {
    self.content = .init(message: message)
    self.embeds = []
  }
}
