//
//  scanner+StandardTests.swift
//  Egg
//
//  Created by Yohei Okubo on 12/24/15.
//  Copyright © 2015 bko. All rights reserved.
//

import XCTest
@testable import Egg

class Scanner_StandardTests: EggTestBase {

  typealias $ = Scanner

  let hogeT = $.create("hoge")
  let fooT = $.create("foo")

  func assert(real: ScanResult, _ expect: ScanResult) {
    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data, expect.data)
  }

  func execTest( targetStrExpectList: [(String, ScanResult)], scanner: Scanner) {
    for tuple in targetStrExpectList {
      let real =  scanner.resolve(tuple.0)
      let expect = tuple.1
      assert(real, expect)
    }
  }

  func testOrMethodParseValidString() {

    let hogeOrFooT = $.or(hogeT, fooT)

    let expectHoge = ScanTrue(
      target: "hoge",
      index: "hoge".characters.count,
      data: ["hoge"], params: [:]) as ScanResult

    let expectFoo = ScanTrue(
      target: "foo",
      index: "foo".characters.count,
      data: ["foo"], params: [:]) as ScanResult

    let testList = [
      ("hoge", expectHoge),
      ("foo", expectFoo),
    ]
    for (tag, expect) in testList {
      let real = hogeOrFooT.resolve(tag)
      XCTAssertEqual(real.target, expect.target)
      XCTAssertEqual(real.isSuccess, expect.isSuccess)
      XCTAssertEqual(real.index, expect.index)
      XCTAssertEqual(real.data, expect.data)
    }
  }

  private func genFalse(target: String) -> ScanResult {
    return ScanFalse(target: target, index: 0) as ScanResult
  }

  func testOrscannerParseIvalidString() {

    let HogeOrFooT = $.or(hogeT, fooT)

    let testList = [
      "ugaa",
      "hogfoo",
      "fohoge",
      ].map({ ($0, genFalse($0))})

    execTest(testList,scanner: HogeOrFooT)
  }

  func testNotscannerParseValidString() {

    let NotHogeT = $.not(hogeT)

    let testList = [
      "foo",
      "あいうえお",
      "0123456"
      ].map({
        ($0, ScanTrue(target: $0, index: 0, data: [], params: [:]) as ScanResult)
      })

    for (tag, expect) in testList {
      let real = NotHogeT.resolve(tag)
      XCTAssertEqual(real.target, expect.target)
      XCTAssertEqual(real.isSuccess, expect.isSuccess)
      XCTAssertEqual(real.index, expect.index)
      XCTAssertEqual(real.data, expect.data)
    }
  }

  func testNotscannerParseIvalidString() {

    let NotHogeT = $.not(hogeT)

    let testList = [("hoge", genFalse("hoge"))]

    execTest(testList,scanner: NotHogeT)
  }

  /**
   Sequenceのテスト
   */
  func testSeqscannerParseValidString() {
    let HogeFooT = $.seq(hogeT, fooT)
    let real = HogeFooT.resolve("hogefoo")
    let expect = ScanTrue(target: "hogefoo",
      index: "hogefoo".characters.count,
      data: ["hoge", "foo"], params: [:])
    assert(real, expect)
  }

  func testSeqscannerParseInvalidString() {

    let HogeFooT = $.seq(hogeT, fooT)

    let testList = [
      "hoge",
      "foo",
      "hogfoo",
      "foohog"
      ].map({ ($0, genFalse($0) )})
    execTest(testList, scanner: HogeFooT)
  }

  func testManyHogeString() {
    let testStr = "hogehoge"
    let manyHoge = Scanner.many(hogeT)
    let real = manyHoge.resolve(testStr)
    let expect = ScanTrue(target: testStr, index: testStr.characters.count, data: ["hoge","hoge"], params: [:])
    XCTAssertEqual(real.target, expect.target)
    XCTAssertEqual(real.isSuccess, expect.isSuccess)
    XCTAssertEqual(real.index, expect.index)
    XCTAssertEqual(real.data, expect.data)
  }

    func testManyOrParseValidString() {
      let hogeOrFooT = $.or(hogeT, fooT)
      let manyHogeOrFooT = $.many(hogeOrFooT)
      let testStr = "hogefoohogefoo"
  
      let real = manyHogeOrFooT.resolve(testStr)
      let expect = ScanTrue(target: testStr,
        index: testStr.characters.count,
        data: ["hoge", "foo", "hoge", "foo"], params: [:])
      assert(real, expect)
    }

    func testManyOrParseInValidString() {
      let hogeOrFooT = $.or(hogeT, fooT)
      let manyHogeOrFooT = $.many(hogeOrFooT)
      let testStr = "hogfohogfo"
  
      let real = manyHogeOrFooT.resolve(testStr)
      let expect = ScanFalse(target: testStr, index: 0)
      assert(real, expect)
    }


  func testCharParseValidString() {
    let alphaStr = "abcdefghijklmnopqrstuvwxyz"
    let alphaT = $.char(alphaStr)

    let testStrList = alphaStr.characters.map({ String($0)})
    let tuples = testStrList.map({
      ($0, ScanTrue(target: $0, index: $0.characters.count, data: [$0], params: [:]) as ScanResult)
    })
    execTest(tuples, scanner: alphaT)
  }

  func testCharParseInValidString() {
    let alphaStr = "abcdefghijklmnopqrstuvwxyz"
    let alphaT = $.char(alphaStr)

    let testStrList = "0123456789!@#$%^&*()_+|[]{}'/?!,.<>".characters.map({ String($0) })
    let tuples = testStrList.map({
      ($0, ScanFalse(target: $0, index: 0) as ScanResult )
    })
    //execTest(tuples, scanner: alphaT)
    for (tag, expect) in tuples {
      let real = alphaT.resolve(tag)
      XCTAssertEqual(real.target, expect.target)
      XCTAssertEqual(real.isSuccess, expect.isSuccess)
      XCTAssertEqual(real.index, expect.index)
      XCTAssertEqual(real.data, expect.data)
    }
  }
}




