//
//  TokenTests.swift
//  Egg
//
//  Created by Yohei Okubo on 12/24/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation
import XCTest
@testable import Egg

/* test class */
class ScannerTests: EggTestBase {

  /* test basic token */
  typealias $ = Scanner

  private let HogeT = $.create("hoge")
  private let FooT = $.create("foo")
  private let emptyToken = $.create()


  func assert(real: ScanResult, _ expect: ScanResult) {
    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.boolValue, expect.boolValue)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data, expect.data)
  }

  func execTest(
    targetStrExpectList: [(String, ScanResult)], scanner: Scanner) {
      for tuple in targetStrExpectList {
        let real =  scanner.resolve(tuple.0)
        let expect = tuple.1
        assert(real, expect)
      }
  }

  /* tokenize test */
  func testInit() {

    let real = emptyToken.resolve("")

    let expect = ScanTrue(target: "", index: 0, data: [])
    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.boolValue, expect.boolValue)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data, expect.data)
  }

  /* tokenize test */
  func testInitParseInValid() {

    let real = emptyToken.resolve("ll")
    let expect = ScanFalse(target: "ll", index: 0)
    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.boolValue, expect.boolValue)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data, expect.data)
  }

  func testTokenizeParseInValidString() {

    let expect = ScanFalse(target: "hoge", index: 0)

    let testList = [
      "foobar",
      "3hoge",
      "ho--ge"
    ]
    for real in testList.map({ HogeT.resolve($0) }) {
      XCTAssertEqual(real.boolValue, expect.boolValue)
      XCTAssertEqual(real.index, expect.index)
      XCTAssertEqual(real.data, expect.data)
    }
  }
}
