//
//  TestCommands.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 04/10/2024.
//

import DDBKit
import Database
import DDBKitUtilities

extension MyNewBot {
  var Commands: Group {
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
        
        do {
          let _ = try await bot.client.createInteractionResponse(
            id: interaction.id,
            token: interaction.token,
            payload: .deferredChannelMessageWithSource()
          )
          let _ = try await bot.client
            .updateOriginalInteractionResponse(
              token: interaction.token,
              payload: .init(content: "\(stinky?.bool ?? false) meow")
            )
        } catch {
          // :3
        }
      }
      .description("Toggles a value stored for this current channel context")
      .guildScope(.global, ["1289521419801202728"])
      
      Command("embeds") { i, cmd, dbreq in
        try? await bot.createInteractionResponse(to: i, type: .deferredChannelMessageWithSource())
        let color: DiscordColor = {
          let colors: [DiscordColor] = [.red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink, .brown, .gray]
          return colors.randomElement() ?? .red
        }()
        print()
        try? await bot.updateOriginalInteractionResponse(of: i, msg: {
          Message {
            MessageEmbed {
              Title("gm")
              Description {
                Text("Did i mention how cool this shit is lmao")
              }
              Thumbnail(.exact(""))
            }
            .setColor(color)
          }
        })
      }
      .description("Test embeds")
      .integrationType(.all, contexts: .all)
      
      Command("increment") { interaction, cmd, db in
        let number = Double((try? cmd.requireOption(named: "number").value?.asString) ?? "0") ?? 0
        
        do {
          try await bot.createInteractionResponse(
            to: interaction,
            type: .deferredChannelMessageWithSource(isEphemeral: true)
          )
          
          try await bot.updateOriginalInteractionResponse(of: interaction) {
            Message {
              Text("\((number + 1).formatted(.number))")
            }
          }
        } catch {
          // :3
        }
      }
      .description("Adds 1 to an inputted value")
      .addingOptions {
        DoubleOption(name: "number", description: "value")
          .required()
          .autocompletions { gm in
            return [
              .init(name: "0", value: .double(0)),
              .init(name: "2", value: .double(2)),
              .init(name: "4", value: .double(4)),
              .init(name: "6", value: .double(6)),
            ]
          }
      }
    }
  }
}
