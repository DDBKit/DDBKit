//
//  File.swift
//
//
//  Created by Lakhan Lothiyi on 22/04/2024.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct DDBKitMacros: CompilerPlugin {
    var providingMacros: [Macro.Type] = [DatabaseInterfaceAccessorMacro.self]
}

public struct DatabaseInterfaceAccessorMacro: AccessorMacro {
  public static func expansion(
    of node: SwiftSyntax.AttributeSyntax,
    providingAccessorsOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
    in context: some SwiftSyntaxMacros.MacroExpansionContext
  ) throws -> [SwiftSyntax.AccessorDeclSyntax] {
    // Extract information from the stored property declaration
    guard let variableDecl = declaration.as(VariableDeclSyntax.self),
          let patternBinding = variableDecl.bindings.as(PatternBindingListSyntax.self)?.first?.as(PatternBindingSyntax.self),
          var identifier = patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
          let identifierType = patternBinding.typeAnnotation?.as(TypeAnnotationSyntax.self)?.type.as(IdentifierTypeSyntax.self)?.name.text else {
      return []
    }
    // Extract custom key from macro argument if provided
    if let attributeSyntax = variableDecl.attributes.as(AttributeListSyntax.self)?.first?.as(AttributeSyntax.self),
       let argument = attributeSyntax.arguments?.as(LabeledExprListSyntax.self)?.first?.as(LabeledExprSyntax.self),
       let key = argument.expression.as(StringLiteralExprSyntax.self)?.segments.as(StringLiteralSegmentListSyntax.self)?.first?.as(StringSegmentSyntax.self)?.content.text {
      identifier = key
    }
    // Generate custom accessors for the stored property
    return [
      AccessorDeclSyntax(
        stringLiteral:
"""
async get {
  let cx = self.context
  let db = Database.shared
  dictionary["\(identifier)"]! as! \(identifierType)
}
"""
      ),
      AccessorDeclSyntax(
        stringLiteral:
"""
set {
  dictionary["\(identifier)"] = newValue
}
"""
      )
    ]
  }
}
