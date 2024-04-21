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
      token: "MTE0NDY2OTI3MDg2MTY4ODkxMw.G84agA.646SbKYYM4oUxxdzGoUJSC4PZ8QD5NexD4fItc",
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
        
        if msg.content == "!gm" && msg.author?.username == "llsc12" {
          let a = Message {
            MessageContent {
              Heading("wagwan")
              Heading("true story", size: .medium)
              Text("rate my testing")
              UnorderedList {
                "hi"
                "im"
                "a"
                "list"
              }
            }
            
            MessageEmbed()
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
