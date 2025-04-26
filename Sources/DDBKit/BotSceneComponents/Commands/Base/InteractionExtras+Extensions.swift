//
//  InteractionExtras+Extensions.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 12/11/2024.
//

import DiscordBM

extension InteractionExtras {
  public var resolvedCommand: Interaction.ApplicationCommand.ResolvedData? {
    if case .applicationCommand(let cmd) = self.interaction.data {
      return cmd.resolved
    }
    return nil
  }

  public var options: [Interaction.ApplicationCommand.Option]? {
    if let _options { return _options }  // override in case of subcommands
    return try? interaction.data?.requireApplicationCommand().options
  }

  public var modal: Interaction.ModalSubmit? {
    try? interaction.data?.requireModalSubmit()
  }

  public var component: Interaction.MessageComponent? {
    try? interaction.data?.requireMessageComponent()
  }

  public var attachments: [AttachmentSnowflake: DiscordChannel.Message.Attachment] {
    resolvedCommand?.attachments ?? [:]
  }
}
