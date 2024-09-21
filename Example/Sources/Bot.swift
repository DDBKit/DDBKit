// hi mom
import DDBKit
import Foundation
import Database

@main
struct MyNewBot: DiscordBotApp {
  init() async {
    // Edit below as needed.
    bot = await BotGatewayManager( /// Need sharding? Use `ShardingGatewayManager`
      /// Do not store your token in your code in production.
      token: token,
      /// replace the above with your own token, but only for testing
      presence: .init(activities: [], status: .online, afk: false),
      intents: [.messageContent, .guildMessages]
    )
    // Will be useful
    cache = await .init(
      gatewayManager: bot,
      intents: .all, // it's better to minimise cached data to your needs
      requestAllMembers: .enabledWithPresences,
      messageCachingPolicy: .saveEditHistoryAndDeleted
    )
  }
  
  var body: [any BotScene] {
    ReadyEvent { ready in
      print("hi mom")
    }
    
    MessageCreateEvent { msg in
      print("[\(msg!.author!.username)] \(msg!.content)")
    }
    
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
    
    
    Command("increment") { interaction, cmd, db in
      let number = Double((try? cmd.requireOption(named: "number").value?.asString) ?? "0") ?? 0
      
      // an easier way of sending messages without directly using http client
      // is going to arrive soon dw :3
      do {
        let _ = try await bot.client.createInteractionResponse(
          id: interaction.id,
          token: interaction.token,
          payload: .deferredChannelMessageWithSource()
        )
        let _ = try await bot.client.updateOriginalInteractionResponse(
            token: interaction.token,
            payload: .init(content: "\(number + 1)")
          )
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
  
  var bot: Bot
  var cache: Cache
}
