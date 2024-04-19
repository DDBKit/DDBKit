# DDBKit
## What is it?
DDBKit stands for Declarative Discord Bot Kit, name proposed by [Tobias](https://github.com/tobiasdickinson). DDBKit is designed to abstract away the complexities of Discord’s API into something that feels right at home. Similar to SwiftUI, DDBKit lets you declare commands and add modifiers to create functionality in your bot. It’s kinda like [Commando](https://github.com/discordjs/commando). DDBKit relies on [DiscordBM](https://github.com/DiscordBM/DiscordBM) under the hood.

## Getting started
Begin by making a new project directory with
```sh
mkdir MyNewBot && cd MyNewBot
```
Then make a new executable package in the directory with
```sh
swift package init --type executable
```
Open `Package.swift` in your preferred editor, and copy this configuration.
```swift

let package = Package(
  name: "MyNewBot",
  dependencies: [
    .package(url: "https://github.com/llsc12/DDBKit", from: “0.1.0”),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .executableTarget(
      name: "MyNewBot",
      dependencies: [
        "DDBKit"
      ]
    ),
  ]
)
```

You’ve now configured the package to use DDBKit! Next, rename the file at `./Sources/main.swift` to anything that isn’t `main.swift`, such as `Bot.swift`.
<details>
<summary>Why do this?</summary>
Having a file named <code>main.swift</code> makes it the entrypoint, and code is executed at the top level. DDBKit uses a protocol that declares it’s own entrypoint, you’ll declare a struct conforming to the protocol and you’ll prefix the struct with <code>@main</code>. This does also mean that you can only run a single bot per executable.
</details>

You can now replace any existing code in your Swift file with
```swift
import DDBKit

@main
struct MyNewBot: DiscordBotApp {
  init() async {
    let httpClient = HTTPClient()
    // Edit this as needed.
    bot = await BotGatewayManager(
      eventLoopGroup: httpClient.eventLoopGroup,
      httpClient: httpClient,
      token: "Token Here", // Do not store your token in your code in production.
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
      }
    }
  }

  var bot: Bot
}
```
Congratulations! You’ve connected to Discord as your bot and reacted to an event!
> [!NOTE]
> You cannot use logic in the `body` property; The property is only read once on startup.
