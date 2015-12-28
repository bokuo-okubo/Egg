//
//  Lexer.swift
//  Egg
//
//  Created by Yohei Okubo on 12/25/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation

public protocol TokenType {
  var name: String { get }
}

public struct VoidToken {
  let name: String
  init() {
    self.name = "VOID"
  }
}

public class LexResult {
  public typealias Target = String
  public typealias Content = TokenType

  public let isSuccess: Bool
  public let target: Target
  public let data: Content

  public init(isSuccess: Bool, target: Target, data: Content) {
    self.isSuccess = isSuccess
    self.target = target
    self.data = data
  }
}

public final class Lexer {

  var scanners: [(Scanner, TokenType)] = []

  public func registerScanners(scns: [(Scanner, TokenType)] ) {
    scanners += scns
  }

}
