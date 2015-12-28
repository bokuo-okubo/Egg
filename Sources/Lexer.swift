//
//  Lexer.swift
//  Egg
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation

public protocol TokenType {
  var name: String { get }
}

public struct VoidToken {
  let name: String
  init() {
    self.name = "VOID"
  }
}

public class LexResult {
  public typealias Target = String
  public typealias Content = TokenType

  public let isSuccess: Bool
  public let target: Target
  public let data: Content

  public init(isSuccess: Bool, target: Target, data: Content) {
    self.isSuccess = isSuccess
    self.target = target
    self.data = data
  }
}

public final class Lexer {

  let scanner: Scanner
  let token: TokenType

  public init(token: TokenType, scanner: Scanner) {
    self.scanner = scanner
    self.token = token
  }

  public func tokenize(str: String) -> LexResult {
    if scanner.resolve(str).isSuccess {
      return LexResult(isSuccess: true, target: str, data: self.token)
    } else {
      return LexResult(isSuccess: false, target: str, data: VoidToken() as! TokenType)
    }
  }
}
