//
//  Extensions.swift
//  Egg : the Swift Tokenizer Combinator
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

public protocol Extensions {
  //  func concat(token: Token) -> Token
}

extension Extensions {

//  public static func concat(token: Token) -> Token {
//    return token.map("CONCAT[\(token.name)]",
//      callback: { (token) -> (target: String, cursor: Int) -> Result in
//        return { (target: String, cursor: Int) -> Result in
//          let strs = token.resolve(target).tokenized
//          return TokenResult(isSuccess: true,
//            index: cursor,
//            tokenized: [strs.reduce("", combine: { String($0 + $1) })] )
//        }
//    })
//  }
}
