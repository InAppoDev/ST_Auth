//
//  SpiningCircleView.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//

import UIKit

class SpiningCircleView: UIView {
	
	let backgroundSpinigCircle = CAShapeLayer()
	let spiningCircle = CAShapeLayer()
	
	var timer: Timer?

	override init(frame: CGRect) {
		super.init(frame: frame)

		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configure() {
		frame = CGRect(x: 0, y: 0, width: 35, height: 35)
		
		let rect = self.bounds
		let circularPath = UIBezierPath(ovalIn: rect)
		
		backgroundSpinigCircle.path = circularPath.cgPath
		backgroundSpinigCircle.fillColor = UIColor.clear.cgColor
		backgroundSpinigCircle.strokeColor = UIColor.gray.cgColor
		backgroundSpinigCircle.lineWidth = 5
		backgroundSpinigCircle.strokeEnd = 1
		backgroundSpinigCircle.lineCap = .round

		spiningCircle.path = circularPath.cgPath
		spiningCircle.fillColor = UIColor.clear.cgColor
		spiningCircle.strokeColor = UIColor.white.cgColor
		spiningCircle.lineWidth = 5
		spiningCircle.strokeEnd = 0.25
		spiningCircle.lineCap = .round
		
		self.layer.addSublayer(backgroundSpinigCircle)
		self.layer.addSublayer(spiningCircle)
		
	}
	
	func startIndicator() {
		if timer == nil {
			timer = Timer.scheduledTimer(timeInterval:0.0, target: self, selector: #selector(self.animate), userInfo: nil, repeats: false)
		}
	}
	
	func stopIndicator() {
			timer?.invalidate()
			timer = nil
		}
	
	@objc func animate() {
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
			self.transform = CGAffineTransform(rotationAngle: .pi)
		} completion: { completed in
			UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
				self.transform = CGAffineTransform(rotationAngle: 0)
			} completion: { completed in
				if self.timer != nil {
					self.timer = Timer.scheduledTimer(timeInterval:0.0, target: self, selector: #selector(self.animate), userInfo: nil, repeats: false)
				}
			}
			
		}
		
	}
}

