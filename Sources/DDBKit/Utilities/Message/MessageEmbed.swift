//
//  MessageEmbed.swift
//
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import Foundation

public protocol MessageEmbedComponent {
}

/// Interface to building an embed and it's contents, and then
/// making an embed object.
public struct MessageEmbed: MessageComponent {
  public init(@MessageEmbedBuilder components: () -> [MessageEmbedComponent]) {
    let components = components()
    self.title = (components.last(where: {$0 is Title}) as? Title)?.text
  }
  
  
  var title: String? // component
  var kind: Embed.Kind?
  var description: Text? // component
  var url: String?
  var timestamp: Date?
  var color: DiscordColor?
  var footer: Embed.Footer? // component
  var image: Embed.Media? // component
  var thumbnail: Embed.Media? // component
  var video: Embed.Media? // component
  var provider: Embed.Provider?
  var author: Embed.Author?
  var fields: [Embed.Field]?
}

public extension MessageEmbed {
  func setKind(_ kind: Embed.Kind) -> Self { var e = self; e.kind = kind; return e }
  func setTimestamp(_ date: Date) -> Self { var e = self; e.timestamp = date; return e }
  func setColor(_ color: DiscordColor) -> Self { var e = self; e.color = color; return e }
  func setURL(_ url: String) -> Self { var e = self; e.url = url; return e }
  func setProvider(_ name: String, url: String? = nil) -> Self { var e = self; e.provider = .init(name: name, url: url); return e }
}

public extension MessageEmbed {
  var embed: Embed {
    return .init(
      title: self.title,
      type: self.kind,
      description: self.description?.textualRepresentation,
      url: self.url,
      timestamp: self.timestamp,
      color: self.color,
      footer: self.footer,
      image: self.image,
      thumbnail: self.thumbnail,
      video: self.video,
      provider: self.provider,
      author: self.author,
      fields: self.fields
    )
  }
}
