//
//  GradientButton.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//

import UIKit

class GradientButton: UIButton {
	func applyGradient(topColor: UIColor, bottomColor: UIColor) {
		self.backgroundColor = nil
		self.layoutIfNeeded()
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
		gradientLayer.startPoint = CGPoint(x: 0, y: 0)
		gradientLayer.endPoint = CGPoint(x: 1, y: 0)
		gradientLayer.frame = self.bounds
		gradientLayer.cornerRadius = 4
		
		gradientLayer.masksToBounds = false
		
		self.layer.insertSublayer(gradientLayer, at: 0)
	}
}
