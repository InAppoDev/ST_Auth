//
//  LocalUser.swift
//  st_auth
//
//  Created by Alexandr on 24.12.2021.
//

import Foundation

struct LocalUser: Codable {
	let token: String
	let accountID: Int

	enum CodingKeys: String, CodingKey {
		case token
		case accountID = "account_id"
	}
}
