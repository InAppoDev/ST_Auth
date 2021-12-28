//
//  UIViewController.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//

import UIKit

//MARK: - ShowAlert
extension UIViewController {
	func showAlertController(title: String, message: String, preferredStyle: UIAlertController.Style = .alert, comppletion: (() -> Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
		alert.addAction(.init(title: "OK", style: .default, handler: { _ in
			comppletion?()
		}))
		self.present(alert, animated: true)
	}
}

//MARK: - Keyboard
extension UIViewController {
	
	func beginKeyboardObserving() {
		endKeyboardObserving()
		let center = NotificationCenter.default
		center.addObserver(self, selector: #selector(willShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		center.addObserver(self, selector: #selector(willHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
		center.addObserver(self, selector: #selector(willChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
	}
	
	func endKeyboardObserving() {
		let center = NotificationCenter.default
		center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
		center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		center.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
	}
	
	@objc private func willShow(_ notification: Notification) {
		let info = notification.userInfo!
		let kbHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
		let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
		let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt

		keyboardWillShow(withHeight: kbHeight, duration: duration, options: UIView.AnimationOptions(rawValue: curve))
	}
	
	@objc private func willChangeFrame(_ notification: Notification) {
		let info = notification.userInfo!
		let height = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
		let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
		let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
		let options = UIView.AnimationOptions(rawValue: curve)
		keyboardWillChangeFrame(to: height, withDuration: duration, options: options)
	}
	
	@objc private func willHide(_ notification: Notification) {
		let info = notification.userInfo!
		let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
		let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
		let options = UIView.AnimationOptions(rawValue: curve)
		keyboardWillHide(withDuration: duration, options: options)
	}
	
	@objc func keyboardWillShow(withHeight keyboardHeight: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
		
	}
	
	@objc func keyboardWillHide(withDuration duration: TimeInterval, options: UIView.AnimationOptions) {
		
	}
	
	@objc func keyboardWillChangeFrame(to keyboardHeight: CGFloat, withDuration duration: TimeInterval, options: UIView.AnimationOptions) {
		
	}
	
}

