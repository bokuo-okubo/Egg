//
//  Result.swift
//  Egg : Swift Tokenizer Combinator
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

public protocol Resultable {
  typealias Target
  typealias Content
  var isSuccess: Bool { get }
  var target: Target { get }
  var data: [Content] { get }
}
