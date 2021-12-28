//
//  PasswordRView.swift
//  swim-training
//
//  Created by Alexandr on 10.12.2021.
//

import UIKit

class PasswordRView: ViewFromXib {
	@IBOutlet weak var label: UILabel!
	
	@IBOutlet weak var buttonOutlet: UIButton!
	@IBAction func buttonTapped(_ sender: UIButton) {
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()

		label.layer.cornerRadius = self.frame.height / 2
		label.layer.masksToBounds = true
	}
}
