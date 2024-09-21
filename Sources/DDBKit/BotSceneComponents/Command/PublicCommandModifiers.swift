//
//  PublicCommandModifiers.swift
//  
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation
import DiscordModels

// misc modifiers go here

public extension Command {
  /// add these at some point
  //  self.baseInfo = .init(
  //    name_localizations: <#T##[DiscordLocale : String]?#>,
  //    description_localizations: <#T##[DiscordLocale : String]?#>,
  //  )
  
  /// Add options to the command.
  /// - Parameter options: StringOption IntOption BoolOption UserOption ChannelOption RoleOption MentionableOption DoubleOption AttachmentOption
  func addingOptions(
    @CommandOptionsBuilder
    options: () -> [Option]
  ) -> Self {
    var copy = self
    copy.options.append(contentsOf: options())
    copy.baseInfo.options = copy.baseInfo.options ?? []
    copy.baseInfo.options = copy.options.map(\.optionData)
    return copy
  }
  
  /// The command's description.
  func description(_ description: String) -> Self {
    var copy = self
    copy.baseInfo.description = description
    return copy
  }
  
  /// Whether or not this command can be used in DMs.
  func isUsableInDMS(_ usable: Bool) -> Self {
    var copy = self
    copy.baseInfo.dm_permission = usable
    return copy
  }
  
  func defaultPermissionRequirement(_ perms: [Permission]) -> Self {
    var copy = self
    copy.baseInfo.default_member_permissions = Optional(perms).map({ .init($0) }) // Optional is part of a weird type requirement
    return copy
  }
  
  /// Whether or not this command is NSFW.
  func isNSFW(_ nsfw: Bool) -> Self {
    var copy = self
    copy.baseInfo.nsfw = nsfw
    return copy
  }
}
