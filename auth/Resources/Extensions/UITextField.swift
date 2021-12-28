//
//  UITextField.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//

import UIKit

extension UITextField {
	func addAlertView() {
		let view = UIView()
		view.backgroundColor = .systemRed
		
		let label = UILabel()
		label.text = "!"
		label.textAlignment = .center
		label.backgroundColor = .clear
		label.textColor = .white
		label.font = .systemFont(ofSize: 20)
		view.addSubview(label)

		let height = self.frame.height / 2
		view.frame = CGRect(x: 0, y: 0, width: 25, height: height)
		view.layer.masksToBounds = true
		view.layer.cornerRadius = height / 2
		label.frame = view.frame
		
		self.rightView = view
		self.rightViewMode = .always
	}
	
	func removeRightView() {
		self.rightView = nil
	}
}
