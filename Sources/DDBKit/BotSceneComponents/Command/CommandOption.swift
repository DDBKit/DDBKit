//
//  CommandOption.swift
//  
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation

extension Command {
  // this represents a discord option
  struct Option {
    let name: String
    let description: String
    let isRequired: Bool
    let kind: OptionKind
    
    
    
    enum OptionKind {
    }
  }
  
  public mutating func addingOptions(
    name: String,
    description: String
    
  ) {
    
  }
}
