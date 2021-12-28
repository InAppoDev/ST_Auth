//
//  STRegistrationViewController.swift
//  swim-training
//
//  Created by Alexandr on 03.11.2021.
//

import UIKit

class STRegistrationViewController: UIViewController {
	//MARK: Outlets
	@IBOutlet weak var registrationButtonOutlet: GradientButton!
	
	@IBOutlet weak var nameTFOutlet: CustomTextField!
	@IBOutlet weak var lastNameTFOutlet: CustomTextField!
	@IBOutlet weak var numberPhoneTFOutlet: NumberPhoneTF!
	@IBOutlet weak var emailTFOutlet: CustomTextField!
	@IBOutlet weak var passwordTFOutlet: PasswordTF!
	@IBOutlet weak var confirmPasswordTFOutlet: PasswordTF!
	
	@IBOutlet weak var checkBoxView: CheckboxView!
	@IBOutlet weak var privacyPolicyButtonOutlet: UIButton!
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
	
	private var localUser: LocalUser?
		
	override func viewDidLoad() {
        super.viewDidLoad()
		
		beginKeyboardObserving()
		title = "RegistrationTitle".localizeString

		if imageHeightConstraint.constant < UIScreen.main.bounds.height {
			imageHeightConstraint.constant = UIScreen.main.bounds.height
			scrollView.isScrollEnabled = false
		}

		scrollView.contentInsetAdjustmentBehavior = .never
		configureButtonsTitle()
		numberPhoneTFOutlet.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		setupToolbar()
		
		let gestureForCheckbox = UITapGestureRecognizer(target: self, action: #selector(checkboxTapped))
		checkBoxView.addGestureRecognizer(gestureForCheckbox)
		privacyPolicyButtonOutlet.titleLabel?.adjustsFontSizeToFitWidth = true
		privacyPolicyButtonOutlet.titleLabel?.minimumScaleFactor = 0.5

		
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let topColor = Constats.Colors.topGradientColor
		let bottomColor = Constats.Colors.bottomGradientColor
		registrationButtonOutlet.applyGradient(topColor: topColor, bottomColor: bottomColor)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBar.compactAppearance = nil
		navigationController?.navigationBar.scrollEdgeAppearance = nil
	}
	
	override func keyboardWillShow(withHeight keyboardHeight: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {

		scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height + 100)
		scrollView.isScrollEnabled = true

		let gestureResignFirstResponder = UITapGestureRecognizer(target: self, action: #selector(gestureResignFirstResponderHandler))
		view.addGestureRecognizer(gestureResignFirstResponder)
	}
	
	override func keyboardWillHide(withDuration duration: TimeInterval, options: UIView.AnimationOptions) {
		
	}
	

	func isValidEmail(_ email: String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: email)
	}
	
	func isValidPhone(phone: String?) -> Bool {
		guard let phone = phone else { return false }

			let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
			let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
			return phoneTest.evaluate(with: phone)
		}
	
	func isValidPassword(userPassword : String) -> Bool {
		let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[A-Z]).{6,}$")
		
		return password.evaluate(with: userPassword)
	}
	
	//MARK: Actions
	@IBAction func signUpButtonTapped(_ sender: GradientButton) {
		guard checkBoxView.isChecked else {
			showAlertController(title: "AgreePrivacyPolicyAlertText".localizeString, message: "")
			return
		}
		
		guard let name = nameTFOutlet.text, !name.isEmpty else {
			showAlertController(title: "EnterYourNameTitle".localizeString, message: "")
			nameTFOutlet.addAlertView()
			return
		}
		nameTFOutlet.removeRightView()
		
		guard let lastName = lastNameTFOutlet.text, !lastName.isEmpty else {
			showAlertController(title: "InputLastNameAlertTitle".localizeString, message: "")
			lastNameTFOutlet.addAlertView()
			return
		}
		lastNameTFOutlet.removeRightView()
		
		guard let numberPhone = numberPhoneTFOutlet.text, !numberPhone.isEmpty, isValidPhone(phone: numberPhone) else {
			showAlertController(title: "WrongPhoneAlertText".localizeString, message: "")
			numberPhoneTFOutlet.addAlertView()
			return
		}
		numberPhoneTFOutlet.removeRightView()
		
		guard let email = emailTFOutlet.text, !email.isEmpty, isValidEmail(email) else {
			showAlertController(title: "WrongEmailAlertTitle".localizeString, message: "")
			emailTFOutlet.addAlertView()
			return
		}
		emailTFOutlet.removeRightView()
		
		guard let password = passwordTFOutlet.text, !password.isEmpty, isValidPassword(userPassword: password) else {
			showAlertController(title: "WrongPasswordAlertText".localizeString, message: "")
			passwordTFOutlet.addAlertViewPassword()
			return
		}
		passwordTFOutlet.removeRightView()
		
		guard let confirimPassword = confirmPasswordTFOutlet.text, !confirimPassword.isEmpty, password == confirimPassword else {
			showAlertController(title: "WrongPasswordAlertText".localizeString, message: "")
			confirmPasswordTFOutlet.addAlertViewPassword()
			return
		}
		confirmPasswordTFOutlet.removeRightView()
		
		let countryCode = numberPhoneTFOutlet.phoneView.phoneView.selectedCountry.phoneCode
		let phoneNumber = countryCode + numberPhone
		
		SpiningManager.shared.startIndicator()
		
		LocalNetworkManager.shared.register(name: name, lastName: lastName, phoneNumber: phoneNumber, email: email, password: password, confirmPassword: confirimPassword) { [weak self] result, error in
			
			SpiningManager.shared.stopIndicator()
			
			guard let result = result, error == nil else {
				self?.showAlertController(title: error?.description ?? "", message: "")
				return
			}
			self?.localUser = LocalUser(token: result.token, accountID: result.accountID)
			UserManager.shared.userToken = self?.localUser?.token
			UserManager.shared.userAccountID = self?.localUser?.accountID
			
			self?.showAlertController(title: "Success".localizeString, message: "")
		}
	}

	@IBAction func privacyPolicyButtonTapped(_ sender: UIButton) {
		let webView = STWebViewController(urlString: URLRequests.privacyPolicy.rawValue)
		webView.modalPresentationStyle = .fullScreen
		self.present(webView, animated: true)
	}
	@objc func checkboxTapped() {
		checkBoxView.toggle()
	}

	@objc func showConfirmPasswordTapped(button: UIButton) {
		if confirmPasswordTFOutlet.isSecureTextEntry {
			confirmPasswordTFOutlet.isSecureTextEntry = false
			button.setImage(UIImage(named: "hidePassword"), for: .normal)
		} else {
			confirmPasswordTFOutlet.isSecureTextEntry = true
			button.setImage(UIImage(named: "showPassword"), for: .normal)
		}
	}
}

//MARK: - UITextFieldDelegate
extension STRegistrationViewController: UITextFieldDelegate {
	@objc private func gestureResignFirstResponderHandler() {
		if let firstResponder = view.window?.firstResponder as? UITextField {
			firstResponder.resignFirstResponder()
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
			 nextField.becomeFirstResponder()
		 } else {
			 textField.resignFirstResponder()
		 }
		 return false
	}

	@objc func textFieldDidChange(_ textField: UITextField) {

		if textField.text!.count > 9 {
			textField.text?.removeLast()
		}
	}
	
	func setupToolbar(){
		let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
		let nextButton = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(nextTF(textField:)))
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		
		bar.items = [flexSpace, flexSpace, nextButton]
		bar.sizeToFit()
		
		numberPhoneTFOutlet.inputAccessoryView = bar
	}
	
	@objc func nextTF(textField: UITextField){
		emailTFOutlet.becomeFirstResponder()
	}
	 
}

//MARK: - Configure Buttons Title
private extension STRegistrationViewController {
	func configureButtonsTitle() {
		nameTFOutlet.placeholder = "NameTitle".localizeString
		lastNameTFOutlet.placeholder = "LastNameTitle".localizeString
		numberPhoneTFOutlet.placeholder = "NumberPhonePlaceholderTF".localizeString
		emailTFOutlet.placeholder = "EmailPlaceholderTF".localizeString
		passwordTFOutlet.placeholder = "PasswordPlaceholderTF".localizeString
		confirmPasswordTFOutlet.placeholder = "ConfirmPasswordPlaceholderTF".localizeString
		registrationButtonOutlet.setTitle("RegistrationButtonTtitle".localizeString, for: .normal)
	}
}
