//
//  KeychainService.swift
//  Google Books
//
//  Created by Yashaswini Ashrith on 4/20/21.
//

import Foundation
import KeychainSwift

class KeychainService{
    
    var _localVar = KeychainSwift()
    
    var keyChain : KeychainSwift{
        get {
            return _localVar
        }
        set {
            _localVar = newValue
        }
    }
}
