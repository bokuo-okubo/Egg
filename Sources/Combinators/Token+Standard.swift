//
//  Standard.swift
//  Egg : the Swift Tokenizer Combinator
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

public protocol Standard {

  static func or(parsers: [Token]) -> Token
  static func or(parsers: Token...) -> Token

  static func eof(str: String) -> Token
  static func eof() -> Token

  static func many(token: Token) -> Token

  static func char(str: String) -> Token

  static func not(token: Token) -> Token

  static func option(token: Token) -> Token

  static func seq(tokens: Token...) -> Token
  static func seq(tokens: [Token]) -> Token
}

extension Token: Standard {

  public static func or(tokens: [Token] ) -> Token {

    let name = "OR[" + tokens.reduce("", combine: { $0 + $1.name + "," }) + "]"

    return Token(
      name: name,
      method: { (target: String, cursor: Int) -> Result in
        for token in tokens {
          let result = token.method(target: target, cursor: cursor)
          if result.isSuccess { return result }
        }
        return TokenResult(isSuccess: false, index: cursor, tokenized: [])
      }
    )
  }

  public static func or(tokens: Token...) -> Token {
    return or(tokens)
  }

  public static func eof(str: String) -> Token {
    return Token.createEOF(Token.tokenize(str))
  }

  public static func eof() -> Token {
    return Token.createEOF(Token.tokenize())
  }

  private static func createEOF(token: Token) -> Token {
    return token.map("EOF", callback: { (tok: Token) -> (target: String, cursor: Int) -> Result in
      return { (target: String, cursor: Int) -> Result in
        let result = tok.method(target: target, cursor: cursor)
        let isLast = result.index == target.characters.count
        if isLast {
          return TokenResult(isSuccess: true, index: -1, tokenized: [])
        } else {
          return TokenResult(isSuccess: false, index: cursor, tokenized: [])
        }
      }
    })
  }

  public static func many(token: Token) -> Token {
    return Token(name: "MANY[" + token.name + "]",
      method: { (target: String, cursor: Int) -> Result in

        var current: Int = cursor
        var rtnData: [String] = []

        while true {

          let result = token.method(target: target, cursor: current)

          if result.isSuccess {
            rtnData.appendContentsOf(result.tokenized)
            current = result.index
          } else {
            break
          }
        }

        if rtnData.count > 0 {
          return TokenResult(isSuccess: true, index: current, tokenized: rtnData)
        } else {
          return TokenResult(isSuccess: false, index: current, tokenized: rtnData)
        }
    })
  }

  public static func char(str: String) -> Token {
    let charSet = Set(str.characters)
    let lettersT = charSet.map({ _ in Token.tokenize(str) })
    return or(lettersT)
  }

  public static func not(token: Token) -> Token {
    return Token(name: "NOT[\(token.name)]",
      method: { (target: String, cursor: Int) -> Result in
        let result = token.method(target: target, cursor: cursor)

        if result.isSuccess {
          return TokenResult(isSuccess: false, index: cursor, tokenized: [])
        } else {
          return TokenResult(isSuccess: true, index: target.characters.count, tokenized: [])
        }
    })
  }

  public static func option(token: Token) -> Token {
    return Token(name: "OPTION[\( token.name )]",
      method: { (target: String, cursor: Int) -> Result in
        return Token.or(token, not(token)).method(target: target, cursor: cursor)
    })
  }

  public static func seq(tokens: [Token]) -> Token {

    return Token(name: "SEQ[" + tokens.reduce("", combine: { $0 + $1.name + "," }) + "]",
      method: { (target, cursor) -> TokenResult in

      var rtnData: [String] = []
      var current = cursor

      for token in tokens {
        let result = token.method(target: target, cursor: current)

        if result.isSuccess {
          rtnData.appendContentsOf(result.tokenized)
          current = result.index
        } else {
          return TokenResult(isSuccess: false, index: cursor, tokenized: [])
        }
      }
      return TokenResult(isSuccess: true, index: current, tokenized: rtnData)
    })
  }

  /**
   Overload Sequence Parser generate

   - parameter parsers: Variadic parsers

   - returns:
   */
  public static func seq(tokens: Token...) -> Token {
    return seq(tokens)
  }
}
