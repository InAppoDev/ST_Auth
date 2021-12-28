//
//  Logger.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//

import Foundation


class Logger {
	
	static let shared = Logger()
	
	private init() { }
	
	func printInDebug(_ object: Any) {
		#if DEBUG
			print(object)
		#endif
	}
	
}
