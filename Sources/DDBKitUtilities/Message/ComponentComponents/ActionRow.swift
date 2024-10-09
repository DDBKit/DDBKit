//
//  ActionRow.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//

import DiscordBM

public struct ActionRow: _ActionRowProtocol {
  var components: [MessageComponentsActionRowComponent]
  
  init(@MessageComponentsActionRowComponentBuilder _ components: () -> [MessageComponentsActionRowComponent]) {
    self.components = components()
  }
}

public protocol ActionRowProtocol { }

protocol _ActionRowProtocol: ActionRowProtocol { // swiftlint:disable:this type_name
  var components: [MessageComponentsActionRowComponent] { get }
}
