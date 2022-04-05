//
//  Array+Safe.swift
//  KeyValueStorage
//
//  Created by Alexey Sidorov on 04.04.2022.
//

import Foundation

extension Array {
  
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
  
  subscript(safe range: Range<Index>) -> ArraySlice<Element> {
    return self[Swift.min(range.startIndex, self.endIndex)..<Swift.min(range.endIndex, self.endIndex)]
  }

  subscript(safe range: PartialRangeFrom<Index>) -> ArraySlice<Element> {
    return self[Swift.min(range.lowerBound, self.endIndex)...]
  }
}
