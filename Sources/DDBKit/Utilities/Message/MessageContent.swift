//
//  MessageContent.swift
//  
//
//  Created by Lakhan Lothiyi on 19/04/2024.
//

import Foundation

public protocol MessageContentComponent {
  var textualRepresentation: String { get }
}

/// Interface to build up a message's content with result builders, and
/// then turning that representation into markdown for discord.
public struct MessageContent: MessageComponent {
  
  public init(
    @MessageContentBuilder
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
