//
//  RegisterErrorData.swift
//  swim-training
//
//  Created by Alexandr on 15.11.2021.
//

import Foundation

protocol ErrorModelProtocol {}

struct RegisterErrorModel: Codable, ErrorModelProtocol {
	let phone: [String]?
	let email: [String]?
}
