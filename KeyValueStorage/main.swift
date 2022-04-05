//
//  main.swift
//  KeyValueStorage
//
//  Created by Alexey Sidorov on 04.04.2022.
//

import Foundation

class App {

  let storage = Storage<String, String>()

  init() {
//    let storage = Storage()
//    self.session = Session(storage: storage)
  }

  // MARK: -
  
  func start() {
    let controller = Controller(storageManager: StorageManager(storage: storage))
    
    while let input = readLine() {
      guard input != "quit" else {
          break
      }
      
      let splited = input.split {$0 == " "}.map(String.init)
      let command = Command(rawValue: splited) ?? Command.unknown
      controller.input(command: command)

    }
  }
 
  
  
}

App().start()
