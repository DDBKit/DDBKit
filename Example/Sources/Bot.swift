// hi mom
import DDBKit

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
    ReadyEvent { ready in
      print("hi mom")
    }
    
    MessageCreateEvent { msg in
      if let msg {
        print("[\(msg.author?.username ?? "unknown")] \(msg.content)")
        
        if msg.content == "!gm" && ["llsc12", "tobias112", "james.op", "deckyboiii"].contains(msg.author?.username) {
          let a = Message {
            MessageContent {
              Text("Italic: ")
              Text("true story", fmt: .italic)
              NewLine()
              Text("Bold: ")
              Text("true story", fmt: .bold)
              NewLine()
              Text("true story", fmt: .strikethrough)
              NewLine()
              Text("Bold + Strikethrough: ")
              Text("true story", fmt: [.bold, .strikethrough])
            }
          }
          
          let _ = try? await bot.client.createMessage(
            channelId: msg.channel_id,
            payload: .init(
              content: a.content.textualRepresentation,
              embeds: [Embed(title: "gm")]
            )
          )
        }
      }
    }
  }

  var bot: Bot
}
