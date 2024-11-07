//
//  SubcommandGroup.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 23/10/2024.
//


import DiscordBM

/// Group subcommands under a label
public struct SubcommandGroup: BaseInfoType {
  var commands: [Subcommand] // this carries the instances so we keep trigger intact
  var baseInfo: ApplicationCommand.Option
    
  public init(_ name: String, @SubcommandBuilder _ tree: () -> [Subcommand]) {
    self.commands = []
    self.baseInfo = .init(
      type: .subCommandGroup,
      name: name,
      name_localizations: nil,
      description: "This subcommand group has no description.",
      description_localizations: nil,
      options: self.commands.map(\.baseInfo)
    )
    // modify names of objects so they show tree path in name for ease of access
    self.commands = tree()
  }
}
