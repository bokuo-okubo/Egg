//
//  Token.swift
//  Egg
//
//  Created by Yohei Okubo on 12/23/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation

public struct Token {

  public let name: String

  public let method: (target: String, cursor: Int) -> Result

  public init(name: String, method: (target: String, cursor: Int) -> Result ) {
    self.name = name
    self.method = method
  }

  public init() {
    self.name = ""
    self.method = { (target, cursor) -> Result in
      return TokenResult(isSuccess: true, index: cursor, tokenized: [])
    }
  }

  /* instance methods */
  public func resolve(target: String) -> Result {
    return self.method(target: target, cursor: 0)
  }

  public func map(name: String, callback: Token -> (target: String, cursor: Int) -> Result ) -> Token {
    let method = callback(self)
    return Token(name: name, method: method)
  }
}
