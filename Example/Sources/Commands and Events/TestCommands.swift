//
//  TestCommands.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 04/10/2024.
//

import DDBKit
import Database
import DDBKitUtilities
import Foundation
import Dictionary
import Calculate

fileprivate let dicts = DictionaryProvider.Dictionaries.filter { $0.isAvailable }

extension MyNewBot {
  var Commands: DDBKit.Group {
    Group {
      Command("neofetch") { int,_,_ in
        try? await bot.createInteractionResponse(to: int, type: .deferredChannelMessageWithSource())
        
        let nf = Process()
        let pipe = Pipe()
        nf.standardOutput = pipe
        nf.executableURL = .init(fileURLWithPath: "/usr/local/bin/neofetch")
        try? nf.run()
        nf.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = (String(data: data, encoding: .utf8) ?? "")
          .replacingOccurrences(of: "[?25l", with: "")
          .replacingOccurrences(of: "[?7l", with: "")
          .replacingOccurrences(of: "[17A", with: "")
          .replacingOccurrences(of: "[9999999D", with: "")
          .replacingOccurrences(of: "[33C", with: "")
          .replacingOccurrences(of: "[m", with: "")
          .replacingOccurrences(of: "[?25h", with: "")
          .replacingOccurrences(of: "[?7h", with: "")
          .trimmingCharacters(in: .whitespacesAndNewlines)
        
        try? await bot.updateOriginalInteractionResponse(of: int) {
          Message {
            Codeblock(output, lang: "ansi")
          }
        }
      }
      .guildScope(.global)
      .integrationType(.all, contexts: .all)
      
      Command("beofetch") { int, _, _ in
        try? await bot.createInteractionResponse(to: int, {
          Modal("gm") {
            TextField("gm")
              .required(false)
          }
          .id("neofetch")
        })
      }
      .integrationType(.all, contexts: .all)
      .modal(on: "neofetch") { int, _, _ in
        try? await bot.createInteractionResponse(to: int, type: .deferredChannelMessageWithSource())
        
        let nf = Process()
        let pipe = Pipe()
        nf.standardOutput = pipe
        nf.executableURL = .init(fileURLWithPath: "/usr/local/bin/neofetch")
        try? nf.run()
        nf.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = (String(data: data, encoding: .utf8) ?? "")
          .replacingOccurrences(of: "[?25l", with: "")
          .replacingOccurrences(of: "[?7l", with: "")
          .replacingOccurrences(of: "[17A", with: "")
          .replacingOccurrences(of: "[9999999D", with: "")
          .replacingOccurrences(of: "[33C", with: "")
          .replacingOccurrences(of: "[m", with: "")
          .replacingOccurrences(of: "[?25h", with: "")
          .replacingOccurrences(of: "[?7h", with: "")
          .trimmingCharacters(in: .whitespacesAndNewlines)
        
        try? await bot.updateOriginalInteractionResponse(of: int) {
          Message {
            Codeblock(output, lang: "ansi")
          }
        }
      }
      
      SubcommandBase("dict") {
        Subcommand("apple") { i, cmd, _ in
//          let dict = try! cmd.requireOption(named: "dictionary").requireString()
          let dict = "Apple"
          let q = try! cmd.requireOption(named: "query").requireString()
          let dictionary = dicts.first(where:{ $0.shortName == dict })!
          let results = dictionary.search(q: q) ?? []
          guard
            let result = results.first
          else { throw "Failed to find a result, did you mean any of \(results)?" }
          
          try await bot.createInteractionResponse(to: i, String((result.data(.text) ?? "idk bro").prefix(2000)))
        }
        .addingOptions {
          StringOption(name: "query", description: "Search query.")
            .required()
            .autocompletions { txt in
              let current = txt?.asString ?? ""
              let dictionary = dicts.first(where:{ $0.shortName == "Apple" })
              let results = (dictionary?.search(q: current) ?? []).compactMap(\.headword)
              let values = results
                .sorted(by: { lhs, rhs in
                  return lhs.lowercased().starts(with: current.lowercased()) 
                })
              return values
                .prefix(25)
                .map { .string($0) }
            }
        }
        
        Subcommand("search") { i, cmd, _ in
          let dict = try! cmd.requireOption(named: "dictionary").requireString()
          let q = try! cmd.requireOption(named: "query").requireString()
          
          guard
            let dictionary = dicts.first(where:{ $0.shortName == dict })
          else { throw "Failed to find dictionary" }
          let results = dictionary.search(q: q) ?? []
          guard
            let result = results.first
          else { throw "Failed to find a result, did you mean any of \(results)?" }
          
          try await bot.createInteractionResponse(to: i, String((result.data(.text) ?? "idk bro").prefix(2000)))
        }
        .addingOptions {
          StringOption(name: "dictionary", description: "The dictionary to search.")
            .required()
            .choices {
              dicts
                .compactMap(\.shortName)
                .map { .string($0) }
            }
          StringOption(name: "query", description: "Search query.")
            .required()
        }
        .catch { error, i in
          try await bot.createInteractionResponse(to: i, "\(error.localizedDescription)")
        }
      }
      .integrationType(.all, contexts: .all)
      
      SubcommandBase("math") {
        Subcommand("help") { i, _, _ in
          try? await bot.createInteractionResponse(to: i) {
            Message {
              MessageEmbed {
                Title("Calculate.framework")
                Description {
                  Text("This command evaluates a mathematical expression in a string, using the Calculate.framework in macOS.")
                  Heading("Recognised Expressions")
                    .medium()
                  Heading("Binary operators")
                    .small()
                  UnorderedList {
                    Text("and")
                    Text("or")
                    Text("nor")
                    Text("xor")
                    Text("+")
                    Text("-")
                    Text("*")
                    Text("/")
                    Text("<<")
                    Text(">>")
                  }
                  Heading("Constants")
                    .small()
                  UnorderedList {
                    Text("pi")
                  }
                  Heading("Unary functions")
                  UnorderedList {
                    Text("sqrt")
                    Text("cbrt")
                    Text("exp")
                    Text("ln")
                    Text("log")
                    Text("sin")
                    Text("cos")
                    Text("tan")
                    Text("asin")
                    Text("acos")
                    Text("atan")
                    Text("sind")
                    Text("cosd")
                    Text("tand")
                    Text("asind")
                    Text("acosd")
                    Text("atand")
                    Text("sinh")
                    Text("cosh")
                    Text("tanh")
                    Text("asinh")
                    Text("acosh")
                    Text("atanh")
                    Text("ceil")
                    Text("floor")
                    Text("fabs")
                    Text("rint")
                    Text("lgamma")
                    Text("erf")
                    Text("erfc")
                  }
                  Heading("Binary functions")
                    .small()
                  UnorderedList {
                    Text("pow")
                    Text("fmod")
                    Text("hypot")
                    Text("rem")
                  }
                  Heading("Miscellaneous")
                    .small()
                  UnorderedList {
                    Text("x! (factorial)")
                    Text("-x (unary minus)")
                  }
                  
                  Heading("Changing mode and precision")
                    .medium()
                  Text("The evaluation mode can be changed in runtime with the integer, double and decimal keyword, e.g.")
                  Text {
                    Text("`integer 8/3`")
                    Text(" (returns 2)")
                  }
                  Text {
                    Text("The precision can be changed in runtime with ")
                    Text("`precision=x`")
                    Text(", where 0 ≤ x ≤ 16.")
                  }
                }
              }
              .setURL("https://theapplewiki.com/wiki/Dev:Calculate.framework")
              .setColor(.blue)
              .setTimestamp()
            }
            .ephemeral()
          }
        }
        .description("Calculate.framework evaluator documentation.")
        
        Subcommand("eval") { i, cmd, _ in
          let expr = try! cmd.requireOption(named: "expr").requireString()
          let first = Date.now
          let result = CalculateExpression(expr)
          let formatted = (Double(Int(first.timeIntervalSinceNow * 1000).magnitude) / 1000).formatted()
          try? await bot.createInteractionResponse(to: i) {
            Message {
              MessageEmbed {
                Title("\(expr)")
                Description("\(result.answer ?? "failure")")
              }
              .setAuthor("\(result.succeed == 1 ? "" : "Evaluation failed • ")Took \(formatted)")
              .setColor(result.succeed == 1 ? .blue : .red)
            }
          }
        }
        .addingOptions {
          StringOption(name: "expr", description: "Expression to evaluate.")
            .required()
        }
        .description("Evaluates mathematical expressions with Calculate.framework.")
      }
      .integrationType(.all, contexts: .all)
    }
  }
}

fileprivate let fuse = Fuse()
fileprivate func fuseSearch(_ q: String, in list: [String]) async -> [Fuse.SearchResult] {
  await withCheckedContinuation { continuation in
    fuse.search(q, in: list) { continuation.resume(returning: $0) }
  }
}
