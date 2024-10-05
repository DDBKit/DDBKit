//
//  TestCommandCoreML.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 05/10/2024.
//

import DDBKit
import DDBKitUtilities

extension MyNewBot {
  var coremlCommands: Group {
    Group {
      Command("textanalysis") { int, cmd, reqs in
        try? await bot.createInteractionResponse(to: int, type: .deferredChannelMessageWithSource(isEphemeral: true))
        // bundle loading wont work
        guard let model = try? _1984_Big_Brother_2.init(contentsOf: .init(fileURLWithPath: "/Users/llsc12/Documents/GitHub/DDBKit/Example/Sources/1984 Big Brother 2.mlmodelc")) else {
          try? await bot.updateOriginalInteractionResponse(of: int) {
            Message { Text("Couldn't setup model") }
          }
          return
        }
        let str = try! cmd.requireOption(named: "text").requireString()
        do {
          let out = try model.prediction(text: str)
          try? await bot.updateOriginalInteractionResponse(of: int) {
            Message {
              MessageEmbed {
                Title(out.label)
                Description(str)
              }
            }
          }
          return
        } catch {
          try? await bot.updateOriginalInteractionResponse(of: int) {
            Message { Text("\(error.localizedDescription)") }
          }
          return
        }
      }
      .description("Analyse text for rude language with my CoreML model i trained over 5 days :sob:")
      .integrationType(.all, contexts: .all)
      .addingOptions {
        StringOption(name: "text", description: "Stinky :c")
          .required()
      }
    }
  }
}
