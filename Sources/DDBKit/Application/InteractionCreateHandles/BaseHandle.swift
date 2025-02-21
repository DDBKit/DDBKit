//
//  BaseHandle.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//

import DiscordBM

extension BotInstance {
  func handleInteractionCreate(_ event: Gateway.Event) {
    guard case .interactionCreate(let interaction) = event.data else { return }
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
      self.handleMsgComponent(interaction, component: msgComp)
      
      // modals (form sheets)
    case .modalSubmit(let modal):
      // handle submission
      self.handleModal(interaction, modal: modal)
      
      // MARK: Handling END -
      
    default: break
    }
  }
  
  func handleInteractionError(error: Error, interaction: Interaction) {
    Task(priority: .userInitiated) {
      do {
        let e = InteractionExtras(self, interaction)
        if let globalErrorHandle {
          try await globalErrorHandle(error, e)
        } else {
          throw error
        }
      } catch let uncaughtError {
        GS.s.logger.error("\(uncaughtError)\n\n\(interaction)")
      }
    }
  }
}
