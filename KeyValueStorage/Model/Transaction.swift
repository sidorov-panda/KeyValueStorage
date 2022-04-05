//
//  Transaction.swift
//  KeyValueStorage
//
//  Created by Alexey Sidorov on 04.04.2022.
//

import Foundation

class Transaction {
  
  private(set) var storage: Storage<StorageManagerKey, StorageManagerValue>
  
  init(storage: Storage<StorageManagerKey, StorageManagerValue> = Storage()) {
    self.storage = storage
  }
  
}
