//
//  STLoginViewController.swift
//  swim-training
//
//  Created by Developer on 02.11.2021.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import VK_ios_sdk
import NMLocalizedPhoneCountryView

class STLoginViewController: UIViewController {
	//MARK: Outlets
	@IBOutlet weak var authorizationLabelOutlet: UILabel!
	@IBOutlet weak var loginButtonOutlet: GradientButton!
	@IBOutlet weak var registrationButtonOutlet: UIButton!
	@IBOutlet weak var signInWithGoogleButtonOutlet: UIButton!
	@IBOutlet weak var signInWithVkButtonOutlet: UIButton!
	@IBOutlet weak var signInWithFBButtonOutlet: UIButton!
	
	@IBOutlet weak var passwordTFOutlet: PasswordTF!
	@IBOutlet weak var checkboxView: CheckboxView!
	@IBOutlet weak var numberPhoneTFOutlet: NumberPhoneTF!
	
	@IBOutlet weak var privacyPolicyButtonOutlet: UIButton!
	
	@IBOutlet weak var imageOutlet: UIView!
	@IBOutlet weak var scrollViewOutlet: UIScrollView!
	@IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
	
	//MARK: Properties
	private var localUser: LocalUser?
	private var vkSDK: VKSdk!
	//MARK: Methods
	override func viewDidLoad() {
        super.viewDidLoad()
		
		beginKeyboardObserving()

		if imageHeightConstraint.constant < UIScreen.main.bounds.height {
			imageHeightConstraint.constant = UIScreen.main.bounds.height
			scrollViewOutlet.isScrollEnabled = false
		}
		scrollViewOutlet.contentInsetAdjustmentBehavior = .never
		
		let gestureForCheckbox = UITapGestureRecognizer(target: self, action: #selector(checkboxTapped))
		checkboxView.addGestureRecognizer(gestureForCheckbox)
		
		configureButtonaTitle()
		setupLocalize()
		setupToolbar()
		numberPhoneTFOutlet.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let topColor = Constats.Colors.topGradientColor
		let bottomColor = Constats.Colors.bottomGradientColor
		loginButtonOutlet.applyGradient(topColor: topColor, bottomColor: bottomColor)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		let appearance = UINavigationBarAppearance()
		appearance.backgroundColor = UIColor(red: 30/255, green: 82/255, blue: 143/255, alpha: 1)
		appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		navigationController?.navigationBar.compactAppearance = appearance
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.scrollEdgeAppearance = appearance
		navigationController?.navigationBar.tintColor = .white

	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBar.compactAppearance =  nil
		navigationController?.navigationBar.scrollEdgeAppearance =  nil
		navigationController?.navigationBar.standardAppearance = UINavigationBarAppearance()
	}
	
	override func keyboardWillShow(withHeight keyboardHeight: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {

		let gestureResignFirstResponder = UITapGestureRecognizer(target: self, action: #selector(gestureResignFirstResponderHandler))
		view.addGestureRecognizer(gestureResignFirstResponder)
	}
	
	func isValidPhone(phone: String?) -> Bool {
		guard let phone = phone else { return false }

			let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
			let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
			return phoneTest.evaluate(with: phone)
		}

	func configureButtonaTitle() {
		signInWithFBButtonOutlet.titleLabel?.numberOfLines = 0
		signInWithFBButtonOutlet.titleLabel?.textAlignment = .center
		
		signInWithVkButtonOutlet.titleLabel?.numberOfLines = 0
		signInWithVkButtonOutlet.titleLabel?.textAlignment = .center

		privacyPolicyButtonOutlet.titleLabel?.adjustsFontSizeToFitWidth = true
		privacyPolicyButtonOutlet.titleLabel?.minimumScaleFactor = 0.5
	}

	//MARK: Actions
	@IBAction func signInButtonTapped(_ sender: GradientButton) {
		guard checkboxView.isChecked else {
			showAlertController(title: "AgreePrivacyPolicyAlertText".localizeString, message: "")
			return
		}
		
		guard let numberPhone = numberPhoneTFOutlet.text, !numberPhone.isEmpty, isValidPhone(phone: numberPhone) else {
			showAlertController(title: "WrongPhoneAlertText".localizeString, message: "")
			numberPhoneTFOutlet.addAlertView()
			return
		}
		numberPhoneTFOutlet.removeRightView()
		
		guard let password = passwordTFOutlet.text, !password.isEmpty else {
			showAlertController(title: "WrongPasswordAlertText".localizeString, message: "")
			passwordTFOutlet.addAlertViewPassword()
			return
		}
		passwordTFOutlet.removeRightView()
		
		let countryCode = numberPhoneTFOutlet.phoneView.phoneView.selectedCountry.phoneCode
		let phoneNumber = countryCode + numberPhone

		SpiningManager.shared.startIndicator()
		
		LocalNetworkManager.shared.login(password: password, phone: phoneNumber) { [weak self] (result, error) in
			SpiningManager.shared.stopIndicator()
			guard let result = result, error == nil else {
				self?.showAlertController(title: error?.description ?? "Error".localizeString, message: "")
				return
			}
			self?.localUser = LocalUser(token: result.token, accountID: result.accountID)
			UserManager.shared.userToken = self?.localUser?.token
			UserManager.shared.userAccountID = self?.localUser?.accountID

//			DispatchQueue.main.async {
//				UIApplication.shared.windows.first?.rootViewController = STUserTrainingLevel()
//			}
		}
	}
	
	@IBAction func registrationButtonTapped(_ sender: UIButton) {
		let vc = STRegistrationViewController()
		self.navigationController?.pushViewController(vc, animated: true)
	}

	@IBAction func privacyPolicyButtonTapped(_ sender: UIButton) {
		let webView = STWebViewController(urlString: URLRequests.privacyPolicy.rawValue)
		webView.modalPresentationStyle = .fullScreen
		self.present(webView, animated: true)
	}
	
	@objc func checkboxTapped() {
		checkboxView.toggle()
	}

	@IBAction func signInWithGoogleTapped(_ sender: UIButton) {
		guard checkboxView.isChecked else {
			showAlertController(title: "AgreePrivacyPolicyAlertText".localizeString, message: "")
			return
		}

		let signInConfig = GIDConfiguration.init(clientID: Constats.GoogleSigIn.clientID, serverClientID: Constats.GoogleSigIn.serverClientID)
		
		GIDSignIn.sharedInstance.restorePreviousSignIn()
		
		GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { [weak self] user, error in
			guard let user = user, error == nil, let serverAuthCode = user.serverAuthCode else { return }
			SpiningManager.shared.startIndicator(viewController: self)
			LocalNetworkManager.shared.googleSigIn(token: serverAuthCode) {  (result, error) in
				SpiningManager.shared.stopIndicator()
				guard let result = result, error == nil else {
					self?.showAlertController(title: "AuthError".localizeString, message: "")
					return
				}
				self?.localUser = LocalUser(token: result.token, accountID: result.accountID)
				UserManager.shared.userToken = self?.localUser?.token
				UserManager.shared.userAccountID = self?.localUser?.accountID

				self?.showAlertController(title: "Success".localizeString, message: "")
			}
		 }		 
	}
	
	@IBAction func signInWithVkTapped(_ sender: UIButton) {
		guard checkboxView.isChecked else {
			showAlertController(title: "AgreePrivacyPolicyAlertText".localizeString, message: "")
			return
		}
		
		vkSDK = VKSdk.initialize(withAppId: Constats.VK.appId)
		vkSDK?.uiDelegate = self
		vkSDK?.register(self)
		VKSdk.forceLogout()
		
		VKSdk.wakeUpSession(["email"]) { state, error in
			switch state {
			case .initialized:
				VKSdk.authorize(["email"])
			case .authorized:
				VKSdk.forceLogout()
				VKSdk.authorize(["email"])
				print("authorized")
			case .error:
				self.showAlertController(title: error!.localizedDescription, message: "")
			default: return
			}
		}
	}
	
	@IBAction func signInWithFBTapped(_ sender: UIButton) {
		guard checkboxView.isChecked else {
			showAlertController(title: "AgreePrivacyPolicyAlertText".localizeString, message: "")
			return
		}

		LoginManager().logIn(permissions: [], from: nil) { [weak self] response, error in
			guard let token = response?.token, let userId = response?.token?.userID else { return }
			
			SpiningManager.shared.startIndicator(viewController: self)
			LocalNetworkManager.shared.loginWithFB(token: token.tokenString, userId: userId) { (result, error) in
				SpiningManager.shared.stopIndicator()
				guard let result = result, error == nil else {
					self?.showAlertController(title: "AuthError".localizeString, message: "")
					return
				}
				self?.localUser = LocalUser(token: result.token, accountID: result.accountID)
				UserManager.shared.userToken = self?.localUser?.token
				UserManager.shared.userAccountID = self?.localUser?.accountID

				self?.showAlertController(title: "Success".localizeString, message: "")
			}
		}
	}
}

//MARK: - UITextFieldDelegate
extension STLoginViewController: UITextFieldDelegate {
	@objc private func gestureResignFirstResponderHandler() {
		if let firstResponder = view.window?.firstResponder as? UITextField {
			firstResponder.resignFirstResponder()
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
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
		passwordTFOutlet.becomeFirstResponder()
	}
}

//MARK: - VKSdkDelegate, VKSdkUIDelegate
extension STLoginViewController: VKSdkDelegate, VKSdkUIDelegate {
	func vkSdkShouldPresent(_ controller: UIViewController!) {
		self.present(controller, animated: true, completion: nil)
	}
	
	func vkSdkDidDismiss(_ controller: UIViewController!) {
		if localUser == nil {
			self.showAlertController(title: "AuthError".localizeString, message: "")
		}
	}
	
	func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
	}
	
	func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
		switch result {
		case .none:
			return
		case .some(let value):
			guard let token = value.token?.accessToken, let email = value.token.email else { return }
			
				SpiningManager.shared.startIndicator(viewController: self)
			LocalNetworkManager.shared.loginWithVk(token: token, email: email) { [weak self] (result, error) in
				SpiningManager.shared.stopIndicator()
				
				guard let result = result, error == nil else {
					return
				}
				self?.localUser = LocalUser(token: result.token, accountID: result.accountID)
				UserManager.shared.userToken = self?.localUser?.token
				UserManager.shared.userAccountID = self?.localUser?.accountID
				SpiningManager.shared.stopIndicator()

				self?.showAlertController(title: "Success".localizeString, message: "")
				}
			}
		}
	
	func vkSdkUserAuthorizationFailed() {
		self.showAlertController(title: "Error".localizeString, message: "")
	}
}

//MARK: - Configure Buttons Title
private extension STLoginViewController {
	 func setupLocalize() {
		 authorizationLabelOutlet.text = "AuthorizationTitle".localizeString
		 numberPhoneTFOutlet.placeholder = "NumberPhonePlaceholderTF".localizeString
		 passwordTFOutlet.placeholder = "PasswordPlaceholderTF".localizeString
		 loginButtonOutlet.setTitle("LoginButtonTitle".localizeString, for: .normal)
		 registrationButtonOutlet.setTitle("RegistrationButtonTtitle".localizeString, for: .normal)
		 signInWithGoogleButtonOutlet.setTitle("SignInWithGoogleButtonTitle".localizeString, for: .normal)
		 signInWithVkButtonOutlet.setTitle("SignInWithVkButtonTitle".localizeString, for: .normal)
		 signInWithFBButtonOutlet.setTitle("SignInWithFBButtonTitle".localizeString, for: .normal)
	}
}
