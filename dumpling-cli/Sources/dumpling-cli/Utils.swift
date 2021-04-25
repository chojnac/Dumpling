//
//  Utils.swift
//  
//
//  Created by Wojciech Chojnacki on 22/04/2021.
//

import Foundation

extension FileHandle: TextOutputStream {
  public func write(_ string: String) {
    self.write(string.data(using: .utf8)!)
  }
}
