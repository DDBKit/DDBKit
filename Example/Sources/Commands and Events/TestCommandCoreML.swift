//
//  TestCommandCoreML.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 05/10/2024.
//

import DDBKit
import DDBKitUtilities
#if !os(Linux)
extension MyNewBot {
  var coremlCommands: Group {
    Group {
      Command("textanalysis") { int, cmd, reqs in
        // get bool from ephemeral option
        let ephemeral = try! cmd.requireOption(named: "ephemeral").requireBool()
        // defer
        try await bot.createInteractionResponse(to: int, type: .deferredChannelMessageWithSource(isEphemeral: ephemeral))
        // bundle loading wont work here, load CoreML model with absolute url
        // for others using this example, this model is not publicly available its just
        // for testing :3
        let model = try _1984_Big_Brother_2.init(contentsOf:
            .init(fileURLWithPath: "/Users/llsc12/Documents/GitHub/DDBKit/Example/Sources/1984 Big Brother 2.mlmodelc")
        )
        // get string option
        let str = try! cmd.requireOption(named: "text").requireString()
        // run prediction
        let out = try model.prediction(text: str)
        // update response
        try await bot.updateOriginalInteractionResponse(of: int) {
          Message {
            MessageEmbed {
              Title(out.label)
              Description(str)
            }
            .setColor(.blue)
          }
        }
      }
      .description("Analyse text for rude language with my CoreML model i trained over 5 days :sob:")
      .integrationType(.all, contexts: .all)
      .addingOptions {
        StringOption(name: "text", description: "Stinky :c")
          .required()
        BoolOption(name: "ephemeral", description: "smelly :c")
          .required()
      }
    }
  }
}
#endif
