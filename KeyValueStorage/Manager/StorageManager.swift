//
//  StorageManager.swift
//  KeyValueStorage
//
//  Created by Alexey Sidorov on 04.04.2022.
//

import Foundation

typealias StorageManagerKey = String
typealias StorageManagerValue = String

class StorageManager {

  let storage: Storage<StorageManagerKey, StorageManagerValue>
  private var transactionStack = Stack<Transaction>()
  
  init(storage: Storage<StorageManagerKey, StorageManagerValue>) {
    self.storage = storage
  }
  
  // MARK: -
  
  enum StorageManagerError: Error {
    case noTransaction
    case unknown
    case noKey
    case cantCreateTx
    case cantCommit
  }
  
  typealias StorageManagerSuccess = String
  
  func input(command: Command) -> Result<StorageManagerSuccess, StorageManagerError> {
    if case .begin = command {
      return openTransaction() ? .success("") : .failure(.cantCreateTx)
    } else if case .commit = command {
      return commitTransaction() ? .success("") : .failure(.cantCommit)
    } else if case .rollback = command {
      // pop from stack
      return transactionStack.pop() != nil ? .success("") : .failure(.noTransaction)
    } else if case .set(let key, let value) = command {
      // check if in tx
      // if yes - save to session
      // else - put to stack
      (transactionStack.last?.storage ?? storage).put(key: key, value: value)
      return .success("")
    } else if case .count(let value) = command {
      var vals = Set<StorageManagerKey>()
      //Checkin session vals
      storage.all().filter { el in
        return el.value == value
      }.forEach { el in
        vals.insert(el.key)
      }
      //Checking tx vals
      transactionStack.stack.flatMap { tx in
        return tx.storage.all()
      }.filter { val in
        val.value == value
      }.forEach { val in
        vals.insert(val.key)
      }
      return .success(String(vals.count))
    } else if case .get(let key) = command {
      var iterator = transactionStack.makeIterator()
      var ret: StorageManagerValue?
      while let tx = iterator.next() {
        if let val = tx.storage.get(key: key) {
          ret = val
          break
        }
      }
      if let newRet = ret ?? self.storage.get(key: key) {
        return .success(newRet)
      }
      return .failure(.noKey)
    } else if case .delete(let key) = command {
      (transactionStack.last?.storage ?? storage).delete(key: key)
      return .success("")
    }
    return .failure(.unknown)
  }
  
  // MARK: -
  
  private func openTransaction() -> Bool {
    //add new to stack
    transactionStack.append(Transaction())
    return true
  }
  
  private func commitTransaction() -> Bool {
    // pop from stack put to session
    guard let lastTx = transactionStack.pop() else { return false }
    storage.merge(with: lastTx.storage)
    return true
  }
  
}
