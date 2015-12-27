//
//  Standard.swift
//  Egg : the Swift Scannerizer Combinator
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

public protocol Standard {

  static func or(parsers: [Scanner]) -> Scanner
  static func or(parsers: Scanner...) -> Scanner

  static func eof(str: String) -> Scanner
  static func eof() -> Scanner

  static func many(scanner: Scanner) -> Scanner

  static func char(str: String) -> Scanner

  static func not(scanner: Scanner) -> Scanner

  static func option(scanner: Scanner) -> Scanner

  static func seq(scanners: Scanner...) -> Scanner
  static func seq(scanners: [Scanner]) -> Scanner
}

extension Scanner: Standard {

  public static func or(scanners: [Scanner]) -> Scanner {
    let name = "OR[" + scanners.reduce("", combine: { $0 + $1.name }) + "]"
    let method = { (target: String, cursor: Int) -> ScanResult in
      var current: Int = cursor
      var result: ScanResult
      var rtnData: [String] = []
      for scn in scanners {
        result = scn.method(target: target, cursor: current)
        rtnData.appendContentsOf(result.data)
        current = result.index
        if result {
          return ScanTrue(target: target, index: current, data: result.data)
        }
      }
      return ScanFalse(target: target, index: current)
    }
    return Scanner(name: name, method: method)
  }

  public static func or(scanners: Scanner...) -> Scanner {
    return or(scanners)
  }

  public static func eof(str: String) -> Scanner {
    let scanner = Scanner.create(str)
    let name = "EOF[\(scanner.name)]"
    let method = { (target: String, cursor: Int) -> ScanResult in
      let result = scanner.method(target: target, cursor: cursor)
      let isLast = cursor == target.characters.count
      if isLast {
        return ScanTrue(target: target, index: -1, data: result.data)
      } else {
        return ScanFalse(target: target, index: result.index)
      }
    }
    return Scanner(name: name, method: method)

  }

  public static func eof() -> Scanner {
    let name = "EOF"
    let method = { (target: String, cursor: Int) -> ScanResult in
      let isLast = cursor == target.characters.count
      if isLast {
        return ScanTrue(target: target, index: -1, data: [])
      } else {
        return ScanFalse(target: target, index: cursor)
      }
    }
    return Scanner(name: name, method: method)
  }

  public static func many(scanner: Scanner) -> Scanner {
    return Scanner(name: "MANY[" + scanner.name + "]",
      method: { (target: String, cursor: Int) -> Result in

        var current: Int = cursor
        var rtnData: [String] = []

        while true {
          let result = scanner.method(target: target, cursor: current)
          if result {
            rtnData.appendContentsOf(result.data)
            current = result.index
          } else {
            break
          }
        }

        if rtnData.count > 0 {
          return ScanTrue(target: target, index: current, data: rtnData)
        } else {
          return ScanFalse(target: target, index: current)
        }
    })
  }

  public static func char(str: String) -> Scanner {
    let charSet = Set(str.characters)
    let lettersT = charSet.map({ char in Scanner.create(String(char)) })
    return or(lettersT)
  }

  public static func not(scanner: Scanner) -> Scanner {
    return Scanner(name: "NOT[\(scanner.name)]",
      method: { (target: String, cursor: Int) -> Result in
        let result = scanner.method(target: target, cursor: cursor)

      if result {
        return ScanFalse(target: target, index: cursor)
      } else {
        return ScanTrue(target: target, index: cursor, data: [])
      }
    })
  }

  public static func option(scanner: Scanner) -> Scanner {
    return Scanner(name: "OPTION[\(scanner.name )]",
      method: { (target: String, cursor: Int) -> Result in
        return Scanner.or(scanner, not(scanner)).method(target: target, cursor: cursor)
    })
  }

  public static func seq(scanners: [Scanner]) -> Scanner {
    let name = "SEQ[" + scanners.reduce("", combine: { $0 + $1.name + "," }) + "]"
    return Scanner(name: name,
      method: { (target, cursor) -> Result in

        var rtnData: [String] = []
        var current = cursor

        for scanner in scanners {
          let result = scanner.method(target: target, cursor: current)

          if result {
            rtnData.appendContentsOf(result.data)
            current = result.index
          } else {
            return ScanFalse(target: target, index: cursor)
          }
        }
        return ScanTrue(target: target, index: current, data: rtnData)
    })
  }

  /**
   Overload Sequence Parser generate

   - parameter parsers: Variadic parsers

   - returns:
   */
  public static func seq(scanners: Scanner...) -> Scanner {
    return seq(scanners)
  }

  public static func concat(scanner: Scanner) -> Scanner {
    let prevName = scanner.name
    return Scanner(name: "CONCAT[\(prevName)]",
      method: { (target, cursor) -> Result in
        let result = scanner.method(target: target, cursor: cursor)
        if result {
          return ScanTrue(target: target,
            index: result.index,
            data: [result.data.reduce("") {$0 + $1}])
        } else {
          return ScanFalse(target: target, index: result.index)
        }
    })
  }
}