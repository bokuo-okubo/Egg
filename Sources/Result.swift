//
//  Result.swift
//  Egg : Swift Tokenizer Combinator
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

public protocol Result {
  var isSuccess: Bool { get }
  var tokenized: [String] { get }
  var index: Int { get }
}

public struct TokenResult: Result {

  public var paramDict: [String : Int]

  public let isSuccess: Bool
  public let index: Int
  public let tokenized: [String]

  init(isSuccess: Bool, index: Int, tokenized: [String]) {
    self.paramDict = [:]

    (self.isSuccess, self.index, self.tokenized) = (isSuccess, index, tokenized)
  }
}
