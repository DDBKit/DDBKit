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
          
          guard
            let dictionary = dicts.first(where:{ $0.shortName == dict }),
            let result = dictionary.search(q: q)?.first
          else { return }
          
          try? await bot.createInteractionResponse(to: i, result.data(.text) ?? "idk bro")
        }
        .addingOptions {
//          StringOption(name: "dictionary", description: "The dictionary to search.")
//            .required()
//            .autocompletions { txt in
//              let current = txt.asString
//              let dicts = dicts.compactMap(\.shortName)
//              let results = await fuseSearch(current, in: dicts)
//              let values = results
//                .map { dicts[$0.index] }
//              print(values)
//              return values
//                .prefix(25)
//                .map { .string($0) }
//            }
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
              print(current, values)
              return values
                .prefix(25)
                .map { .string($0) }
            }
        }
        
        Subcommand("search") { i, cmd, _ in
          let dict = try! cmd.requireOption(named: "dictionary").requireString()
//          let dict = "Apple"
          let q = try! cmd.requireOption(named: "query").requireString()
          
          guard
            let dictionary = dicts.first(where:{ $0.shortName == dict }),
            let result = dictionary.search(q: q)?.first
          else { return }
          
          try? await bot.createInteractionResponse(to: i, result.data(.text) ?? "idk bro")
        }
        .addingOptions {
          StringOption(name: "dictionary", description: "The dictionary to search.")
            .required()
            .autocompletions { txt in
              let current = txt?.asString ?? ""
              let dicts = dicts.compactMap(\.shortName)
              let results = await fuseSearch(current, in: dicts)
              let values = results
                .map { dicts[$0.index] }
              print(values)
              return values
                .prefix(25)
                .map { .string($0) }
            }
          StringOption(name: "query", description: "Search query.")
            .required()
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

func CalculatePerformExpression(_ expr: UnsafeMutablePointer<CChar>!, _ significantDigits: Int32, _ flags: Int32, _ answer: UnsafeMutablePointer<CChar>!) -> Int32 {
  let handle = dlopen("/System/Library/PrivateFrameworks/Calculate.framework/Versions/A/Calculate", RTLD_NOW)
  let sym = dlsym(handle, "CalculatePerformExpression")

  typealias CalculateExprCall = @convention(c) (UnsafeMutablePointer<CChar>?, Int32, Int32, UnsafeMutablePointer<CChar>?) -> Int32
  let f = unsafeBitCast(sym, to: CalculateExprCall.self)
  let result = f(expr, significantDigits, flags, answer)
  dlclose(handle)
  print(result)
  
  return result
}

public struct CalculateFlags: OptionSet {
  public let rawValue: Int32
  public static let unknown1: Self = .init(rawValue: 1 << 0)
  public static let treatInputAsIntegers: Self = .init(rawValue: 1 << 1)
  public static let moreAccurate: Self = .init(rawValue: 1 << 2)
  
  public init(rawValue: Int32) {
    self.rawValue = rawValue
  }
}

func CalculateExpression(_ expression: String, significantDigits: Int32 = 8, flags: CalculateFlags = []) -> (succeed: Int, answer: String?) {
  let exprLength = expression.utf8CString.count
  let expr = UnsafeMutablePointer<CChar>.allocate(capacity: exprLength)
  defer { expr.deallocate() }
  
  expression.utf8CString.withUnsafeBufferPointer { buffer in
    expr.initialize(from: buffer.baseAddress!, count: exprLength)
  }
  
  let answerLength = 2048
  let answer = UnsafeMutablePointer<CChar>.allocate(capacity: answerLength)
  defer { answer.deallocate() }
  
  let succeed = CalculatePerformExpression(expr, significantDigits, flags.rawValue, answer)

  let result = String(cString: answer)
  
  return (Int(succeed), result)
}
