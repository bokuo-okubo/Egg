//
//  Label.swift
//  Pods
//
//  Created by Yohei Okubo on 1/12/16.
//
//


public protocol Labelable {
  var name: String { get }
  var key: String { get }
}
extension Labelable {
  func add(right: Labelable) -> Label {
    return Label(name: self.name + right.name, key: self.key + right.key)
  }
}

/**
 *  Tokenのタイプ定数
 */
struct LabelTypes {
  static let EMPTY = "EMPTY"
  static let ATOM  = "ATOM"
}

public struct Label: Labelable {

  public let name: String
  public let key: String

  public init(name: String, key: String) {
    self.name = name
    self.key = key
  }

  public init(name: String) {
    self.name = name
    self.key = ""
  }

  public init() {
    self.name = ""
    self.key = ""
  }
}
