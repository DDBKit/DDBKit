//
//  MessagePoll.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 16/10/2024.
//

import DiscordBM

public struct MessagePoll: MessageComponent {
  var answers: [PollAnswer]
  var allowMultiselection: Bool = false
  var durationHours: Int
  var emoji: PollAnswer.Emoji?
  var question: String?
  var layout: Poll.LayoutKind = .default

  public init(
    _ question: String?, emoji: PollAnswer.Emoji? = .none, hours: Int,
    @GenericBuilder<PollAnswer> _ answers: () -> GenericTuple<PollAnswer>
  ) {
    self.answers = answers().values
    self.durationHours = hours
    self.emoji = emoji
    self.question = question

    precondition(hours >= 1, "Poll duration must be greater than 0")
    if question == nil {
      precondition(emoji != nil, "You need to provide either a question, emoji or both.")
    }
    if emoji == nil {
      precondition(question != nil, "You need to provide either a question, emoji or both.")
    }
  }
}

// technically a component of MessagePoll but why make a folder for one thing
public struct PollAnswer: Sendable {
  var answer: String?
  var emoji: Self.Emoji?
  var answerID: Int?
  public init(_ answer: String?, emoji: Self.Emoji?) {
    self.answer = answer
    self.emoji = emoji
    if answer == nil {
      precondition(emoji != nil, "You need to provide either an answer, emoji or both.")
    }
    if emoji == nil {
      precondition(answer != nil, "You need to provide either an answer, emoji or both.")
    }
  }

  public enum Emoji: Sendable {
    case name(String)
    case id(EmojiSnowflake)
  }

  var out: (Int?, Poll.Media) {
    switch emoji {
    case .none: (self.answerID, .init(text: self.answer!))
    case .some(let emoji):
      switch emoji {
      case .name(let name):
        if let answer {
          (self.answerID, .init(text: answer, emojiName: name))
        } else {
          (self.answerID, .init(emojiName: name))
        }
      case .id(let id):
        if let answer {
          (self.answerID, .init(text: answer, emojiId: id))
        } else {
          (self.answerID, .init(emojiId: id))
        }
      }
    }
  }

  /// Set an integer identifier for the poll answer to easily find it.
  /// - Parameter int: Identifier
  public func id(_ int: Int) -> Self {
    var copy = self
    copy.answerID = int
    return copy
  }
}

extension MessagePoll {
  /// Allow selection of multiple answers in a poll.
  /// - Parameter bool: Multiselect bool
  public func allowMultipleAnswers(_ bool: Bool = true) -> Self {
    var copy = self
    copy.allowMultiselection = true
    return copy
  }

  /// Change the layout of the poll.
  /// - Parameter kind: Poll layout kind
  public func layout(_ kind: Poll.LayoutKind) -> Self {
    var copy = self
    copy.layout = kind
    return copy
  }
}

extension MessagePoll {
  var poll: Payloads.CreatePollRequest {
    let q: Poll.Media = {
      return switch emoji {
      case .none: .init(text: self.question!)
      case .some(let emoji):
        switch emoji {
        case .name(let name):
          if let question {
            .init(text: question, emojiName: name)
          } else {
            .init(emojiName: name)
          }
        case .id(let id):
          if let question {
            .init(text: question, emojiId: id)
          } else {
            .init(emojiId: id)
          }
        }
      }
    }()
    return .init(
      question: q,
      answers: self.answers.map(\.out).map({ .init(answer_id: $0.0, poll_media: $0.1) }),
      duration: self.durationHours,
      allow_multiselect: self.allowMultiselection,
      layout_type: self.layout
    )
  }
}
