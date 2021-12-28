//
//  UIView.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//


import UIKit

//MARK: - Round Corners
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		layer.mask = mask
	}
}

//MARK: - Get First Responder
extension UIView {
	var firstResponder: UIView? {
		guard !isFirstResponder else { return self }

		for subview in subviews {
			if let firstResponder = subview.firstResponder {
				return firstResponder
			}
		}

		return nil
	}
}

