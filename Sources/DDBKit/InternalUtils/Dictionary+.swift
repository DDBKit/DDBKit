//
//  Dictionary+.swift
//  DDBKit
//
//  Created by Lakhan Lothiyi on 09/10/2024.
//

extension Dictionary where Value: RangeReplaceableCollection {
  
  // ensures there's an array at the given key and then appends an element to it
  mutating func append(_ element: Value.Element, to key: Key) {
    if self[key] != nil { // if exists
      self[key]?.append(element)
    } else { // else make new array
      self[key] = [element] as? Value
    }
  }
}
