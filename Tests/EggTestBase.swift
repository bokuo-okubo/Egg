//
//  EggTestBase.swift
//  Egg
//
//  Created by Yohei Okubo on 12/23/15.
//  Copyright © 2015 bko. All rights reserved.
//

import XCTest
@testable import Egg

class EggTestBase: XCTestCase {

  /* internal test util */
  func assert(real: Result, _ expect: Result) {
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.tokenized, expect.tokenized)
  }

  func execTest(targetStrExpectList: [(String, TokenResult)], token: Token) {
    for tuple in targetStrExpectList {
      let real =  token.resolve(tuple.0)
      let expect = tuple.1
      assert(real, expect)
    }
  }

  func testSampleTokenParseValidString() {
    // execTest(<#T##targetStrExpectList: [(String, TokenResult)]##[(String, TokenResult)]#>, token: <#T##Token#>)
  }

  func testSampleTokenParseInvalidString() {
    // execTest(<#T##targetStrExpectList: [(String, TokenResult)]##[(String, TokenResult)]#>, token: <#T##Token#>)
  }
}
