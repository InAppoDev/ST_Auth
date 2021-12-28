//
//  CheckboxView.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//

import UIKit

class CheckboxView: UIView {

	var isChecked = false
	
	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.tintColor = .systemBlue
		imageView.contentMode = .scaleAspectFit
		imageView.image = UIImage(systemName: "checkmark")
		
		return imageView
	}()

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		
		if isChecked {
			checkedState()
		} else {
			uncheckedState()
		}
		
		addSubview(imageView)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.layer.cornerRadius = 2
		imageView.frame = CGRect(x: -0, y: 0, width: frame.size.width, height: frame.size.width)
	}
	
	func toggle() {
		self.isChecked = !isChecked
		
		if isChecked {
			checkedState()
		} else {
			uncheckedState()
		}
	}
	
	private func uncheckedState() {
		UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
			self.imageView.isHidden = true
			self.layer.borderWidth = 3
			self.layer.borderColor = UIColor.white.cgColor
			self.backgroundColor = .clear
		}
	}
	
	private func checkedState() {
		UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
			self.imageView.isHidden = false
			self.layer.borderWidth = 0
			self.layer.borderColor = nil
			self.backgroundColor = .white
		}
	}
}
