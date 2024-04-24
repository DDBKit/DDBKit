//
//  DatabaseInterface.swift
//
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import Foundation
import Database
import DDBKitMacros

@attached(accessor)
macro DatabaseInterface() = #externalMacro(module: "DDBKitMacros", type: "DatabaseInterfaceAccessorMacro")

//@propertyWrapper
//struct DatabaseInterfaceShim {
//  var context: SceneContext
//  init(cx: SceneContext) {
//    self.context = cx
//  }
//  
//  var wrappedValue: <#type#> {
//    <#statements#>
//  }
//}

struct meow {
  var obj: String
}
