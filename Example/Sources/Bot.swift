// hi mom
import DDBKit
import DDBKitUtilities
import Foundation
import Database

import DDBKitFoundation

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
    ReadyEvent { _ in print("hi mom") }
    
    Commands
    Events
    manipulation
    coremlCommands
    
    SubcommandBase("test") {
      Subcommand("modal") { int, cmd, req in
        let modal =
        Modal("hiii") {
          TextField("hru")
            .style(.short)
        }
        .id("gm")
        do {
          try await bot.createInteractionResponse(to: int) {
            modal
          }
        } catch {
          print(error)
        }
      }
    }
    .integrationType(.all, contexts: .all)
    .modal(on: "gm") { int, modal, req in
      // ...
      try? await bot.createInteractionResponse(to: int) {
        Message {
          Text(String(reflecting: modal))
        }
//        .flags([.ephemeral])
      }
    }
    
  }
  
  var bot: Bot
  var cache: Cache
}
