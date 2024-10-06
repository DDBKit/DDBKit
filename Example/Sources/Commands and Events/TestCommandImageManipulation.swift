//
//  TestCommandImageManipulation.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 05/10/2024.
//

import DDBKit
import Database
import DDBKitUtilities
import Foundation
import SwiftUI

extension MyNewBot {
  var manipulation: DDBKit.Group {
    Group {
      Command("colonthree") { int, cmd, reqs in
        let firstTimestamp = Date.now
        // Defer the response
        try? await bot.createInteractionResponse(to: int, type: .deferredChannelMessageWithSource())
        
        // Helper function to get user ID from command options or interaction context
        func getUserId(from int: Interaction, cmd: DiscordModels.Interaction.ApplicationCommand) -> UserSnowflake? {
          if let optionId = try? (cmd.options ?? []).requireOption(named: "egg").requireString() {
            return .init(optionId)
          }
          return int.member?.user?.id ?? int.user?.id ?? int.message?.author?.id
        }
        
        // Helper function to get avatar based on user ID
        func fetchAvatar(for id: UserSnowflake, in guildId: GuildSnowflake?) async -> String? {
          if let guildId, await cache.guilds[guildId] != nil {
            let member = try? await bot.client.getGuildMember(guildId: guildId, userId: id).decode()
            return member?.avatar ?? member?.user?.avatar
          } else {
            let user = try? await bot.client.getUser(id: id).decode()
            return user?.avatar
          }
        }
        
        // Get the user ID and avatar
        guard let userId = getUserId(from: int, cmd: cmd),
              let avatar = await fetchAvatar(for: userId, in: int.guild_id)
        else {
          try? await bot.updateOriginalInteractionResponse(of: int) {
            Message { Text("Couldn't retrieve avatar") }
          }
          return
        }
        
        // Construct CDN URL for avatar
        let endpoint = CDNEndpoint.userAvatar(userId: userId, avatar: avatar).url.appending("?size=1024")
        
        // Fetch avatar image data
        guard let imgData = try? await bot.client.send(request: .init(to: .init(url: endpoint)), fallbackFileName: avatar).getFile(),
              let nsimg = NSImage(data: .init(buffer: imgData.data))
        else {
          try? await bot.updateOriginalInteractionResponse(of: int) {
            Message { Text("Couldn't get avatar") }
          }
          return
        }
        
        // Image manipulation view
        struct ImageView: View {
          var nsimg: NSImage
          var body: some View {
            Image(nsImage: nsimg)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .overlay(alignment: .center) {
                Text("meow :3")
                  .font(.system(size: 300, weight: .bold, design: .rounded))
                  .minimumScaleFactor(0.001)
                  .lineLimit(1)
                  .foregroundStyle(.white)
                  .shadow(color: .black, radius: 10)
                  .multilineTextAlignment(.center)
              }
          }
        }
        
        // Render image with overlay
        let img = await Task.detached { @MainActor in
          let renderer = ImageRenderer(content: ImageView(nsimg: nsimg))
          renderer.proposedSize = .init(width: nsimg.size.width, height: nsimg.size.height)
          return renderer.cgImage
        }.value
        
        
        
        // Convert to PNG and send as a response
        guard let img,
              let tiff = NSImage(cgImage: img, size: nsimg.size).tiffRepresentation,
              let imageRep = NSBitmapImageRep(data: tiff),
              let pngData = imageRep.representation(using: .png, properties: [:])
        else {
          try? await bot.updateOriginalInteractionResponse(of: int) {
            Message { Text("Couldn't make modifications") }
          }
          return
        }
        
        let formatted = (Double(Int(firstTimestamp.timeIntervalSinceNow * 1000).magnitude) / 1000).formatted()
        // Send the modified image back as an attachment
        try? await bot.updateOriginalInteractionResponse(of: int) {
          Message {
            MessageAttachment(pngData, filename: "modified.png")
              .usage(.embed) // dont add as attachment
            MessageEmbed {
              Title("Modified Image")
              Image(.attachment(name: "modified.png"))
              Footer("Took \(formatted)s")
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
      
      Command("captcha") { int, cmd, reqs in
        let firstTimestamp = Date.now
        try? await bot.createInteractionResponse(to: int, type: .deferredChannelMessageWithSource())
        // Image manipulation view

        struct ImageView: View {
          var body: some View {
            CaptchaView(captchaString: String((0...5).map { _ in
              "abcdefghijklmnopqrstuvwxyz1234567890"
                .uppercased()
                .randomElement()!
            }))
          }
        }
        
        // Render image with overlay
        let img = await Task.detached { @MainActor in
          let renderer = ImageRenderer(content: ImageView())
          renderer.proposedSize = .init(width: 300, height: 100)
          return renderer.cgImage
        }.value
        
        // Convert to PNG and send as a response
        guard let img,
              let tiff = NSImage(cgImage: img, size: .init(width: CGFloat(img.width), height: CGFloat(img.height))).tiffRepresentation,
              let imageRep = NSBitmapImageRep(data: tiff),
              let pngData = imageRep.representation(using: .png, properties: [:])
        else {
          try? await bot.updateOriginalInteractionResponse(of: int) {
            Message { Text("Couldn't make img") }
          }
          return
        }
        
        let formatted = (Double(Int(firstTimestamp.timeIntervalSinceNow * 1000).magnitude) / 1000).formatted()
        // Send the modified image back as an attachment
        try? await bot.updateOriginalInteractionResponse(of: int) {
          Message {
            MessageAttachment(pngData, filename: "modified.png")
              .usage(.embed) // dont add as attachment
            MessageEmbed {
              Title("Modified Image")
              Image(.attachment(name: "modified.png"))
              Footer("Took \(formatted)s")
            }
            .setColor(.blue)
          }
        }
      }
      .integrationType(.all, contexts: .all)
      
      Command("tiramisu") { int, cmd, reqs in
        let firstTimestamp = Date.now
        try? await bot.createInteractionResponse(to: int, type: .deferredChannelMessageWithSource())
        // Image manipulation view

        struct ImageView: View {
          var body: some View {
            Text("brat")
                .font(.title)
                .foregroundColor(.black)
                .frame(width: 150, height: 150)
                .background(Color.green)
                .scaleEffect(x: 1.5, y: 1, anchor: .center)
          }
        }
        
        // Render image with overlay
        let img = await Task.detached { @MainActor in
          let renderer = ImageRenderer(content: ImageView())
          renderer.proposedSize = .init(width: 300, height: 100)
          return renderer.cgImage
        }.value
        
        // Convert to PNG and send as a response
        guard let img,
              let tiff = NSImage(cgImage: img, size: .init(width: CGFloat(img.width), height: CGFloat(img.height))).tiffRepresentation,
              let imageRep = NSBitmapImageRep(data: tiff),
              let pngData = imageRep.representation(using: .png, properties: [:])
        else {
          try? await bot.updateOriginalInteractionResponse(of: int) {
            Message { Text("Couldn't make img") }
          }
          return
        }
        
        let formatted = (Double(Int(firstTimestamp.timeIntervalSinceNow * 1000).magnitude) / 1000).formatted()
        // Send the modified image back as an attachment
        try? await bot.updateOriginalInteractionResponse(of: int) {
          Message {
            MessageAttachment(pngData, filename: "modified.png")
              .usage(.embed) // dont add as attachment
            MessageEmbed {
              Title("Modified Image")
              Image(.attachment(name: "modified.png"))
              Footer("Took \(formatted)s")
            }
            .setColor(.blue)
          }
        }
      }
      .integrationType(.all, contexts: .all)
      
    }
  }
}





struct CaptchaView: View {
  var captchaString = "wagwan"
  let swirlAmount: Float = Float(Double.nonZeroRandom(magnitude: 0.4, offset: 0.3))
  let fisheyeAmount: Float = Float(Double.nonZeroRandom(magnitude: 0.4, offset: 0.3))
  
  var body: some View {
    ZStack {
      Color.gray.opacity(0.1)
        .edgesIgnoringSafeArea(.all)
      
      RandomLinesView(lineCount: 20)
        .grayscale(1)
        .overlay {
          if let captchaImage = generateCaptchaImage(size: CGSize(width: 300, height: 100)) {
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
    swirlFilter.setValue(min(size.width, size.height), forKey: kCIInputRadiusKey) // Radius for swirl
    swirlFilter.setValue(swirlAmount, forKey: kCIInputAngleKey) // Angle for swirl
    swirlFilter.setValue(CIVector(x: textCIImage.extent.width / CGFloat.random(in: (1.5)...(2.5)), y: textCIImage.extent.height / CGFloat.random(in: (1.9)...(2.1))), forKey: kCIInputCenterKey) // Fix center for the effect
    
    // Apply the fisheye (bump) effect
    let fisheyeFilter = CIFilter(name: "CIBumpDistortion")!
    fisheyeFilter.setValue(swirlFilter.outputImage, forKey: kCIInputImageKey)
    fisheyeFilter.setValue(min(size.width, size.height), forKey: kCIInputRadiusKey) // Adjust radius for fisheye
    fisheyeFilter.setValue(fisheyeAmount, forKey: kCIInputScaleKey) // Adjust fisheye scale
    fisheyeFilter.setValue(CIVector(x: textCIImage.extent.width / CGFloat.random(in: (1.5)...(2.5)), y: textCIImage.extent.height / CGFloat.random(in: (1.9)...(2.1))), forKey: kCIInputCenterKey) // Center the effect accurately
    
    // Render the final image using Core Image
    if let outputImage = fisheyeFilter.outputImage,
       let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) {
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
      .foregroundColor: NSColor.white
    ]
    
    let attributedText = NSAttributedString(string: captchaString, attributes: textAttributes)
    
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
        
        context.stroke(path, with: .color(lineColor), lineWidth: CGFloat.random(in: 1...3))
        context.blendMode = .difference
      }
    }
  }
}

extension Double {
  static func nonZeroRandom(magnitude: Double, offset: Double = 0.1) -> Double {
    var value = Double.random(in: (offset)...(magnitude + offset))
    if Bool.random() { value.negate() }
    return value
  }
}
