//
//  MessageComponents.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//

import DiscordBM

public struct MessageComponents: MessageComponent {

  public init(
    @GenericBuilder<ActionRowProtocol>
    rows: () -> GenericTuple<ActionRowProtocol>
  ) {
    self.rows = rows().values
  }

  init() {
    self.rows = []
  }

  var rows: [ActionRowProtocol]
}

/// A struct that represents a component
public protocol MessageComponentsActionRowComponent: Sendable {}
protocol _MessageComponentsActionRowComponent: MessageComponentsActionRowComponent {  // swiftlint:disable:this type_name
  var component: Interaction.ActionRow.Component { get }
}
