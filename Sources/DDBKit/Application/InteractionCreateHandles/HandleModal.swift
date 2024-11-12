//
//  HandleModal.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//

import DiscordBM

extension BotInstance {
  func handleModal(_ i: Interaction, modal: Interaction.ModalSubmit) {
    let callbacks = (self.modalReceives[""] ?? []) + (self.modalReceives[modal.custom_id] ?? [])
    callbacks.forEach { callback in
      Task(priority: .userInitiated) {
        let e = InteractionExtras(self, i)
        do {
          try await callback(e)
        } catch {
          self.handleInteractionError(error: error, interaction: i)
        }
      }
    }
  }
}
