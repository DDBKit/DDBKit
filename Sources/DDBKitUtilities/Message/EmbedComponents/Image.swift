//
//  Image.swift
//
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import DiscordBM

public struct Image: MessageEmbedComponent {
  var url: Embed.DynamicURL
  public init(_ url: Embed.DynamicURL) {
    self.url = url
  }
}
