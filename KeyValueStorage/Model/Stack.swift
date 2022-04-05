//
//  Stack.swift
//  KeyValueStorage
//
//  Created by Alexey Sidorov on 04.04.2022.
//

import Foundation

public final class Stack<T>: Sequence {

  // MARK: -
  
  private let queue = DispatchQueue(label: "kook.team.stack", attributes: .concurrent)
  private(set) var stack = [T]()
  
  // MARK: - Public
  
  public func append(_ element: T) {
    queue.async(flags: .barrier) {
      self.stack.append(element)
    }
  }

  public func pop() -> T? {
    var ret: T?
    queue.sync(flags: .barrier) {
      ret = stack.popLast()
    }
    return ret
  }
  
  public var last: T? {
    var ret: T?
    queue.sync {
      ret = stack.last
    }
    return ret
  }
  
  // MARK: - Sequence
  
  public func makeIterator() -> Array<T>.Iterator {
    return stack.reversed().makeIterator()
  }
}
