//
//  ActionRow.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//

import DiscordBM

public struct ActionRow: _ActionRowProtocol {
  var components: [MessageComponentsActionRowComponent]

  public init(
    @GenericBuilder<MessageComponentsActionRowComponent> _ components: () -> GenericTuple<
      MessageComponentsActionRowComponent
    >
  ) {
    self.components = components().values
  }
}

public protocol ActionRowProtocol: Sendable {}

protocol _ActionRowProtocol: ActionRowProtocol {  // swiftlint:disable:this type_name
  var components: [MessageComponentsActionRowComponent] { get }
}
