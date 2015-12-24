//
//  Token.swift
//  Egg : the Swift Tokenizer Combinator
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation

public typealias Egg = Token

//public func tokenize(str: String) -> Token {
//  return Token.tokenize(str)
//}

public extension String {
  func toToken() -> Token {
    return Token.tokenize(String(self.characters))
  }
}

public extension Int {
  func toToken() -> Token {
    return Token.tokenize(String(self.value))
  }
}
