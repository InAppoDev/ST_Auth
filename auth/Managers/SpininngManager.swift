//
//  SpininngManager.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//

import UIKit

class SpiningManager {
	static let shared = SpiningManager()
	
	private init() {}
	
	var spining = SpiningCircleView()
	
	func startIndicator(viewController: UIViewController? = nil) {
		let vc: UIViewController
		
		if viewController == nil {
		guard let topVC = UIApplication.topViewController() else { return }
			vc = topVC
		} else {
			vc = viewController!
		}
		
		spining.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
		spining.center = vc.view.center
		vc.view.addSubview(spining)
		spining.startIndicator()
	}
	
	func stopIndicator() {
		spining.stopIndicator()
		spining.removeFromSuperview()
	}
}

