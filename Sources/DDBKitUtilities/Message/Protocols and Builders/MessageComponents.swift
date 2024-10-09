//
//  MessageComponents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//

import DiscordBM

@resultBuilder
public struct MessageComponentsActionRowComponentBuilder { // swiftlint:disable:this type_name
  public static func buildBlock(_ components: MessageComponentsActionRowComponent...) -> [MessageComponentsActionRowComponent] { components }
  public static func buildOptional(_ component: [any MessageComponentsActionRowComponent]?) -> any MessageComponentsActionRowComponent { FlattenedComponent(components: component ?? []) }
  public static func buildEither(first component: [any MessageComponentsActionRowComponent]) -> any MessageComponentsActionRowComponent { FlattenedComponent(components: component) }
  public static func buildEither(second component: [any MessageComponentsActionRowComponent]) -> any MessageComponentsActionRowComponent { FlattenedComponent(components: component) }
  
  /// Used internally to flatten conditional branches to text. reduces code complexity.
  public struct FlattenedComponent: MessageComponentsActionRowComponent {
    var component: Interaction.ActionRow.Component
    public init(components: [any MessageComponentsActionRowComponent]) {
      // this seems extremely dangerous but also it works??
      self.component = (components.first as? _MessageComponentsActionRowComponent)!.component
    }
  }
}

@resultBuilder
public struct MessageComponentsActionRowsBuilder {
  public static func buildBlock(_ components: ActionRowProtocol...) -> [ActionRowProtocol] { components }
  public static func buildOptional(_ component: [any ActionRowProtocol]?) -> any ActionRowProtocol { FlattenedComponent(components: component ?? []) }
  public static func buildEither(first component: [any ActionRowProtocol]) -> any ActionRowProtocol { FlattenedComponent(components: component) }
  public static func buildEither(second component: [any ActionRowProtocol]) -> any ActionRowProtocol { FlattenedComponent(components: component) }
  
  /// Used internally to flatten conditional branches to components. reduces code complexity.
  public struct FlattenedComponent: _ActionRowProtocol {
    var components: [any MessageComponentsActionRowComponent]
    init(components: [any ActionRowProtocol]) {
      self.components = (components as! [_ActionRowProtocol]).flatMap(\.components)
    }
  }
}

public struct MessageComponents: MessageComponent {
  
  public init(
    @MessageComponentsActionRowsBuilder
    rows: () -> [ActionRowProtocol]
  ) {
    self.rows = rows()
  }
  
  var rows: [ActionRowProtocol]
}

/// A struct that represents a component
public protocol MessageComponentsActionRowComponent { }
protocol _MessageComponentsActionRowComponent: MessageComponentsActionRowComponent { // swiftlint:disable:this type_name
  var component: Interaction.ActionRow.Component { get }
}
