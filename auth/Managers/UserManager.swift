//
//  UserManager.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//


import Foundation
import SwiftKeychainWrapper


final class UserManager {
	
	static let shared = UserManager()
	
	private init() {}
	
	lazy var userToken: String? = {
		return KeychainWrapper.returnValueIfExistsOrReturnNil(key: "userToken")
	}() {
		didSet {
			if let apiToken = userToken {
				KeychainWrapper.standard.set(apiToken, forKey: "userToken")
			}
			if userToken == nil {
				KeychainWrapper.standard.removeObject(forKey: "userToken")
			}
		}
	}
	
	lazy var userAccountID: Int? = {
		return KeychainWrapper.returnIntegerValueIfExistsOrReturnNil(key: "userAccountID")
	}() {
		didSet {
			if let accountID = userAccountID {
				KeychainWrapper.standard.set(accountID, forKey: "userAccountID")
			}
			if userAccountID == nil {
				KeychainWrapper.standard.removeObject(forKey: "userAccountID")
			}
		}
	}
	
	func isLoggedIn() -> Bool {
		return userToken != nil
	}
	
	func logout() {
		userToken = nil
		userAccountID = nil
	}
}





