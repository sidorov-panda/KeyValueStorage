//
//  Command.swift
//  KeyValueStorage
//
//  Created by Alexey Sidorov on 04.04.2022.
//

import Foundation

enum Command {
  case set(key: String, value: String)
  case get(key: String)
  case delete(key: String)
  case count(key: String)
  case begin
  case commit
  case rollback
  case unknown
  case incorrect
}

extension Command: RawRepresentable {
  typealias RawValue = [String]
  
  var rawValue: [String] {
    fatalError()
  }
  
  init?(rawValue: [String]) {
    let commandName = rawValue.first?.lowercased()
    let key = rawValue[safe: 1]
    let argument = rawValue[safe: 2...].reduce(into: "") { partialResult, str in
      partialResult += str + " "
    }.trimmingLeadingAndTrailingSpaces()

    switch commandName {
    case "set":
      self = (key != nil) ? .set(key: key!, value: argument) : .incorrect
    case "get":
      self = (key != nil) ? .get(key: key!) : .incorrect
    case "delete":
      self = (key != nil) ? .delete(key: key!) : .incorrect
    case "count":
      self = (key != nil) ? .count(key: key!) : .incorrect
    case "begin":
      self = .begin
    case "commit":
      self = .commit
    case "rollback":
      self = .rollback
    default:
      self = .unknown
    }
  }
  
}
