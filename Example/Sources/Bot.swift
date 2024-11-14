// hi mom
import DDBKit
@_spi(Extensions) import DDBKitFoundation
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
    struct GuildConfTemplate: ConfigurationTemplate {
      @Config(
        name: "Prefix",
        description: "The prefix for the bot when using message commands.",
        initialValue: "!"
      ) var prefix: String
    }
    let confExtension = Configurator()
    RegisterExtension(confExtension)
    
    AssignGlobalCatch { error, interaction in
      try await interaction.respond() {
        Message {
          MessageEmbed {
            Title("Your interaction ran into a problem")
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
    
//    Commands
//    #if !os(Linux)
//    manipulation
//    coremlCommands
//    #endif
    
    Command("failable") { i in
      struct Egg: Decodable {
        var gm: String
      }
      let data = "{}".data(using: .utf8)!
      _ = try JSONDecoder().decode(Egg.self, from: data)
      
    }
    .integrationType(.all, contexts: .all)
    .furtherReading {
      Text("This command will always fail, im not sure why you")
      Text("Decided to run it, but it will always fail. I'm gonna")
      Text("give you up, let you down, run around and desert you.")
    }
    
    Command("ping") { interaction in
      try await interaction.respond(with: "Pong!")
      
    }
    .description("Ping the bot.")
    
    SubcommandBase("sub") {
      Subcommand("wagwan") { int in
        print(try int.options!.requireOption(named: "wagwan"))
        try await int.respond(with: "wagwan")
      }
      .addingOptions {
        StringOption(name: "wagwan", description: "wagwan")
      }
      
      Subcommand("gn") { int in
        print(try int.options!.requireOption(named: "a"))
        try await int.respond(with: "wagwan")
      }
      .addingOptions {
        StringOption(name: "a", description: "b")
      }
    }
  }
  
  var bot: Bot
  var cache: Cache
}

extension String: @retroactive LocalizedError { }
