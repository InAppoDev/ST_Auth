//
//  NumberPhoneTF.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//

import UIKit
import NMLocalizedPhoneCountryView

class NumberPhoneTF: UITextField, PhoneViewDelegate {
	var textFied: NumberPhoneTF {
		return self
	}
	
	let phoneView = PhoneView()
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		phoneView.phoneViewDelegate = self
		leftView = phoneView
		leftViewMode = .always
	}
	
	override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.rightViewRect(forBounds: bounds)
		rect.origin.x += -16
		return rect
	}
}
