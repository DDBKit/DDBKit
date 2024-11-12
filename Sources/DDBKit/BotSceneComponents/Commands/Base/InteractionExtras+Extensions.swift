//
//  InteractionExtras+Extensions.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 12/11/2024.
//

import DiscordBM

public extension InteractionExtras {
  var options: [Interaction.ApplicationCommand.Option]? {
    if let _options { return _options }
    return try? interaction.data?.requireApplicationCommand().options
  }
  
  var modal: Interaction.ModalSubmit? {
    try? interaction.data?.requireModalSubmit()
  }
  
  var component: Interaction.MessageComponent? {
    try? interaction.data?.requireMessageComponent()
  }
}
