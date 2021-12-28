//
//  PhoneView.swift
//  swim-training
//
//  Created by Alexandr on 12.11.2021.
//

import NMLocalizedPhoneCountryView
import UIKit

protocol PhoneViewDelegate: AnyObject {
	var textFied: NumberPhoneTF { get }
}

class PhoneView: ViewFromXib {
	@IBOutlet weak var phoneView: NMLocalizedPhoneCountryView!
	
	weak var phoneViewDelegate: PhoneViewDelegate?

	override func setupViews() {
		phoneView.dataSource = self
		phoneView.delegate = self

//		let font: UIFont
		
//		if UIDevice().userInterfaceIdiom == .pad {
//			font = UIFont(name: "Geometria", size: 27) ?? UIFont()
//		} else {
//			font = UIFont(name: "Geometria", size: 21) ?? UIFont()
//		}
		
		
//		phoneView.normalFont = font
		phoneView.selectedCountryFontTrait = .normal
		phoneView.showCountryCodeInView = false
		phoneView.flagImageView.isHidden = true
	}
}

//MARK: - NMLocalizedPhoneCountryViewDelegate
extension PhoneView: NMLocalizedPhoneCountryViewDelegate{
	func localizedPhoneCountryView(_ localizedPhoneCountryView: NMLocalizedPhoneCountryView, didSelectCountry country: NMCountry) {
		guard let delegate = phoneViewDelegate else { return }
		delegate.textFied.layoutSubviews()
	}
}

//MARK: - NMLocalizedPhoneCountryViewDataSource
extension PhoneView: NMLocalizedPhoneCountryViewDataSource {
	func preferredCountries(in localizedPhoneCountryView: NMLocalizedPhoneCountryView) -> [NMCountry] {
		return []
	}
	
	func sectionTitleForPreferredCountries(in localizedPhoneCountryView: NMLocalizedPhoneCountryView) -> String? {
		return nil
	}
	
	func showOnlyPreferredSection(in localizedPhoneCountryView: NMLocalizedPhoneCountryView) -> Bool {
		return false
	}
	
	func navigationTitle(in localizedPhoneCountryView: NMLocalizedPhoneCountryView) -> String? {
		return ""
	}
	
	func closeButtonNavigationItem(in localizedPhoneCountryView: NMLocalizedPhoneCountryView) -> UIBarButtonItem? {
		let barButtonItem = UIBarButtonItem(title: "BackButtonTitle".localizeString, style: .done, target: self, action: nil)
		barButtonItem.tintColor = .white
		return barButtonItem
	}
	
	func searchBarPosition(in localizedPhoneCountryView: NMLocalizedPhoneCountryView) -> SearchBarPosition {
		return .tableViewHeader
	}
	
	func searchBarPlaceholderTitle(in localizedPhoneCountryView: NMLocalizedPhoneCountryView) -> String? {
		return "SearchTitle".localizeString
	}
	
	func searchBarCancelButtonTitle(in localizedPhoneCountryView: NMLocalizedPhoneCountryView) -> String? {
		return "CancelButtonTitle".localizeString
	}
	
	func showPhoneCodeInList(in localizedPhoneCountryView: NMLocalizedPhoneCountryView) -> Bool {
		return true
	}
}
