//
//  MessageContent.swift
//  
//
//  Created by Lakhan Lothiyi on 19/04/2024.
//

import Foundation

@resultBuilder
public struct MessageContentBuilder {
  public static func buildBlock(_ components: MessageContentComponent...) -> [MessageContentComponent] { components }
  public static func buildOptional(_ component: [any MessageContentComponent]?) -> any MessageContentComponent { FlattenedComponent(components: component ?? []) }
  public static func buildEither(first component: [any MessageContentComponent]) -> any MessageContentComponent { FlattenedComponent(components: component) }
  public static func buildEither(second component: [any MessageContentComponent]) -> any MessageContentComponent { FlattenedComponent(components: component) }
  
  /// Used internally to flatten conditional branches to text. reduces code complexity.
  public struct FlattenedComponent: MessageContentComponent {
    var components: [any MessageContentComponent]
    init(components: [any MessageContentComponent]) {
      self.components = components
    }
    
    public var textualRepresentation: String {
      self.components.reduce("") { partialResult, component in
        return partialResult + component.textualRepresentation
      }
    }
  }
}

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


extension String: MessageContentComponent {
  public var textualRepresentation: String {
    self
  }
}
