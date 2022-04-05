//
//  View.swift
//  KeyValueStorage
//
//  Created by Alexey Sidorov on 04.04.2022.
//

import Foundation

class View {
  
  func printWelcome() {
    print("Welcome to the Transactional Key Value Storage")
    print("Use the following commands")
  }

  func printCommands() {
    print("SET <key> <value> // store the value for key")
    print("GET <key> // return the current value for key")
    print("DELETE <key> // remove the entry for key")
    print("COUNT <value> // return the number of keys that have the given value")
    print("BEGIN // start a new transaction")
    print("COMMIT // complete the current transaction")
    print("ROLLBACK // revert to state prior to BEGIN call")
  }
  
  func printPrompt() {
    print("Type your command:")
  }
  
  func printUnknownCommand() {
    print("Unknown command")
  }
  
  func printText(_ text: String) {
    print(text)
  }
  
}
