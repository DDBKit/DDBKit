//
//  HandleCommand.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//

import DiscordBM

extension BotInstance {
  func handleCommand(_ i: Interaction, cmd: Interaction.ApplicationCommand) {
    // find all commands that fit criteria
    let cmds = commands.filter { command in
      command.baseInfo.name == cmd.name
    }
    cmds.forEach { command in
      Task(priority: .userInitiated) {
        do {
          try await command.trigger(i)
        } catch {
          self.handleInteractionError(error: error, interaction: i)
        }
      }
    }
  }
}
