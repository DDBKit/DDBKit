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
      guard let msg else { return }
      print("[\(msg.author?.username ?? "unknown")] \(msg.content)")
      
      if msg.content == "!gm" && ["llsc12", "tobias112", "james.op", "deckyboiii"].contains(msg.author?.username) {
        let a = Message {
          MessageContent {
            Heading {
              Text {
                Text("Welcome to ")
                Text("The Test")
                  .italic()
                Text("!")
              }
              .underlined()
            }
            Heading("We're testing the Message DSL")
              .medium()
            Text("Actually scratch that")
              .strikethrough()
            Link("https://llsc12.me")
              .disableLinking()
              .maskedWith {
                Text("check out this!")
                  .bold()
              }
            
            Blockquote {
              Heading {
                Text("Blockquote!")
                  .underlined()
              }
              .medium()
              
              Text("yep, we got em")
            }
            
            Code("wagwan")
            
            Codeblock("""
for i in 0...10 {
  print(i)
}
print("done!")
"""
            )
            .language("swift")
          }
        }
        
        let _ = try? await bot.client.createMessage(
          channelId: msg.channel_id,
          payload: .init(
            content: a.content.textualRepresentation
          )
        )
      }
    }
  }
  
  var bot: Bot
}
