//
//  GenericBuilder.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 10/10/2024.
//

public struct GenericTuple<T> {
  public var values: [T]
  
  // Provide an empty instance of the tuple
  public static var empty: Self { .init(values: []) }
  
  // Append a new element to the tuple
  mutating func append(_ element: T) {
    values.append(element)
  }
  
  // Merges another tuple's contents into this one
  mutating func merge(_ other: GenericTuple<T>) {
    values.append(contentsOf: other.values)
  }
}

@resultBuilder
public struct GenericBuilder<T> {
  // Builds a block of multiple components into a tuple
  public static func buildBlock(_ components: GenericTuple<T>...) -> GenericTuple<T> {
    var result = GenericTuple<T>.empty
    for component in components {
      result.merge(component)
    }
    return result
  }
  
  // Builds an optional component, returning an empty tuple if nil
  public static func buildOptional(_ component: GenericTuple<T>?) -> GenericTuple<T> {
    return component ?? GenericTuple<T>.empty
  }
  
  // For conditional logic: if the first option is selected, return it
  public static func buildEither(first component: GenericTuple<T>) -> GenericTuple<T> {
    return component
  }
  
  // For conditional logic: if the second option is selected, return it
  public static func buildEither(second component: GenericTuple<T>) -> GenericTuple<T> {
    return component
  }
  
  // Build an array of T directly into a tuple
  public static func buildArray(_ components: [GenericTuple<T>]) -> GenericTuple<T> {
    var result = GenericTuple<T>.empty
    for component in components {
      result.merge(component)
    }
    return result
  }
  
  // Build a single component
  public static func buildExpression(_ expression: T) -> GenericTuple<T> {
    return GenericTuple(values: [expression])
  }
}
