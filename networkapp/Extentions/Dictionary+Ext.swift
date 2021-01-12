//
//  Dictionary+Ext.swift
//  networkapp
//
//  Created by Boris on 12.01.2021.
//

import Foundation

extension Dictionary {
  subscript(i: Int) -> (key: Key, value: Value) {
    return self[index(startIndex, offsetBy: i)]
  }
}
