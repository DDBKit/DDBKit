//
//  InteractionExtras+Extensions.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 12/11/2024.
//

import DiscordBM

public extension InteractionExtras {
  var options: Interaction.ApplicationCommand? {
    return switch self.interaction.data {
    case .applicationCommand(let cmd): cmd
    default: nil
    }
  }
  
  var modal: Interaction.ModalSubmit? {
    return switch self.interaction.data {
    case .modalSubmit(let modal): modal
    default: nil
    }
  }
  
  var component: Interaction.MessageComponent? {
    return switch self.interaction.data {
    case .messageComponent(let comp): comp
    default: nil
    }
  }
}
