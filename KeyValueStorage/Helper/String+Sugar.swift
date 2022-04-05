//
//  String+Sugar.swift
//  KeyValueStorage
//
//  Created by Alexey Sidorov on 04.04.2022.
//

import Foundation

extension String {
  func trimmingLeadingAndTrailingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
    return trimmingCharacters(in: characterSet)
  }
  
  func trimingLeadingSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
    guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
      return self
    }
    return String(self[index...])
  }
}
