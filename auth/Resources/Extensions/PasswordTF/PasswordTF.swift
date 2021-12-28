//
//  PasswordTF.swift
//  swim-training
//
//  Created by Alexandr on 13.11.2021.
//

import Foundation
import UIKit

class PasswordTF: UITextField {
	
	private let padding = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 10)
	
	let button = UIButton(type: .system)
	
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
	
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		let image = UIImage(named: "showPassword")
		button.addTarget(self, action: #selector(showPassword(button:)), for: .touchUpInside)
		button.setImage(image, for: .normal)
		rightView = button
		rightView?.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
		rightViewMode = .always
	}

	func addAlertViewPassword() {
		let passwordView = PasswordRView()
		passwordView.buttonOutlet.addTarget(self, action: #selector(showPassword(button:)), for: .touchUpInside)
		passwordView.frame = CGRect(x: 0, y: 0, width: 25, height: self.frame.height)
		rightView = passwordView
		rightViewMode = .always
	}
	
	@objc private func showPassword(button: UIButton) {
		if self.isSecureTextEntry {
			self.isSecureTextEntry = false
			button.setImage(UIImage(named: "hidePassword"), for: .normal)
		} else {
			self.isSecureTextEntry = true
			
			button.setImage(UIImage(named: "showPassword"), for: .normal)
		}
	}
	
}

