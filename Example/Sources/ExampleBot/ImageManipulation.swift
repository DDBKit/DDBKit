//
//  ImageView.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 26/04/2025.
//

#if !os(Linux)
import ColorCube
#endif
import DDBKit
import DDBKitUtilities
import Database
import Foundation


#if !os(Linux)
var cc = CCColorCube()
	@preconcurrency import SwiftUI

	extension MyNewBot {
		var Manipulation: DDBKit.Group {
			.init {
				Command("colonthree") { int in
					// Defer the response
					try await int.respond(with: .deferredChannelMessageWithSource())

					func getUserId(
						from int: InteractionExtras,
					) -> UserSnowflake? {
						if let optionId = try? int.options?.requireOption(
							named: "egg"
						).requireString() {
							return .init(optionId)
						}
						return MiscUtils.getUserID(from: int)
					}
					func fetchAvatar(for id: UserSnowflake, in guildId: GuildSnowflake?)
						async throws -> String?
					{
						if let guildId, await cache.guilds[guildId] != nil {
							let member = try await bot.client.getGuildMember(
								guildId: guildId,
								userId: id
							).decode()
							return member.avatar ?? member.user?.avatar
						} else {
							let user = try await bot.client.getUser(id: id).decode()
							return user.avatar
						}
					}
					guard let userId = getUserId(from: int),
						let avatar = try await fetchAvatar(
							for: userId,
							in: int.interaction.guild_id
						)
					else {
						try await int.editResponse {
							Message { Text("Couldn't retrieve avatar") }
						}
						return
					}
					let endpoint = CDNEndpoint.userAvatar(userId: userId, avatar: avatar)
						.url.appending("?size=4096")
					guard
						let imgData = try? await bot.client.send(
							request: .init(to: .init(url: endpoint)),
							fallbackFileName: avatar
						).getFile(),
						let nsimg = NSImage(data: .init(buffer: imgData.data))
					else {
						throw "Failed to retrieve avatar from CDN"
					}

					// Image manipulation view
					struct ImageView: View {
						var img: NSImage
						var body: some View {
							Image(nsImage: img)
								.resizable()
								.aspectRatio(contentMode: .fill)
								.overlay(alignment: .center) {
									Text("meow :3")
										.font(.system(size: 600, weight: .bold, design: .rounded))
										.minimumScaleFactor(0.001)
										.lineLimit(1)
										.foregroundStyle(.white)
										.shadow(color: .black, radius: 10)
										.multilineTextAlignment(.center)
								}
								.frame(width: 1024, height: 1024)
						}
					}

					let firstTimestamp = Date.now

					// Render image with overlay
					let img = await Task.detached { @MainActor in
						let view = ImageView(img: nsimg)
						let renderer = ImageRenderer(content: view)
						renderer.proposedSize = .init(width: 1024, height: 1024)
						return renderer.cgImage
					}.value

					let formatted =
						(Double(Int(firstTimestamp.timeIntervalSinceNow * 1000).magnitude)
						/ 1000).formatted()

					// Convert to PNG and send as a response
					guard let img,
						let tiff = NSImage(cgImage: img, size: nsimg.size)
							.tiffRepresentation,
						let imageRep = NSBitmapImageRep(data: tiff),
						let pngData = imageRep.representation(using: .png, properties: [:])
					else {
						throw "Failed to convert modified image cgimage to png."
					}

					// Send the modified image back as an attachment
					try await int.editResponse {
						Message {
							MessageAttachment(pngData, filename: "modified.png")
								.usage(.embed)  // dont add as attachment
							MessageEmbed {
								Title("Modified Image")
								Image(.attachment(name: "modified.png"))
								Footer("Took \(formatted)s to render")
							}
							.setColor(.blue)
						}
					}
				}
				.description("Test image manipulation")
				.addingOptions {
					UserOption(name: "egg", description: "We will add :3 on top of them.")
				}
				.integrationType(.all, contexts: .all)

				Command("captcha") { int in
					let firstTimestamp = Date.now
					try await int.respond(with: .deferredChannelMessageWithSource())
					// Image manipulation view

					struct ImageView: View {
						var captcha: String
						var body: some View {
							CaptchaView(captchaString: captcha)
						}
					}
					let captcha = String(
						(0...5).map { _ in
							"abcdefghijklmnopqrstuvwxyz1234567890"
								.uppercased()
								.randomElement()!
						}
					)

					// Render image with overlay
					let img = await Task.detached { @MainActor in
						let renderer = ImageRenderer(content: ImageView(captcha: captcha))
						renderer.proposedSize = .init(width: 900, height: 300)
						renderer.scale = 2
						return renderer.cgImage
					}.value

					// Convert to PNG and send as a response
					guard let img,
						let tiff = NSImage(
							cgImage: img,
							size: .init(
								width: CGFloat(img.width),
								height: CGFloat(img.height)
							)
						).tiffRepresentation,
						let imageRep = NSBitmapImageRep(data: tiff),
						let pngData = imageRep.representation(using: .png, properties: [:])
					else {
						try? await int.editResponse {
							Message { Text("Couldn't make img") }
						}
						return
					}

					let formatted =
						(Double(Int(firstTimestamp.timeIntervalSinceNow * 1000).magnitude)
						/ 1000).formatted()
					// Send the modified image back as an attachment
					try await int.editResponse {
						Message {
							MessageAttachment(pngData, filename: "modified.png")
								.usage(.embed)  // dont add as attachment
							MessageEmbed {
								Title("Modified Image")
								Image(.attachment(name: "modified.png"))
								Footer("Took \(formatted)s")
							}
							.setColor(.blue)
							MessageComponents {
								ActionRow {
									Button("Answer")
										.id("captcha-\(captcha)")
								}
							}
						}
					}
				}
				.integrationType(.all, contexts: .all)
				.modal { int in
					guard
						int.modal!.custom_id.starts(with: "captcha-"),
						let captchaSplit = int.modal!.custom_id.components(
							separatedBy: "captcha-"
						)
						.last
					else { return }

					let input =
						(try? int.modal!.components.requireComponent(
							customId: "captcha-field"
						)
						.requireTextInput().value) ?? ""
					if input == captchaSplit {
						try? await int.respond {
							Message {
								Text("Congrats u can read :3")
							}
							.flags([.ephemeral])
						}
					} else {
						try? await int.respond {
							Message {
								Text("Captcha invalid, please try again.")
							}
							.flags([.ephemeral])
						}
					}
				}
				.component { int in
					guard
						int.component!.custom_id.starts(with: "captcha-"),
						let captchaSplit = int.component!.custom_id.components(
							separatedBy: "captcha-"
						)
						.last
					else { return }

					try? await int.respond {
						Modal("CAPTCHA") {
							TextField("Enter Captcha Code")
								.length(6...6)
								.placeholder("ABC123")
								.id("captcha-field")
						}
						.id("captcha-\(captchaSplit)")
					}
				}

				Command("profilecolor") { int in
					// Defer the response
					try await int.respond(with: .deferredChannelMessageWithSource())

					// the calls to get guild member wont work if the bot isnt in the guild.
					func getUserId(
						from int: InteractionExtras,
					) -> UserSnowflake? {
						if let optionId = try? int.options?.requireOption(
							named: "user"
						).requireString() {
							return .init(optionId)
						}
						return MiscUtils.getUserID(from: int)
					}
					func fetchAvatar(for id: UserSnowflake, in guildId: GuildSnowflake?)
						async throws -> String?
					{
						if let guildId, await self.cache.guilds[guildId] != nil { // ensure bot is in guild before attempting
							let member = try? await bot.client.getGuildMember(
								guildId: guildId,
								userId: id
							).decode()
							if let av = member?.avatar ?? member?.user?.avatar {
								return av
							} else {
								let av = try await fetchAvatar(for: id, in: nil)
								return av
							}
						} else {
							let user = try await bot.client.getUser(id: id).decode()
							return user.avatar
						}
					}
					guard let userId = getUserId(from: int),
						let avatar = try await fetchAvatar(
							for: userId,
							in: int.interaction.guild_id
						)
					else {
						try await int.editResponse {
							Message { Text("Couldn't retrieve avatar") }
						}
						return
					}
					let endpoint = CDNEndpoint.userAvatar(userId: userId, avatar: avatar)
						.url.appending("?size=4096")
					guard
						let imgData = try? await bot.client.send(
							request: .init(to: .init(url: endpoint)),
							fallbackFileName: avatar
						).getFile(),
						let nsimg = NSImage(data: .init(buffer: imgData.data))
					else {
						throw "Failed to retrieve avatar from CDN"
					}

					let firstTimestamp = Date.now

					guard let pngData = nsimg.pngData else {
						throw "Failed to convert image to png."
					}

					let colors =
						cc.extractColors(
							from: nsimg,
							flags: [CCFlags.onlyDistinctColors],
						) ?? []

					let colorsProminent =
						cc.extractColors(
							from: nsimg,
							flags: [
								CCFlags.onlyDistinctColors, CCFlags.orderByBrightness,
								CCFlags.avoidWhite, .avoidBlack,
							],
							count: 1
						) ?? []

					guard !colors.isEmpty, let color = colorsProminent.first else {
						throw "Failed to get color from image."
					}

					let rgb: (r: Int, g: Int, b: Int) = (
						Int(color.rgb.r),
						Int(color.rgb.g),
						Int(color.rgb.b)  // still in range of 0 to 255
					)

					let img = await Task.detached { @MainActor in
						let view = ColorGrid(colors: colors)
						let renderer = ImageRenderer(content: view)
						renderer.proposedSize = .init(width: 1024, height: 1024)
						return renderer.cgImage
					}.value
					guard let img else { throw "Failed to create color image." }
					let colornsimg = NSImage(
						cgImage: img,
						size: .init(width: 1024, height: 1024)
					)
					guard let colorpng = colornsimg.pngData else {
						throw "Failed to convert color image to png."
					}

					let formatted =
						(Double(Int(firstTimestamp.timeIntervalSinceNow * 1000).magnitude)
						/ 1000).formatted()

					try await int.editResponse {
						Message {
							MessageAttachment(pngData, filename: "img.png")
								.usage(.embed)
							MessageAttachment(colorpng, filename: "color.png")
								.usage(.embed)

							MessageEmbed {
								Title("Profile Color")
								Description {
									UnorderedList {
										for color in colors {
											Text(color.hex)
										}
									}
								}
								Thumbnail(.attachment(name: "color.png"))
								Image(.attachment(name: "img.png"))
								Footer("Took \(formatted)s to analyse and render")
							}
							.setColor(.init(red: rgb.r, green: rgb.g, blue: rgb.b) ?? .gray)
						}
					}
				}
				.description("Get profile color of a user")
				.addingOptions {
					UserOption(name: "user", description: "Profile to look at")
				}
				.integrationType(.all, contexts: .all)
			}
		}
	}

	struct ColorGrid: View {
		let colors: [NSColor]
		var body: some View {
			// sqrt the number of colors to get the number of rows and columns, overestimate and never underestimate
			let rows = Int(ceil(sqrt(Double(colors.count))))
			let columns = Int(ceil(Double(colors.count) / Double(rows)))

			let colorGrid = colors.chunks(ofCount: columns)

			VStack(spacing: 0) {
				ForEach(colorGrid, id: \.self) { row in
					HStack(spacing: 0) {
						ForEach(row, id: \.self) { color in
							Color(color)
								.overlay {
									Text(color.hex)
										.aspectRatio(1, contentMode: .fit)
										.minimumScaleFactor(0.001)
										.foregroundColor(.white)
										.padding(5)
										.font(.system(size: 256))
										.fontDesign(.rounded)
										.shadow(radius: 5)
								}
						}
					}
				}
			}
		}
	}

	struct CaptchaView: View {
		var captchaString = "wagwan"
		let swirlAmount: Float = Float(
			Double.nonZeroRandom(magnitude: 0.4, offset: 0.3)
		)
		let fisheyeAmount: Float = Float(
			Double.nonZeroRandom(magnitude: 0.4, offset: 0.3)
		)

		var body: some View {
			ZStack {
				Color.gray.opacity(0.1)
					.edgesIgnoringSafeArea(.all)

				RandomLinesView(lineCount: 20)
					.grayscale(1)
					.overlay {
						if let captchaImage = generateCaptchaImage(
							size: CGSize(width: 300, height: 100)
						) {
							Image(nsImage: captchaImage)
								.resizable()
								.scaledToFit()
								.blendMode(.difference)
						}
					}
			}
			.frame(width: 300, height: 100)
			.cornerRadius(10)
			.shadow(radius: 5)
		}

		// Function to generate CAPTCHA image with text and effects
		func generateCaptchaImage(size: CGSize) -> NSImage? {
			// Step 1: Render the text as an NSImage
			let textImage = renderTextAsImage(size: size)

			// Step 2: Apply Core Image effects (swirl and fisheye)
			let textCIImage = CIImage(data: textImage.tiffRepresentation!)!
			let ciContext = CIContext()

			// Apply the swirl effect using CIFilter(name:)
			let swirlFilter = CIFilter(name: "CITwirlDistortion")!
			swirlFilter.setValue(textCIImage, forKey: kCIInputImageKey)
			swirlFilter.setDefaults()
			swirlFilter.setValue(
				min(size.width, size.height),
				forKey: kCIInputRadiusKey
			)  // Radius for swirl
			swirlFilter.setValue(swirlAmount, forKey: kCIInputAngleKey)  // Angle for swirl
			swirlFilter.setValue(
				CIVector(
					x: textCIImage.extent.width / CGFloat.random(in: (1.5)...(2.5)),
					y: textCIImage.extent.height / CGFloat.random(in: (1.9)...(2.1))
				),
				forKey: kCIInputCenterKey
			)  // Fix center for the effect

			// Apply the fisheye (bump) effect
			let fisheyeFilter = CIFilter(name: "CIBumpDistortion")!
			fisheyeFilter.setValue(swirlFilter.outputImage, forKey: kCIInputImageKey)
			fisheyeFilter.setValue(
				min(size.width, size.height),
				forKey: kCIInputRadiusKey
			)  // Adjust radius for fisheye
			fisheyeFilter.setValue(fisheyeAmount, forKey: kCIInputScaleKey)  // Adjust fisheye scale
			fisheyeFilter.setValue(
				CIVector(
					x: textCIImage.extent.width / CGFloat.random(in: (1.5)...(2.5)),
					y: textCIImage.extent.height / CGFloat.random(in: (1.9)...(2.1))
				),
				forKey: kCIInputCenterKey
			)  // Center the effect accurately

			// Render the final image using Core Image
			if let outputImage = fisheyeFilter.outputImage,
				let cgImage = ciContext.createCGImage(
					outputImage,
					from: outputImage.extent
				)
			{
				let nsImage = NSImage(cgImage: cgImage, size: size)
				return nsImage
			}

			return nil
		}

		// Function to render text as an NSImage using NSGraphicsContext
		func renderTextAsImage(size: CGSize) -> NSImage {
			let image = NSImage(size: size)
			image.lockFocus()

			// Set up text attributes
			let textAttributes: [NSAttributedString.Key: Any] = [
				.font: NSFont.monospacedSystemFont(ofSize: 40, weight: .bold),
				.foregroundColor: NSColor.white,
			]

			let attributedText = NSAttributedString(
				string: captchaString,
				attributes: textAttributes
			)

			// Position the text in the center
			let textSize = attributedText.size()
			let textRect = NSRect(
				x: (size.width - textSize.width) / 2,
				y: (size.height - textSize.height) / 2,
				width: textSize.width,
				height: textSize.height
			)

			// Draw the text
			attributedText.draw(in: textRect)

			image.unlockFocus()

			return image
		}
	}

	// SwiftUI view to draw random lines as part of the CAPTCHA
	struct RandomLinesView: View {
		let lineCount: Int

		var body: some View {
			Canvas { context, size in
				for _ in 0..<lineCount {
					var path = Path()

					let startX = CGFloat.random(in: 0...size.width)
					let startY = CGFloat.random(in: 0...size.height)
					let endX = CGFloat.random(in: 0...size.width)
					let endY = CGFloat.random(in: 0...size.height)

					path.move(to: CGPoint(x: startX, y: startY))
					path.addLine(to: CGPoint(x: endX, y: endY))

					let lineColor = Color(
						red: Double.random(in: 0...1),
						green: Double.random(in: 0...1),
						blue: Double.random(in: 0...1)
					)

					context.stroke(
						path,
						with: .color(lineColor),
						lineWidth: CGFloat.random(in: 1...3)
					)
					context.blendMode = .difference
				}
			}
		}
	}

	extension Double {
		static func nonZeroRandom(magnitude: Double, offset: Double = 0.1) -> Double
		{
			var value = Double.random(in: (offset)...(magnitude + offset))
			if Bool.random() { value.negate() }
			return value
		}
	}

	enum MiscUtils {}

	extension MiscUtils {
		static func getUserID(from int: InteractionExtras) -> UserSnowflake? {
			int.interaction.member?.user?.id ?? int.interaction.user?.id
				?? int.interaction.message?.author?.id
		}
	}

	extension NSBitmapImageRep {
		var png: Data? { representation(using: .png, properties: [:]) }
	}
	extension Data {
		var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
	}
	extension NSImage {
		var pngData: Data? { tiffRepresentation?.bitmap?.png }
	}
	extension NSColor {
		var hex: String {
			let rgb = usingColorSpace(.deviceRGB) ?? .black
			return String(
				format: "#%02X%02X%02X",
				Int(rgb.redComponent * 255),
				Int(rgb.greenComponent * 255),
				Int(rgb.blueComponent * 255)
			)
		}
		var rgb: (r: UInt8, g: UInt8, b: UInt8) {
			let rgb = usingColorSpace(.deviceRGB) ?? .black
			return (
				UInt8(rgb.redComponent * 255), UInt8(rgb.greenComponent * 255),
				UInt8(rgb.blueComponent * 255)
			)
		}
	}
#endif
