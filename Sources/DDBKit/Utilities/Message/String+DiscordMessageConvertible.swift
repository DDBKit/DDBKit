//
//  String+DiscordMessageConvertible.swift
//
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation

protocol DiscordMessageConvertible {
  var message: Message { get }
}

extension String: DiscordMessageConvertible {
  var message: Message {
    Message(self)
  }
}
