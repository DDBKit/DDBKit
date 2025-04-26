// hi mom
import DDBKit
@_spi(Extensions) import DDBKitFoundation
import DDBKitUtilities
import Foundation

@main
struct MyNewBot: DiscordBotApp {
	init() async {
		// Edit below as needed.
		bot = await BotGatewayManager(
			/// Need sharding? Use `ShardingGatewayManager`
			/// Do not store your token in your code in production.
			token: token,
			/// replace the above with your own token, but only for testing
			intents: [.messageContent, .guildMessages]
		)
		// Will be useful
		cache = await .init(
			gatewayManager: bot,
			intents: .all,  // it's better to minimise cached data to your needs
			requestAllMembers: .enabledWithPresences,
			messageCachingPolicy: .saveEditHistoryAndDeleted
		)
	}

	func onBoot() async throws {
		// Register extensions
		RegisterExtension(BucketRatelimiting())

		AssignGlobalCatch { error, interaction in
			// handle errors thrown from commands etc
			try await interaction.respond {
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
		Command("ping") { interaction in
			try await interaction.respond {
				Message {
					Text("Pong!")
				}
				//				.ephemeral()
			}
		}
		.integrationType(.all, contexts: .all)
		.description("Ping the bot.")
		.ratelimited()

		Command("fail") { interaction in
			throw "test error"
		}
	}

	var bot: Bot
	var cache: Cache
}

extension String: @retroactive LocalizedError {}
