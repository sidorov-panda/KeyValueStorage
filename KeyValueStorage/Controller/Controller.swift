//
//  Controller.swift
//  KeyValueStorage
//
//  Created by Alexey Sidorov on 04.04.2022.
//

import Foundation

class Controller {
  
  lazy var view: View = {
    return View()
  }()
  
  let storageManager: StorageManager
  
  init(storageManager: StorageManager) {
    self.storageManager = storageManager

    start()
  }
  
  func start() {
    view.printWelcome()
    view.printCommands()
    view.printPrompt()
  }
  
  func input(command: Command) {
    if case .unknown = command {
      view.printUnknownCommand()
    } else {
      let res = storageManager.input(command: command)
      switch res {
      case .success(let value):
        view.printText(value)
      case .failure(let error):
        switch error {
        case .noTransaction:
          view.printText("no transaction")
        case .noKey:
          view.printText("key not set")
        default:
          view.printText("Unknown Error Occured")
        }
      }
    }
  }

}
