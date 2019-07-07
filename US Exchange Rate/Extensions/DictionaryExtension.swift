//
//  DictionaryExtension.swift
//  US Exchange Rate
//
//  Created by Junior Etrata on 7/3/19.
//  Copyright © 2019 Junior Etrata. All rights reserved.
//

import Foundation

extension Dictionary {
   subscript(i:Int) -> (key:Key,value:Value) {
      get {
         return self[index(startIndex, offsetBy: i)];
      }
   }
}
