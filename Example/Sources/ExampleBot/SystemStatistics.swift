//
//  SystemStatistics.swift
//  rig
//
//  Created by Lakhan Lothiyi on 14/10/2024.
//

import DDBKit
import DDBKitUtilities
import Darwin
import Foundation
import MachO

let _processStartDate: Date = {
	return .now
}()

extension MyNewBot {
	var SystemStatistics: Group {
		Group {
			SubcommandBase("stats") {
				Subcommand("process") { i in
					let swiftVer = SystemMetrics.swiftVersion()
					guard let metrics = SystemMetrics.getProcessMetrics() else { return }
					let startDate = _processStartDate
					let bot = await cache.storage.botUser!
					let avatar =
						bot.avatar == nil
						? CDNEndpoint.defaultUserAvatar(discriminator: "0")
						: CDNEndpoint.userAvatar(userId: bot.id, avatar: bot.avatar!)
					try? await i.respond {
						Message {
							MessageEmbed {
								Title("\(bot.username) Stats")
								Field(
									"Bot Started",
									Text(
										DiscordUtils.timestamp(
											date: startDate,
											style: .relativeTime
										)
									)
								)
								.inline()
								Field("CPU Usage", Text(metrics.cpuUsage.formatted(.percent)))
									.inline()
								Field(
									"Memory Usage",
									Text(
										metrics.residentMemoryBytes.formatted(
											.byteCount(style: .memory)
										)
									)
								)
								.inline()
								Field("Swift Version", Text(swiftVer))
									.inline()

								Thumbnail(.exact(avatar.url))
							}
							.setTimestamp()
							.setColor(.red)
						}
					}
				}
				.description("Get information about the bot process.")

				Subcommand("speedtest") { i in
					try? await i.respond(with: .deferredChannelMessageWithSource())
					try? await i.editResponse {
						Message {
							MessageEmbed {
								Title("Speedtest")
								Description("--ms | **-- ➲ --**")

								Field("Download") {
									Text("<a:loading:1295877525154566156>")
								}
								Field("Upload") {
									Text("<a:loading:1295877525154566156>")
								}

								Footer(
									"Powered by Speedtest, speedtest-cli tends to be inaccurate",
									icon: .exact(
										"https://b.cdnst.net/images/favicons/favicon-180.png"
									)
								)
							}
							.setColor(.red)
						}
					}
					do {
						try await Speedtest.speedtest { dl in
							try? await i.editResponse {
								Message {
									MessageEmbed {
										Title("Speedtest")
										Description(
											"\(dl.ping.formatted(.number.precision(.fractionLength(2))))ms | **\(dl.client.isp) ➲ \(dl.server.sponsor)**"
										)

										Field("Download") {
											Text {
												Text(
													(dl.download / 1e+6).formatted(
														.number.precision(.fractionLength(2))
													)
												)
												.bold()
												Text(" mbps")
											}
										}
										Field("Upload") {
											Text("<a:loading:1295877525154566156>")
										}

										Footer(
											"Powered by Speedtest, speedtest-cli tends to be inaccurate",
											icon: .exact(
												"https://b.cdnst.net/images/favicons/favicon-180.png"
											)
										)
									}
									.setColor(.red)
								}
							}
						} upload: { ul in
							try? await i.editResponse {
								Message {
									MessageEmbed {
										Title("Speedtest")
										Description(
											"\(ul.ping.formatted(.number.precision(.fractionLength(2))))ms | **\(ul.client.isp) ➲ \(ul.server.sponsor)**"
										)

										Field("Download") {
											Text {
												Text(
													(ul.download / 1e+6).formatted(
														.number.precision(.fractionLength(2))
													)
												)
												.bold()
												Text(" mbps")
											}
										}
										Field("Download") {
											Text {
												Text(
													(ul.upload / 1e+6).formatted(
														.number.precision(.fractionLength(2))
													)
												)
												.bold()
												Text(" mbps")
											}
										}

										Footer(
											"Powered by Speedtest, speedtest-cli tends to be inaccurate",
											icon: .exact(
												"https://b.cdnst.net/images/favicons/favicon-180.png"
											)
										)
									}
									.setColor(.red)
								}
							}
						}
					} catch {
						try? await i.editResponse {
							Message {
								MessageEmbed {
									Title("Speedtest")
									switch error as? Speedtest.Error {
									case .notInstalled:
										Description(
											"<a:despair:1295897627505987634> Speedtest is not installed on this system."
										)
									case .speedtestError(let error):
										Description(
											"<a:despair:1295897627505987634> An error occurred whilst attempting the speedtest.\n\n\(error)"
										)

									default:
										Description(
											"<a:despair:1295897627505987634> An unknown error occurred whilst attempting the speedtest.\n\n\(error)"
										)
									}

									Footer(
										"Powered by Speedtest, speedtest-cli tends to be inaccurate",
										icon: .exact(
											"https://b.cdnst.net/images/favicons/favicon-180.png"
										)
									)
								}
							}
						}
					}
				}
				.description("Get information about the host internet speeds.")
			}
			.integrationType(.all, contexts: .all)
		}
	}
}
