//
//  Constants.swift
//  st_auth
//
//  Created by Alexandr on 24.12.2021.
//

import UIKit

struct Constats {
	struct GoogleSigIn {
		static let clientID = "1083839777608-1vc85gna7c69j12rvgqn7c3eaaqeg3pe.apps.googleusercontent.com"
		static let serverClientID = "1083839777608-v0bqn6knuu92sdv2hkc25qlud5a15jdc.apps.googleusercontent.com"
	}
	
	struct Facebook {
		static let appID = "472717030602557"
	}
	
	struct VK {
		static let appId = "7847525"
	}

	struct Colors {
		static let topGradientColor: UIColor = UIColor(red: 190/255, green: 5/255, blue: 60/255, alpha: 1)
		static let bottomGradientColor: UIColor = UIColor(red: 233/255, green: 53/255, blue: 106/255, alpha: 1)
	}

	struct Language {
		static var systemLanguage: String {
			return NSLocale.current.languageCode ?? ""
		}
	}
}

