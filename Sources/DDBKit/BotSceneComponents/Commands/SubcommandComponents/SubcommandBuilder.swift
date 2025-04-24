//
//  SubcommandBuilder.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 07/10/2024.
//

import DiscordBM

// to easily list the two types
public protocol SubcommandBaseTypes: Sendable {
}

protocol BaseInfoType: SubcommandBaseTypes {
  var baseInfo: ApplicationCommand.Option { get }
}

@resultBuilder
public struct SubcommandBaseBuilder {
  public static func buildBlock(_ components: SubcommandBaseTypes...) -> [SubcommandBaseTypes] { components }
}
@resultBuilder
public struct SubcommandBuilder {
  public static func buildBlock(_ components: Subcommand...) -> [Subcommand] { components }
}
