//
//  LocalNetworkManager.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//

import Foundation
import Alamofire

class LocalNetworkManager {
	static let shared = LocalNetworkManager()
	
	private init() {}
	
	private let networkManager = NetworkManager.shared
	
	//MARK: Login
	func login(password: String, phone: String, comletion: @escaping (LoginResponse?, CustomErrors?) -> Void) {
		let parameters = ["password":password, "phone":phone]
		
		networkManager.fetchData(urlString: URLRequests.login.rawValue, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: nil) { result, error in
			comletion(result, error)
		}
	}

	//MARK: SignUp
	func register(name: String, lastName: String, phoneNumber: String, email: String, password: String, confirmPassword: String, completion: @escaping (LoginResponse?, CustomErrors?) -> Void) {
		let parameters = ["firstname":name, "lastname":lastName, "phone":phoneNumber, "password":password, "password_repeat":confirmPassword, "email":email]
		networkManager.fetchData(urlString: URLRequests.register.rawValue, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default) { result, error in
			completion(result, error)
		}
	}

	
	func googleSigIn(token: String, completion: @escaping(LoginResponse?, Error?) -> Void) {
		let urlString = URLRequests.googleSigIn.rawValue + "?code=\(token)"
		networkManager.fetchData(urlString: urlString, method: .get) { result, error in
			completion(result, error)
		}
	}
	
	//MARK: FBLogin
	func loginWithFB(token: String, userId: String, completion: @escaping(LoginResponse?, Error?) -> Void) {
		let urlString = URLRequests.fbSigIn.rawValue + "?code=\(token)&user_id=\(userId)"
		networkManager.fetchData(urlString: urlString, method: .get) { result, error in
			completion(result, error)
		}
	}
	
	//MARK: LoginVk
	func loginWithVk(token: String, email: String, completion: @escaping (LoginResponse?, Error?) -> Void) {
		let urlString = URLRequests.vkLogin.rawValue + "?email=\(email)&code=\(token)"
		networkManager.fetchData(urlString: urlString, method: .get) { result, error in
			completion(result, error)
		}
	}
}
