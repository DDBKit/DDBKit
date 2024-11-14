//
//  InteractionExtras+.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 14/11/2024.
//

import DDBKit

public extension InteractionExtras {
  /// Exposes pre-defined database requests based on the current interaction context.
  var dbRequests: DatabaseBranches {
    .init(self.interaction)
  }
}
