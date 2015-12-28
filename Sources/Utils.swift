//
//  Utils.swift
//  Egg : the Swift Tokenizer Combinator
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation

// for debugging.
func p<T>(objs: T...) -> [String] {
  return objs.map({ print( String($0) ); return String($0) })
}


// stringRange maker
func stringRange(target: String, upper: Int, to: Int) -> Range<String.CharacterView.Index> {

  let idx = target.startIndex
  let length = target.characters.count
  let isCursorInnerString = length > upper + to

  if isCursorInnerString { // TODO: check -> to test if upper is out of range
    return Range(start: idx.advancedBy(upper), end: idx.advancedBy(upper).advancedBy(to) )
  } else {
    return Range(start: idx.advancedBy(upper), end: target.endIndex )
  }
}

/*
* NSRegularExpression Wrapper
*/
private class Regexp {
  let internalRegexp: NSRegularExpression
  let pattern: String

  init(_ pattern: String) {
    self.pattern = pattern
    do {
      self.internalRegexp = try NSRegularExpression(pattern: pattern, options: [])
    } catch {
      self.internalRegexp = NSRegularExpression()
    }

  }

  func isMatch(input: String) -> Bool {
    let nsString = input as NSString
    let matches = self.internalRegexp.matchesInString(input, options:[], range:NSMakeRange(0, nsString.length))
    return matches.count > 0
  }

  func matches(input: String) -> [String]? {
    if self.isMatch(input) {
      let nsString = input as NSString
      let matches = self.internalRegexp.matchesInString( input, options: [], range:NSMakeRange(0, nsString.length) )
      var results: [String] = []
      for i in 0 ..< matches.count {
        results.append( (input as NSString).substringWithRange(matches[i].range) )
      }
      return results
    }
    return nil
  }
}

func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
  for (k, v) in right {
    left.updateValue(v, forKey: k)
  }
}
