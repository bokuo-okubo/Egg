//
//  CombinedTokenTests.swift
//  Egg
//
//  Created by Yohei Okubo on 12/24/15.
//  Copyright © 2015 bko. All rights reserved.
//

import Foundation
import XCTest
@testable import Egg

class CombinedTokenTests: EggTestBase {

  func testParamT() {
    let testStr = "/:hoge"
    let real = paramT.resolve(testStr)
    let expect = ScanTrue(target: testStr,
      index: testStr.characters.count,
      data: ["/:hoge"])

    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data, expect.data)

  }

  func testParamSeparatorT() {
    let testStr = "/:"
    let real = paramSepalatorT.resolve(testStr)
    let expect = ScanTrue(target: testStr,
      index: testStr.characters.count,
      data: testStr.characters.map{ String($0) })

    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data, expect.data)
  }

  func testManyPathAndParamT() {
    let entryAPIScheme =  "/api/:version/entries/:id/assess"
    let expectTokenized = [ "/api", "/:version", "/entries", "/:id", "/assess"]

    let expect = ScanTrue(target:entryAPIScheme,
      index: entryAPIScheme.characters.count,
      data: expectTokenized)
    let real = manyPathAndParamT.resolve(entryAPIScheme)

    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data, expect.data)

  }
  
  func testUrlHoge() {
    let entryAPIScheme =  "/api/:version/entries/:id/assess"
    let expectTokenized = [ "/api", "/:version", "/entries", "/:id", "/assess"]

    let expect = ScanTrue(target:entryAPIScheme,
      index: -1,
      data: expectTokenized)
    let real = MockToken.urlPathSchemeToken.resolve(entryAPIScheme)

    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data, expect.data)

  }

  func testUrlPathTokenParsesValidString() {
    let entryAPISchemes = [
      "/api/:version/entries/:id/assess",
      "/api/:version/entries/:id/assess/:foo:bar"
    ]
    let expectTokenizeds: [[String]] = [
      [ "/api", "/:version", "/entries", "/:id", "/assess"],
      ["/api", "/:version", "/entries", "/:id", "/assess", "/:foo", ":bar"]
    ]

    for (expectTokenized, entryAPIScheme) in zip(expectTokenizeds, entryAPISchemes) {
      let expect = ScanTrue(target: entryAPIScheme, index: -1, data: expectTokenized)

      let real = MockToken.urlPathSchemeToken.resolve(entryAPIScheme)
      XCTAssertEqual(real.target, expect.target)
      XCTAssertEqual(real.isSuccess, expect.isSuccess)
      XCTAssertEqual(real.index, expect.index)
      XCTAssertEqual(real.data, expect.data)
    }
  }
}