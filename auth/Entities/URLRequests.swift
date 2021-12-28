//
//  STUrls.swift
//  swim-training
//
//  Created by Alexandr on 04.11.2021.
//

import Foundation

enum URLRequests: String {
	case baseUrl
	case login
	case register
	case googleSigIn
	case vkLogin
	case fbSigIn

	case privacyPolicy
}

extension URLRequests {
	var rawValue: String {
		switch self {
		case .baseUrl:
			return "http://188.227.16.13/api/v3/"
		case .login:
			return URLRequests.baseUrl.rawValue + "login/"
		case .register:
			return URLRequests.baseUrl.rawValue + "accounts/account/register/"
		case .googleSigIn:
			return URLRequests.baseUrl.rawValue + "social/google/"
		case .vkLogin:
			return URLRequests.baseUrl.rawValue + "social/vk/"
		case .fbSigIn:
			return URLRequests.baseUrl.rawValue + "social/facebook/"
		case .privacyPolicy:
			return "https://swimtraining.info/privacy-policy/"
		}
	}
}
