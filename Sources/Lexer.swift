//
//  Lexer.swift
//  Egg
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation

enum Token {
  case VOID
  case RESOURCE
  case PARAM
}

class LexResult: Resultable {
  typealias Target = String
  typealias Content = Token

  let boolValue: Bool
  let target: Target
  let index: Int
  let data: [Content]

  init(isSuccess: Bool, target: Target, index: Int, data: [Content]) {
    self.boolValue = isSuccess
    self.target = target
    self.index = index
    self.data = data
  }
}

final class LexTrue: LexResult {
  init(target: String, index: Int, data: [Token]) {
    super.init(isSuccess: true, target: target, index: index, data: data)
  }
}

final class LexFalse: LexResult {
  init(target: String, index: Int) {
    super.init(isSuccess: false, target: target, index: index, data: [])
  }
}


protocol Lexable {
  var tokenList: [(Scanner, Token)] { get }
}

final class Lexer {

  var tokenList: [(Scanner, Token)]

  init(tokenList: [(Scanner, Token)]) {
    self.tokenList = tokenList
  }

  func register(scanner: Scanner, token: Token) {
    self.tokenList.append( (scanner, token) )
  }

  func tokenize(target: String) -> Token {

    for (scanner, token) in tokenList {
      if scanner.resolve(target) {
        return token
      } else {
        continue
      }
    }
    return Token.VOID // TODO : tmp
  }

  func tokenize(targets: [String]) -> [Token] {
    return targets.map({ self.tokenize($0) })
  }
}
