// hi mom
import DDBKit
import DDBKitUtilities
import Foundation
import NIOCore

@main
struct MyNewBot: DiscordBotApp {
  init() async {
    // Edit below as needed.
    bot = await BotGatewayManager( /// Need sharding? Use `ShardingGatewayManager`
      /// Do not store your token in your code in production.
      token: token,
      /// replace the above with your own token, but only for testing
      presence: .init(activities: [.init(name: "meow", type: .custom, state: "meow :3")], status: .online, afk: false),
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
  
  func boot() async throws {
    // register stuff
//    RegisterExtension(<#any DDBKitExtension#>)
    AssignGlobalCatch { bot, error, i in
      try await bot.createInteractionResponse(to: i) {
        Message {
          MessageEmbed {
            Title("Your command ran into a problem")
            Description {
              Text(error.localizedDescription)
              Codeblock("\(error)", lang: "swift")
            }
          }
          .setColor(.red)
        }
      }
    }
  }
  
  var body: [any BotScene] {
    
    Commands
    #if !os(Linux)
    manipulation
    coremlCommands
    #endif
    
    Command("failable") { i, _, _ in
      struct Egg: Decodable {
        var gm: String
      }
      let data = "{}".data(using: .utf8)!
      _ = try JSONDecoder().decode(Egg.self, from: data)
    }
    .integrationType(.all, contexts: .all)
  }
  
  var bot: Bot
  var cache: Cache
}

extension String: @retroactive LocalizedError { }
