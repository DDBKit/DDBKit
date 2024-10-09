//
//  Modal.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//

import DiscordBM

public struct Modal {
  public var modal: Payloads.InteractionResponse.Modal {
    let valid = _modal.validate()
    if !valid.isEmpty {
      preconditionFailure("[\(_modal.custom_id)] Failed validation\n\n\(valid)")
    }
    return _modal
  }
  var _modal: Payloads.InteractionResponse.Modal
  
  public init( _ title: String, @MessageComponentsActionRowComponentBuilder _ inputs: () -> [MessageComponentsActionRowComponent]) {
    let fields = inputs().map { $0 as! TextField } // we dont use compact map and optional casting to ensure good code
    let inputs = fields.map(\.object)
    self._modal = .init(custom_id: "", title: title, textInputs: inputs)
  }
}

public extension Modal {
  func id(_ id: String) -> Self {
    var copy = self
    copy._modal.custom_id = id
    return copy
  }
}


let test = {
  Modal("wagwan") {
    TextField("gm")
  }
}()
