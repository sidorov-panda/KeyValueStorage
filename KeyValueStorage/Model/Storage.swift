//
//  Storage.swift
//  KeyValueStorage
//
//  Created by Alexey Sidorov on 04.04.2022.
//

import Foundation

public final class Storage<Key, Value> where Key: Hashable, Value: Hashable {
  
  // MARK: -
  
  private let queue = DispatchQueue(label: "kook.team.safeValues", attributes: .concurrent)
  private var dict = [Key: Value]()
  
  // MARK: - Public
  
  public func put(key: Key, value: Value) {
    queue.async(flags: .barrier) {
      self.dict[key] = value
    }
  }

  public func get(key: Key) -> Value? {
    var ret: Value?
    queue.sync {
      ret = dict[key]
    }
    return ret
  }
  
  public func count(value: Value) -> Int {
    var ret: Int = 0
    queue.sync {
      ret = dict.values.filter { $0 == value }.count
    }
    return ret
  }
  
  public func delete(key: Key) {
    queue.async(flags: .barrier) {
      self.dict[key] = nil
    }
  }
  
  public func merge(with newValues: Storage) {
    queue.async(flags: .barrier) {
      self.dict.merge(newValues.dict) { (_, new) in new }
    }
  }
  
  public func all() -> [Key: Value] {
    var ret = [Key: Value]()
    queue.sync {
      ret = dict
    }
    return ret
  }

}
