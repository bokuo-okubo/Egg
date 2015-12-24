//
//  Atomic.swift
//  Egg : the Swift Tokenizer Combinator
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//


public protocol Atomic {
  static func tokenize(tokenStr: String) -> Token
  static func tokenize() -> Token
  static func emptyToken() -> Token
}

extension Token: Atomic {

  public static func tokenize(tokenStr: String) -> Token {

    let length = tokenStr.characters.count

    let token = Token( name: "<\(tokenStr)>",
      method: { (target: String, cursor: Int) -> Result in

        if cursor + length > target.characters.count {
          return TokenResult(isSuccess: false, index: cursor, tokenized: [])
        }

        let range = stringRange(target, upper: cursor, to: length)

        if target.substringWithRange(range) == tokenStr {
          return TokenResult(isSuccess: true, index: cursor + length, tokenized: [tokenStr])
        } else {
          return TokenResult(isSuccess: false, index: cursor, tokenized: [])
        }
    })
    return token
  }

  public static func tokenize() -> Token {
    return Token()
  }

  public static func emptyToken() -> Token {
    return Token( name: "EMPTY",
      method: { (target, cursor) -> Result in
      if target.characters.count == 0 {
        return TokenResult(isSuccess: true, index: cursor, tokenized: [])
      } else {
        return TokenResult(isSuccess: false, index: cursor, tokenized: [])
      }
    })
  }
}
