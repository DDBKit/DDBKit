//
//  CommandOption.swift
//  
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation

public struct Option {
  let name: String
  let description: String
  let isRequired: Bool
  let kind: OptionKind
  
  public enum OptionKind {
    case gm
  }
  
  public init(name: String, description: String, isRequired: Bool, kind: OptionKind) {
    self.name = name
    self.description = description
    self.isRequired = isRequired
    self.kind = kind
  }
}

public extension Command {
  // this represents a discord option
  
  
  func addingOptions(
    @CommandOptionsBuilder
    options: () -> [Option]
  ) -> Self {
    var obj = self
    let options = options()
    obj.options.append(contentsOf: options)
    return obj
  }
}

@resultBuilder
public struct CommandOptionsBuilder {
  public static func buildBlock(_ components: Option...) -> [Option] {
    return components
  }
}
