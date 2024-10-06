//
//  MessageEmbed.swift
//
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import Foundation
import DiscordModels

public protocol MessageEmbedComponent {
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

/// Interface to building an embed and it's contents, and then
/// making an embed object.
public struct MessageEmbed: MessageComponent {
  public init(@MessageEmbedBuilder components: () -> [MessageEmbedComponent]) {
    // we make our array of all the built components
    let componentsArray = components()
    // this is an empty array of all the components we're about to flatten
    var components: [MessageEmbedComponent] = []
    // the r func and its call recursively expands any tuples
    func r(from c: [MessageEmbedComponent]) {
      for component in c {
        if let tuple = component as? MessageEmbedBuilder.EmbedTuple {
          r(from: tuple.contained)
        } else {
          components.append(component)
        }
      }
    }
    r(from: componentsArray)
    
    // begin finding components and setting variables
    self.title = Self._findLast(type: Title.self, in: components)?.text
    self.description = Self._findLast(type: Description.self, in: components)?.text
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
  
  static func _findLast<T: MessageEmbedComponent>(type: T.Type, in components: [MessageEmbedComponent]) -> T? {
    (components.last(where: {$0 is T}) as? T)
  }
  
  
  var title: String? // component
  var kind: Embed.Kind?
  var description: String? // component
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

public extension MessageEmbed {
  func setKind(_ kind: Embed.Kind) -> Self { var e = self; e.kind = kind; return e }
  func setTimestamp(_ date: Date = .now) -> Self { var e = self; e.timestamp = date; return e }
  func setColor(_ color: DiscordColor) -> Self { var e = self; e.color = color; return e }
  func setURL(_ url: String) -> Self { var e = self; e.url = url; return e }
  func setProvider(_ name: String, url: String? = nil) -> Self { var e = self; e.provider = .init(name: name, url: url); return e }
}
