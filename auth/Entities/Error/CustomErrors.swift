//
//  ResponseError.swift
//  swim-training
//
//  Created by Alexandr on 15.11.2021.
//

import UIKit
import Alamofire

enum CustomErrors: Error {
	case wrongPhone
	case wrongPassword
	case noInternet
	case error
	case accountWithThisEmailAlreadyExists
	case accountWithSuchPhoneAlreadyExists
}

extension CustomErrors {
	var description: String {
		switch self {
		case .wrongPhone:
			return "WrongPhone".localizeString
		case .wrongPassword:
			return "WrongPassword".localizeString
		case .noInternet:
			return "NoInternet".localizeString
		case .error:
			return "Error".localizeString
		case .accountWithThisEmailAlreadyExists:
			return "AccountWithThisEmailAlreadyExists".localizeString
		case .accountWithSuchPhoneAlreadyExists:
			return "AccountWithSuchPhoneAlreadyExists".localizeString
		}
	}
}

//MARK: - Return Error
extension CustomErrors {
	static func returnError(response: HTTPURLResponse?, error: AFError?) -> CustomErrors? {
		if let error = error?.underlyingError as? URLError {
			if error.errorCode == -1009 || error.errorCode == -1004 {
				return CustomErrors.noInternet
			}
		} 
		return nil
	}
	
	static func returnErrorAuth(modelType: ErrorModelProtocol.Type, data: Data) -> CustomErrors {

		if modelType is LoginErrorModel.Type {
			let error = CustomErrors.returnLoginError(data: data)
			return error
		} else if modelType is RegisterErrorModel.Type {
			let error = CustomErrors.returnRegisterError(data: data)
			return error
		}
		
		return CustomErrors.error
	
	}
	
		static	func returnLoginError(data: Data) -> CustomErrors {
		do {
			let result = try JSONDecoder().decode(LoginErrorModel.self, from: data)
			if result.phone != nil {
				return CustomErrors.wrongPhone
			} else if result.password != nil {
				return CustomErrors.wrongPassword
			} else {
				return CustomErrors.error
			}
		} catch {
			return CustomErrors.error
		}
	}
	
	static func returnRegisterError(data: Data) -> CustomErrors {
		do {
			let result = try JSONDecoder().decode(RegisterErrorModel.self, from: data)
			if result.phone != nil {
				return CustomErrors.accountWithSuchPhoneAlreadyExists
			} else if result.email != nil {
				return CustomErrors.accountWithThisEmailAlreadyExists
			} else {
				return CustomErrors.error
			}
		} catch {
			return CustomErrors.error
		}
	}
}
