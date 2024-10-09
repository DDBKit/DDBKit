//
//  RecursiveFocusFind.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//


extension BotInstance {
  static func FindFocusedOption(in options: [Interaction.ApplicationCommand.Option]?) -> Interaction.ApplicationCommand.Option? {
    // Guard against a nil options array
    guard let options = options else { return nil }
    
    // Loop through each option
    for option in options {
      // If the current option is focused, return it
      if option.focused == true {
        return option
      }
      
      // Recursively search through nested options
      if let nestedFocusedOption = FindFocusedOption(in: option.options) {
        return nestedFocusedOption
      }
    }
    
    // If no focused option is found, return nil
    return nil
  }
}
