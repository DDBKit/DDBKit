//
//  BotInstance.swift
//
//
//  Created by Lakhan Lothiyi on 26/03/2024.
//

import Foundation
import DiscordBM

// this internal class keeps track of declared events and handles actions.
// the entrypoint file contains a local declaration of it in the run() func.
public class BotInstance {
  /// avoid this, for testing.
  private init() {
    self._bot = nil;
    self.events = []
    self.commands = []
    self.id = try! .makeFake()
  }
  
  /// bot instance we keep to interact with if needed
  let _bot: GatewayManager?
  
  // declared events the user wants to receive
  let events: [any BaseEvent]
  let commands: [any BaseCommand]
  
  /// Unique stable identifier for the app
  public let id: ApplicationSnowflake
  
  init(bot: GatewayManager, events: [any BaseEvent], commands: [any BaseCommand]) {
    self._bot = bot
    self.events = events
    self.commands = commands
    
    // Hey! If you found your bot crashing here, your token is invalid or you forgor
    self.id = .init(.init(bot.identifyPayload.token.value.split(separator: ".", maxSplits: 1).first!))
  }
  
  func sendEvent(_ event: Gateway.Event) {
    // MARK: - Interactions (cmds etc.)
    if event.isOfType(.interactionCreate) {
      // get interaction
      switch event.data {
      case .interactionCreate(let interaction):
        // get interaction types and respond as needed
        switch interaction.data {
          
          // MARK: - Handling START
          
          // slash command
        case .applicationCommand(let cmd):
          // trigger base commands named `cmd.name` (autocomplete handler)
          if interaction.type == .applicationCommandAutocomplete {
            self.handleCommandAutocomplete(interaction, cmd: cmd)
          }
          // trigger base commands named `cmd.name` (trigger
          if interaction.type == .applicationCommand {
            self.handleCommand(interaction, cmd: cmd)
          }
          break
          
          // message component (buttons, pickers etc.)
        case .messageComponent(let msg):
          // trigger component callback
          break
          
          // modals (form sheets)
        case .modalSubmit(let modal):
          // handle submission
          break
          
          // MARK: Handling END -
          
        default: break
        }
      default: break
      }
    }
    
    // MARK: - Events (anything else)
    // now that we got an event, we should look for all events that match
    let matchedEvents = events.filter { $0.typeMatchesEvent(event) }
    
    // now we have all appropriate events. go through them all and trigger action
    matchedEvents.forEach { match in
      Task(priority: .userInitiated) { /// we use a task because we don't want many of the same event doing long tasks and blocking the event queue
        await match.handle(event.data) // FIXME: how do we get type safety based on chosen event
      }
    }
  }
  
//case applicationCommand(ApplicationCommand)
//case messageComponent(MessageComponent)
//case modalSubmit(ModalSubmit)
  
  func handleCommand(_ i: Interaction, cmd: Interaction.ApplicationCommand) {
    // find all commands that fit criteria
    let cmds = commands.filter { command in
      command.baseInfo.name == cmd.name
    }
    cmds.forEach { command in
      Task(priority: .userInitiated) {
        await command.trigger(i)
      }
    }
  }
  
  func handleCommandAutocomplete(_ i: Interaction, cmd: Interaction.ApplicationCommand) {
    // find all commands that fit criteria
    let cmds = commands.filter { command in
      command.baseInfo.name == cmd.name
    }
    cmds.forEach { command in
      guard
        let option = cmd.options?.first(where: {$0.focused == true}),
        let client = _bot?.client
      else { return }
      Task(priority: .userInitiated) {
        await command.autocompletion(i, cmd: cmd, opt: option, client: client)
      }
    }
  }
}
