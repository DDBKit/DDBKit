//
//  BotCommandComponent.swift
//  
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation
import RegexBuilder
import DiscordBM

public struct Command: BotScene {
  // basic required data
  var name: String
  var description: String?
  
  // we let the user define action, but we control the before and after actions.
  // we internally execute proxyAction which executes before, user-def and after actions.
  var action: (Interaction) async -> Void
  func proxyAction(_ i: Interaction) async {
    await preAction(i)
    await action(i)
    await postAction(i)
  }
  
  // external options
  var options: [Option]
  // extra internal options
  
  public init(_ commandName: String, action: @escaping (Interaction) async -> Void) {
    guard (1...32).contains(commandName.count) else { preconditionFailure("[\(commandName)] Command name must be 1-32 characters") }
    let name = commandName.trimmingCharacters(in: .whitespacesAndNewlines)
    guard name.wholeMatch(of: nameRegex) != nil else { preconditionFailure("[\(commandName)] Command name contains invalid characters")}
    
    self.name = commandName
    self.action = action
    self.options = []
  }
  
  func preAction(_ interaction: Interaction) async {
    // do things like sending defer, processing, idk
  }
  func postAction(_ interaction: Interaction) async {
    // idk maybe register something internally, just here for completeness
  }
}

fileprivate var nameRegex = Regex {
  ZeroOrMore {
    CharacterClass(
      .anyOf("-"),
      ("A"..."Z"),
      ("a"..."z"),
      .whitespace
    )
  }
}
.anchorsMatchLineEndings()
