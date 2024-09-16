// hi mom
import DDBKit
import Foundation
import Database

@main
struct MyNewBot: DiscordBotApp {
  init() async {
    let httpClient = HTTPClient()
    // Edit this as needed.
    bot = await BotGatewayManager(
      eventLoopGroup: httpClient.eventLoopGroup,
      httpClient: httpClient,
      /// Do not store your token in your code in production.
      token: token,
      /// replace the above with your own token, but only for testing
      largeThreshold: 250,
      presence: .init(activities: [], status: .online, afk: false),
      intents: [.messageContent, .guildMessages]
    )
  }
  
  var body: [any BotScene] {
    Command("ping") { interaction in
      print("ping cmd ran")
    }
    .addingOptions {
      Option(
        name: <#T##String#>,
        description: <#T##String#>,
        isRequired: <#T##Bool#>,
        kind: <#T##Option.OptionKind#>
      )
    }
  }
  
  var bot: Bot
}
