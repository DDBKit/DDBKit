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
  platforms: [
    .macOS(.v13)
  ],
  dependencies: [
    .package(url: "https://github.com/llsc12/DDBKit", from: "0.1.0"),
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
Having a file named <code>main.swift</code> makes it the entrypoint, and code is executed at the top level. DDBKit uses a protocol that declares it’s own entrypoint, you’ll declare a struct conforming to the protocol and you’ll prefix the struct with <code>@main</code>. This is the simplest setup for a discord bot with DDBKit. You can run multiple clients by executing the `run() async throws` method on each `DiscordBotApp` struct you've defined.
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
      if let msg {
        print("[\(msg.author?.username ?? "unknown")] \(msg.content)")
      }
    }
  }

  var bot: Bot
  var cache: Cache
}
```
Congratulations! You’ve connected to Discord as your bot and reacted to an event!
> [!WARNING]
> You cannot use logic in the `body` property; The property is only read once on startup.
> Commands are registered in batch globally or per groups with guild targets (TBA)

<details>
<summary>Need another entrypoint? (iOS etc.)</summary>
You can run a DiscordBotApp instance with the `run() async throws` function available on your Bot struct. You can use this to run multiple clients at once if needed.
</details>

You've now got a solid place to start with your bot. Check out the [wiki](https://github.com/llsc12/DDBKit/wiki) for more information!

# Contributing
Feel free to work on providing more abstractions and adding general utilities.
My code isn't exactly amazing so if you'd like to improve it for everyone else, be sure to make a PR!
I have a silly database thing going on. I think it might be useful but it also might be dumb. If someone rewrites it to use a real database behind the scenes whilst also providing more utilities, it would be much appreciated.

I only ask that contributions are somewhat commented in cases of dense code or wherever fit. 
Use `self` explicitly whenever it's used.
Someone should PR a linter :3

## Goals
- [ ] Using builders for composable objects (main bot logic, messages etc.)
- [ ] Abstraction over common objects (eg. extending objects like Interaction with useful methods)
- [ ] Swift Playgrounds book-based guide for younger demographics
- [ ] Swift playground app for bots developed on iPad with in-app console and runs in background
- [ ] Feature parity with Discord
- [ ] Make database good
- [ ] Add linter

# Sponsoring
If you really love this project, you should first support [DiscordBM's development](https://github.com/DiscordBM/DiscordBM) above all, considering it lies as the foundation of DDBKit.
Afterwards, feel free to sponsor the development of DDBKit and my other projects!
[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/llsc12)
