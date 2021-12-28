//
//  ErrorData.swift
//  swim-training
//
//  Created by Alexandr on 15.11.2021.
//

import Foundation

struct LoginErrorModel: Codable, ErrorModelProtocol {
	var phone: [String]?
	var password: [String]?
}
