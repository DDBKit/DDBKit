//
//  Commands.swift
//  ExampleBot
//
//  Created by Lakhan Lothiyi on 07/11/2024.
//

import DDBKit
import DDBKitUtilities
import Database
import Foundation

#if os(macOS)
  import Calculate
  @preconcurrency import Dictionary
  import SoulverCore

  private let dicts = DictionaryProvider.Dictionaries.filter { $0.isAvailable }
#endif

extension MyNewBot {
  var Commands: DDBKit.Group {
    Group {
      Command("neofetch") { int in
        try await int.respond(with: .deferredChannelMessageWithSource())

        let nf = Process()
        let pipe = Pipe()
        nf.standardOutput = pipe
        if FileManager.default.fileExists(atPath: "/usr/local/bin/neofetch") {
          nf.executableURL = .init(fileURLWithPath: "/usr/local/bin/neofetch")
        } else if FileManager.default.fileExists(
          atPath: "/opt/homebrew/bin/neofetch"
        ) {
          nf.executableURL = .init(
            fileURLWithPath: "/opt/homebrew/bin/neofetch"
          )
        } else {
          nf.executableURL = .init(fileURLWithPath: "/usr/bin/neofetch")
        }
        try nf.run()
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

        try await int.editResponse {
          Message {
            Codeblock(output, lang: "ansi")
          }
        }
      }
      .guildScope(.global)
      .integrationType(.all, contexts: .all)

      #if os(macOS)
        SubcommandBase("dict") {
          Subcommand("apple") { i in
            //          let dict = try! cmd.requireOption(named: "dictionary").requireString()
            let dict = "Apple"
            let q = try (i.options ?? []).requireOption(named: "query")
              .requireString()
            let dictionary = dicts.first(where: { $0.shortName == dict })!
            let results = dictionary.search(q: q) ?? []
            guard
              let result = results.first
            else {
              throw "Failed to find a result, did you mean any of \(results)?"
            }

            try await i.respond(
              with: String((result.data(.text) ?? "idk bro").prefix(2000))
            )
          }
          .addingOptions {
            StringOption(name: "query", description: "Search query.")
              .required()
              .autocompletions { txt in
                let current = txt?.asString ?? ""
                let dictionary = dicts.first(where: { $0.shortName == "Apple" })
                let results = (dictionary?.search(q: current) ?? []).compactMap(
                  \.headword
                )
                let values =
                  results
                  .sorted(by: { lhs, rhs in
                    return lhs.lowercased().starts(with: current.lowercased())
                  })
                return
                  values
                  .prefix(25)
                  .map { .string($0) }
              }
          }

          Subcommand("search") { i in
            let dict = try i.options?.requireOption(named: "dictionary")
              .requireString()
            let q = try (i.options ?? []).requireOption(named: "query")
              .requireString()

            guard
              let dictionary = dicts.first(where: { $0.shortName == dict })
            else { throw "Failed to find dictionary" }
            let results = dictionary.search(q: q) ?? []
            guard
              let result = results.first
            else {
              throw "Failed to find a result, did you mean any of \(results)?"
            }

            try await i.respond(
              with: String((result.data(.text) ?? "idk bro").prefix(2000))
            )
          }
          .addingOptions {
            StringOption(
              name: "dictionary",
              description: "The dictionary to search."
            )
            .required()
            .choices {
              dicts
                .compactMap(\.shortName)
                .map { .string($0) }
            }
            StringOption(name: "query", description: "Search query.")
              .required()
          }
        }
        .integrationType(.all, contexts: .all)

        SubcommandBase("math") {
          Subcommand("help") { i in
            try await i.respond {
              Message {
                MessageEmbed {
                  Title("Calculate.framework")
                  Description {
                    Text(
                      "This command evaluates a mathematical expression in a string, using the Calculate.framework in macOS."
                    )
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
                    Text(
                      "The evaluation mode can be changed in runtime with the integer, double and decimal keyword, e.g."
                    )
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

          Subcommand("eval") { i in
            let expr = try (i.options ?? []).requireOption(named: "expr")
              .requireString()
            let first = Date.now
            let result = CalculateExpression(expr)
            let formatted =
              (Double(Int(first.timeIntervalSinceNow * 1000).magnitude) / 1000)
              .formatted()
            try await i.respond {
              Message {
                MessageEmbed {
                  Title("\(expr)")
                  Description("\(result.answer ?? "failure")")
                  Footer(
                    "\(result.succeed == 1 ? "" : "Evaluation failed • ")Took \(formatted)"
                  )
                }
                .setColor(result.succeed == 1 ? .blue : .red)
              }
            }
          }
          .addingOptions {
            StringOption(name: "expr", description: "Expression to evaluate.")
              .required()
          }
          .description(
            "Evaluates mathematical expressions with Calculate.framework."
          )

          Subcommand("soulver") { i in
            let expr = try (i.options ?? []).requireOption(named: "expr")
              .requireString()
            let first = Date.now
            let calculator = Calculator(customization: .standard)
            let result = calculator.calculate(expr)
            let formatted =
              (Double(Int(first.timeIntervalSinceNow * 1000).magnitude) / 1000)
              .formatted()
            try await i.respond {
              Message {
                MessageEmbed {
                  Title("\(expr)")
                  Description("\(result.stringValue)")
                  Footer(
                    "\(!result.isFailedResult ? "" : "Evaluation failed • ")Took \(formatted)"
                  )
                }
                .setColor(!result.isFailedResult ? .blue : .red)
              }
            }
          }
          .addingOptions {
            StringOption(name: "expr", description: "Expression to evaluate.")
              .required()
          }
          .description(
            "Evaluates mathematical expressions with SoulverCore.xcframework."
          )
        }
        .integrationType(.all, contexts: .all)
      #endif

    }
  }
}
