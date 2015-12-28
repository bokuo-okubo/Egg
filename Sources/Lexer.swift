//
//  Lexer.swift
//  Egg
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation

public class LexResult<TokenType>: Resultable {
  public typealias Target = String
  public typealias Content = TokenType

  public let isSuccess: Bool
  public let target: Target
  public let data: [Content]

  init(isSuccess: Bool, target: Target, data: [Content]) {
    self.isSuccess = isSuccess
    self.target = target
    self.data = data
  }
}

public final class Lexer<TokenType> {

  let scanner: Scanner
  let token: TokenType

  public init(token: TokenType, scanner: Scanner) {
    self.scanner = scanner
    self.token = token
  }

  public func tokenize(str: String) -> LexResult<TokenType> {
    if scanner.resolve(str).isSuccess {
      return LexResult(isSuccess: true, target: str, data: [self.token])
    } else {
      return LexResult(isSuccess: false, target: str, data: [])
    }
  }
}
