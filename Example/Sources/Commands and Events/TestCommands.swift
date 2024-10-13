//
//  TestCommands.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 04/10/2024.
//

import DDBKit
import Database
import DDBKitUtilities
import Foundation

extension MyNewBot {
  var Commands: DDBKit.Group {
    Group {
      Command("dbtest") { interaction, cmd, db in
        // model that defines the structure of data we want to store
        struct Stinky: DatabaseModel {
          var bool: Bool
        }
        
        // create the request for our type, bound to the channel where cmd was invoked
        let req = try! db.channel(ofType: Stinky.self)
        
        let stinky = // returned struct from transaction
        // perform the transaction
        await Database.shared.transaction(req) { stinky in
          // we edit our data in this callback
          var stinky = stinky ?? .init(bool: true)
          stinky.bool.toggle()
          // return our edited data to save
          return stinky
        }
        
        try? await bot.createInteractionResponse(to: interaction) {
          Message {
            Text("\(stinky?.bool ?? false)")
          }
        }
      }
      .description("Toggles a value stored for this current channel context")
      
      Command("embeds") { i, cmd, dbreq in
        let randomcolor: DiscordColor = {
          let colors: [DiscordColor] = [.red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink, .brown, .gray]
          return colors.randomElement() ?? .red
        }()
        try? await bot.createInteractionResponse(to: i) {
          Message {
            MessageEmbed {
              Title("gm")
              Description {
                Text("Did i mention how cool this shit is lmao")
              }
            }
            .setColor(randomcolor)
          }
        }
      }
      .description("Test embeds")
      .integrationType(.all, contexts: .all)
      
      Command("meow") { i, cmd, dbreq in
        try? await bot.createInteractionResponse(to: i) {
          Message {
            Text("meow")
          }
        }
      }
      .description("says meow")
      .integrationType(.all, contexts: .all)
      
      Command("increment") { interaction, cmd, db in
        let number = Double((try? cmd.requireOption(named: "number").value?.asString) ?? "0") ?? 0
        try? await bot.createInteractionResponse(to: interaction, {
          Message {
            Text("\((number + 1).formatted(.number))")
          }
        })
      }
      .description("Adds 1 to an inputted value")
      .integrationType(.all, contexts: .all)
      .addingOptions {
        DoubleOption(name: "number", description: "value")
          .required()
          .autocompletions { gm in
            let number = Double((gm.asString)) ?? 0
            return [
              .string("\(number + 1)"),
              .string("\(number + 2)"),
              .string("\(number + 3)"),
              .string("\(number + 4)"),
              .string("\(number + 5)"),
              .string("\(number + 6)")
            ]
          }
      }
      
      Command("neofetch") { int,_,_ in
        try? await bot.createInteractionResponse(to: int, type: .deferredChannelMessageWithSource())
        
        let nf = Process()
        let pipe = Pipe()
        nf.standardOutput = pipe
        nf.executableURL = .init(fileURLWithPath: "/usr/local/bin/neofetch")
        try? nf.run()
        nf.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = (String(data: data, encoding: .utf8) ?? "")
          .replacingOccurrences(of: "[?25l", with: "")
          .replacingOccurrences(of: "[?7l", with: "")
          .replacingOccurrences(of: "[17A", with: "")
          .replacingOccurrences(of: "[9999999D", with: "")
          .replacingOccurrences(of: "[33C", with: "")
          .replacingOccurrences(of: "[m", with: "")
          .replacingOccurrences(of: "[?25h", with: "")
          .replacingOccurrences(of: "[?7h", with: "")
          .trimmingCharacters(in: .whitespacesAndNewlines)
        
        try? await bot.updateOriginalInteractionResponse(of: int) {
          Message {
            Codeblock(output, lang: "ansi")
          }
        }
      }
      .guildScope(.global)
      .integrationType(.all, contexts: .all)
      
      Command("beofetch") { int, _, _ in
        try? await bot.createInteractionResponse(to: int, {
          Modal("gm") {
            TextField("gm")
              .required(false)
          }
          .id("neofetch")
        })
      }
      .integrationType(.all, contexts: .all)
      .modal(on: "neofetch") { int, _, _ in
        try? await bot.createInteractionResponse(to: int, type: .deferredChannelMessageWithSource())
        
        let nf = Process()
        let pipe = Pipe()
        nf.standardOutput = pipe
        nf.executableURL = .init(fileURLWithPath: "/usr/local/bin/neofetch")
        try? nf.run()
        nf.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = (String(data: data, encoding: .utf8) ?? "")
          .replacingOccurrences(of: "[?25l", with: "")
          .replacingOccurrences(of: "[?7l", with: "")
          .replacingOccurrences(of: "[17A", with: "")
          .replacingOccurrences(of: "[9999999D", with: "")
          .replacingOccurrences(of: "[33C", with: "")
          .replacingOccurrences(of: "[m", with: "")
          .replacingOccurrences(of: "[?25h", with: "")
          .replacingOccurrences(of: "[?7h", with: "")
          .trimmingCharacters(in: .whitespacesAndNewlines)
        
        try? await bot.updateOriginalInteractionResponse(of: int) {
          Message {
            Codeblock(output, lang: "ansi")
          }
        }
      }
    }
  }
}
