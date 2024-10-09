//
//  HandleCommandAutocomplete.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//

import DiscordBM

extension BotInstance {
  func handleCommandAutocomplete(_ i: Interaction, cmd: Interaction.ApplicationCommand) {
    // find all commands that fit criteria
    let cmds = commands.filter { command in
      command.baseInfo.name == cmd.name
    }
    cmds.forEach { command in
      guard
        let option = Self.FindFocusedOption(in: cmd.options),
        let client = _bot?.client
      else { return }
      Task(priority: .userInitiated) {
        await command.autocompletion(i, cmd: cmd, opt: option, client: client)
      }
    }
  }
}
