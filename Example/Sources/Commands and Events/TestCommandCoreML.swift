//
//  TestCommandCoreML.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 05/10/2024.
//

import DDBKit
import CoreML

extension MyNewBot {
  var coremlCommands: Group {
    Group {
      Command("textanalysis") { int, cmd, reqs in
        
      }
      .description("Analyse text for rude language with my CoreML model i trained over 5 days :sob:")
    }
  }
}
