//
//  Result.swift
//  Egg : Swift Tokenizer Combinator
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

public protocol Resultable: BooleanType {
  typealias Target
  typealias Content
  var boolValue: Bool { get }
  var target: Target { get }
  var index: Int { get }
  var data: [Content] { get }

  //  init(isSuccess:Bool, target: Target, index: Int, data: [Content])
}


