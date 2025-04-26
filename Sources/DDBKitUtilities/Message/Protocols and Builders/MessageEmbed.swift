//
//  MessageEmbed.swift
//
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import DiscordModels
import Foundation

public protocol MessageEmbedComponent {
}

/// Interface to building an embed and it's contents, and then
/// making an embed object.
public struct MessageEmbed: MessageComponent {
  public init(
    @GenericBuilder<MessageEmbedComponent> components: () -> GenericTuple<MessageEmbedComponent>
  ) {
    let components: [MessageEmbedComponent] = components().values
    // begin finding components and setting variables
    self.title = Self._findLast(type: Title.self, in: components)?.text
    self.description = Self._findLast(type: Description.self, in: components)?.text
    self.fields = (components.filter({ $0 is Field }) as? [Field])?.compactMap(\.field)
    self.image = {
      if let obj = Self._findLast(type: Image.self, in: components) {
        return .init(url: obj.url)
      }
      return nil
    }()
    self.thumbnail = {
      if let obj = Self._findLast(type: Thumbnail.self, in: components) {
        return .init(url: obj.url)
      }
      return nil
    }()
    self.video = {
      if let obj = Self._findLast(type: Video.self, in: components) {
        return .init(url: obj.url)
      }
      return nil
    }()
    self.footer = {
      if let obj = Self._findLast(type: Footer.self, in: components) {
        return .init(text: obj.text, icon_url: obj.url)
      }
      return nil
    }()
  }

  static func _findLast<T: MessageEmbedComponent>(
    type: T.Type, in components: [MessageEmbedComponent]
  ) -> T? {
    (components.last(where: { $0 is T }) as? T)
  }

  var title: String?  // component
  var kind: Embed.Kind?
  var description: String?  // component
  var url: String?
  var timestamp: Date?
  var color: DiscordColor?
  var footer: Embed.Footer?  // component
  var image: Embed.Media?  // component
  var thumbnail: Embed.Media?  // component
  var video: Embed.Media?  // component
  var provider: Embed.Provider?
  var author: Embed.Author?
  var fields: [Embed.Field]?  // component
}

extension MessageEmbed {
  var embed: Embed {
    return .init(
      title: self.title,
      type: self.kind,
      description: self.description,
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

extension MessageEmbed {
  public func setKind(_ kind: Embed.Kind) -> Self {
    var e = self
    e.kind = kind
    return e
  }
  public func setTimestamp(_ date: Date = .now) -> Self {
    var e = self
    e.timestamp = date
    return e
  }
  public func setColor(_ color: DiscordColor?) -> Self {
    var e = self
    e.color = color
    return e
  }
  public func setURL(_ url: String) -> Self {
    var e = self
    e.url = url
    return e
  }
  public func setProvider(_ name: String, url: String? = nil) -> Self {
    var e = self
    e.provider = .init(name: name, url: url)
    return e
  }
  public func setAuthor(_ name: String, url: String? = nil, icon_url: Embed.DynamicURL? = nil)
    -> Self
  {
    var e = self
    e.author = .init(name: name, url: url, icon_url: icon_url)
    return e
  }
}
