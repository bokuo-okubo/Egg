//
//  Scanner.swift
//  Egg
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation


public class ScanResult: Resultable {
  public typealias Target = String
  public typealias Content = String

  public let boolValue: Bool
  public let target: Target
  public let index: Int
  public let data: [Content]

  init(isSuccess: Bool, target: Target, index: Int, data: [Content]) {
    self.boolValue = isSuccess
    self.target = target
    self.index = index
    self.data = data
  }
}

public final class ScanTrue: ScanResult {
  init(target: String, index: Int, data: [String]) {
    super.init(isSuccess: true, target: target, index: index, data: data)
  }
}

public final class ScanFalse: ScanResult {
  init(target: String, index: Int) {
    super.init(isSuccess: false, target: target, index: index, data: [])
  }
}

public protocol Scannable {
  typealias Target
  typealias Result = Resultable

  var name: String { get }
  var method: (target: Target, cursor: Int) -> Result { get }

  static func create(symbol: Target) -> Self
  func resolve(target: Target) -> Result
}

public final class Scanner: Scannable {

  public let name: String
  public let method: (target: String, cursor: Int) -> ScanResult

  init(name: String, method: (target: String, cursor: Int) -> ScanResult ) {
    self.name = name
    self.method = method
  }

  public static func create() -> Scanner {
    return empty()
  }

  public static func create(symbol: String) -> Scanner {
    let length = symbol.characters.count
    if length == 0 {
      return empty()
    }
    let method = { (target: String, cursor: Int) -> ScanResult in

      if cursor + length > target.characters.count {
        return ScanFalse(target: target, index: cursor)
      }

      let range = stringRange(target, upper: cursor, to: length)

      if target.substringWithRange(range) == symbol {
        return ScanTrue(target: target, index: cursor + length, data: [symbol])
      } else {
        return ScanFalse(target: target, index: cursor)
      }
    }
    return Scanner(name: "<\(symbol)>", method: method)
  }

  private static func empty() -> Scanner {
    return Scanner(name: "EMPTY",
      method: { (target, cursor) -> ScanResult in
        if target.characters.count == 0 {
          return ScanTrue(target: target, index: cursor, data: [])
        } else {
          return ScanFalse(target: target, index: cursor)
        }
    })
  }

  public func resolve(target: String) -> ScanResult {
    return self.method(target: target, cursor: 0)
  }
}
