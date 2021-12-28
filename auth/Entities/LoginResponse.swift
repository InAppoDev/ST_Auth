//
//  UserResponse.swift
//  swim-training
//
//  Created by Alexandr on 04.11.2021.
//

import Foundation

struct LoginResponse: Codable {
	let token: String
	let accountID: Int
	
	enum CodingKeys: String, CodingKey {
		case token
		case accountID = "account_id"
	}
}
