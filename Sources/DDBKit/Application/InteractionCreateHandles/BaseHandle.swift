//
//  BaseHandle.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//

import DiscordBM

extension BotInstance {
  func handleInteractionCreate(_ event: Gateway.Event) {
    switch event.data {
    case .interactionCreate(let interaction):
      // get interaction types and respond as needed
      switch interaction.data {
        // MARK: - Handling START
        
        // slash command
      case .applicationCommand(let cmd):
        // trigger base commands named `cmd.name` (autocomplete handler)
        if interaction.type == .applicationCommandAutocomplete {
          self.handleCommandAutocomplete(interaction, cmd: cmd)
        }
        // trigger base commands named `cmd.name` (trigger)
        if interaction.type == .applicationCommand {
          self.handleCommand(interaction, cmd: cmd)
        }
        
        // message component (buttons, pickers etc.)
      case .messageComponent(let msgComp):
        // trigger component callback
        handleMsgComponent(interaction, component: msgComp)
        
        // modals (form sheets)
      case .modalSubmit(let modal):
        // handle submission
        handleModal(interaction, modal: modal)
        
        // MARK: Handling END -
        
      default: break
      }
    default: break
    }
  }
}
