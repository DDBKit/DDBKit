//
//  Footer.swift
//
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import DiscordBM

public struct Footer: MessageEmbedComponent {
  var text: String
  var url: Embed.DynamicURL?
  public init(_ text: String, icon: Embed.DynamicURL?) {
    self.text = text
    self.url = icon
  }
}
