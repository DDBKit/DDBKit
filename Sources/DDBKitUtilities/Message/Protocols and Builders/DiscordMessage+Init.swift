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
    @GenericBuilder<MessageComponent>
    components: () -> GenericTuple<MessageComponent>
  ) {
    let components = components().values
    self.content = (components.last(where: {$0 is MessageContent}) as? MessageContent) ?? .init(message: { })
    self.embeds = components.filter { $0 is MessageEmbed } as? [MessageEmbed] ?? []
    self.attachments = components.filter { $0 is MessageAttachment } as? [MessageAttachment] ?? []
    self.components = (components.last(where: {$0 is MessageComponents}) as? MessageComponents) ?? .init()
    self.stickers = components.filter { $0 is MessageSticker } as? [MessageSticker] ?? []
    self.poll = (components.last(where: {$0 is MessagePoll}) as? MessagePoll)
  }
  
  /// Initializes a message's content directly
  /// - Parameter message: Message content components
  public init(
    @MessageContentBuilder
    message: () -> [MessageContentComponent]
  ) {
    self.content = .init(message: message)
    self.embeds = []
    self.attachments = []
    self.components = .init()
    self.stickers = []
  }
}
