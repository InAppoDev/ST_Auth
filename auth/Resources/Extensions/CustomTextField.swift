//
//  CustomTextField.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//

import UIKit

class CustomTextField: UITextField {

	let padding = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 10)

	override open func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

	override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}

	override open func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}
	
	override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.rightViewRect(forBounds: bounds)
		rect.origin.x += -16
		return rect
	}
}
