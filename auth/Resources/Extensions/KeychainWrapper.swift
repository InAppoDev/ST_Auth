//
//  KeychainWrapper.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//

import Foundation
import SwiftKeychainWrapper

extension KeychainWrapper {
	static func returnValueIfExistsOrReturnNil(key: String) -> String? {
		if KeychainWrapper.standard.hasValue(forKey: key) == true {
			if let value = KeychainWrapper.standard.string(forKey: key) {
				return value
			}
		}
		return nil
	}
}

extension KeychainWrapper {
	static func returnIntegerValueIfExistsOrReturnNil(key: String) -> Int? {
		if KeychainWrapper.standard.hasValue(forKey: key) == true {
			if let value = KeychainWrapper.standard.integer(forKey: key) {
				return value
			}
		}
		return nil
	}
}
