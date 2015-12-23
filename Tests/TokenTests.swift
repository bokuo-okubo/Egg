//
//  EggTest.swift
//  agent-ios
//
//  Created by Yohei Okubo on 12/21/15.
//  Copyright © 2015 bko. All rights reserved.
//

import XCTest
@testable import Egg

/* test class */
class TokenTest: EggTestBase {

  /* test basic token */
  typealias $ = Egg

  private let HogeT = $.tokenize("hoge")
  private let FooT = $.tokenize("foo")

  /* token test */
  func testTokenParseValidString() {

    let expect = TokenResult(
      isSuccess: true,
      index: "hoge".characters.count,
      tokenized: ["hoge"]
    )

    let testList = [
      "hoge",
      "hogepiyo",
      ].map({ ($0, expect)})

    execTest(testList, token: HogeT)
  }

  func testTokenParseInValidString() {

    let expect = TokenResult(
      isSuccess: false,
      index: 0,
      tokenized: []
    )

    let testList = [
      "foobar",
      "3hoge",
      "ho--ge"
      ].map({ ($0, expect)})

    execTest(testList, token: HogeT)
  }

//  /* or test */
//  func testOrTokenParseValidString() {
//
//    let HogeOrFooT = $.or(HogeT, FooT)
//
//    let eHoge = TokenResult(true, ["hoge"], "hoge".characters.count)
//    let eFoo = TokenResult(true, ["foo"], "foo".characters.count)
//
//    let testList = [
//      ("hoge", eHoge),
//      ("foo", eFoo),
//      ("hogefoo", eHoge),
//      ("foohoge", eFoo)
//    ]
//    execTest(testList,token: HogeOrFooT)
//  }
//  
//  func testOrTokenParseIvalidString() {
//
//    let HogeOrFooT = $.or(HogeT, FooT)
//
//    let expect = expectFail
//
//    let testList = [
//      "ugaa",
//      "hogfoo",
//      "fohoge",
//      ].map({ ($0, expect)})
//
//    execTest(testList,token: HogeOrFooT)
//  }
//
//  /**
//   NotHogeTのテスト
//   "hoge"以外ならtrue
//  */
//  func testNotTokenParseValidString() {
//
//    let NotHogeT = $.not(HogeT)
//
//    let testList = [
//      "foo",
//      "あいうえお",
//      "0123456"
//      ].map({ ($0, TokenResult(true, [], $0.characters.count)) })
//
//    execTest(testList,token: NotHogeT)
//  }
//
//  func testNotTokenParseIvalidString() {
//
//    let NotHogeT = $.not(HogeT)
//
//    let expect = TokenResult(false, [], 0)
//
//    let testList = [("hoge", expect)]
//
//    execTest(testList,token: NotHogeT)
//  }
//
//  /**
//   Sequenceのテスト
//   */
//  func testSeqTokenParseValidString() {
//    let HogeFooT = $.seq(HogeT, FooT)
//    let real = HogeFooT.resolve("hogefoo")
//    let expect = TokenResult(true, ["hoge", "foo"], 7)
//    assert(real, expect)
//  }
//
//  func testSeqTokenParseInvalidString() {
//
//    let HogeFooT = $.seq(HogeT, FooT)
//
//    let testList = [
//      "hoge",
//      "foo",
//      "hogfoo",
//      "foohog"
//      ].map({ ($0, expectFail )})
//    execTest(testList, token: HogeFooT)
//  }
//
//  /**
//   EofTのテスト
//   */
//  func testEOFTokenParseValidString() {
//
//    // execTest(<#T##targetStrExpectList: [(String, TokenResult)]##[(String, TokenResult)]#>, token: <#T##Token#>)
//  }
//
//  func testEOFTokenParseInvalidString() {
//    // execTest(<#T##targetStrExpectList: [(String, TokenResult)]##[(String, TokenResult)]#>, token: <#T##Token#>)
//  }
//
}
