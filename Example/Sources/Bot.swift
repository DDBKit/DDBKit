// hi mom
import DDBKit

@main
struct ExampleBot: DiscordBotApp {
  init() async {
    let http = HTTPClient()
    self.bot = await .init(
      eventLoopGroup: http.eventLoopGroup,
      httpClient: http,
      token: "redacted",
      intents: [.messageContent, .guildMessages]
    )
  }
  
  var bot: Bot
  
  var body: [any BotScene] {
    Event(on: .ready) { _ in
      print("we game")
    }
  }
}
