//
//  HelpGenerationExtension.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 06/05/2025.
//

@_spi(Extensions) import DDBKit
import Foundation

public actor HelpGeneration: DDBKitExtension {
	var instance: BotInstance!
	
	public init() {} 
	
	var info: [String: HelpGenerationExtendedInfo] = [:]
	var baseInfo: [String: Payloads.ApplicationCommandCreate] = [:]
	var listApplicationCommands: [ApplicationCommand] = []

	public func onBoot(_ instance: inout BotInstance) async throws {
		self.instance = instance
		for cmd in instance.commands {
			self.info[cmd.baseInfo.name] = HelpGenerationExtendedInfo()
			self.baseInfo[cmd.baseInfo.name] = cmd.baseInfo
		}
	}

	public func setFurtherReadings(
		for command: String,
		_ furtherReadings: String?
	) {
		// if this fails, the extension didn't get a chance to boot yet
		self.info[command]!.furtherReadings = furtherReadings
	}

	public func register() -> [any BotScene] {
		Command("help") { i in
			let message = await self.generatePagedHelpMessage(for: 0)
			try await i.respond { message }
		}
		.description("Lists all commands or get help about a specific command.")
		.integrationType(.all, contexts: .all)
		.component { i in
//			guard i.component?.custom_id.starts(with: "help-") == true,
//				let requestedPage = Int(i.component!.custom_id.dropFirst(5))
//			else { return }
//
//			let commands = await self.info.keys.chunks(ofCount: 10).map({$0}).chunks(ofCount: 3).map({$0})

		}
		
		ReadyEvent { ready in
			let cmdsdata = try? await self.instance.bot.client.listApplicationCommands()
			let cmds = try? cmdsdata?.decode()
			await self.setApplicationCommands(cmds ?? [])
		}
	}
	
	func setApplicationCommands(_ commands: [ApplicationCommand]) {
		self.listApplicationCommands = commands
	}

	func generatePagedHelpMessage(for page: Int) -> Message {
		let pages = self.info.keys.chunks(ofCount: 12).map({$0})
		let pageCount = pages.count
		let page = min(max(page, 0), pageCount - 1)
		
		return Message {
			MessageEmbed {
				Title("Help")
				Description(
					"List of available commands, pass a command name for more information."
				)
				
				for command in pages[page] {
					let baseInfo = self.baseInfo[command]!
					Field("</\(baseInfo.name):2046185065514240342>") {
						Text(baseInfo.description ?? "")
					}
					.inline()
				}
			}
			.setColor(.blue)
		}
	}
}

public struct HelpGenerationExtendedInfo: Sendable {
	public init(
		furtherReadings: String? = nil
	) {
		self.furtherReadings = furtherReadings
	}

	public var furtherReadings: String?
}
