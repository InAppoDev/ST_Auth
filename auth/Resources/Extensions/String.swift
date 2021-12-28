//
//  String.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//

import UIKit

extension String {
	mutating func removeWhiteSpace() {
		guard let indexWhiteSpace = self.firstIndex(of: " ") else { return }
		self.remove(at: indexWhiteSpace)
	}
}

extension String {
	 var localizeString: Self {
		return NSLocalizedString(self, comment: "")
	}
}


extension StringProtocol {
	func distance(of element: Element) -> Int? { firstIndex(of: element)?.distance(in: self) }
	func distance<S: StringProtocol>(of string: S) -> Int? { range(of: string)?.lowerBound.distance(in: self) }
}

extension Collection {
	func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

extension String.Index {
	func distance<S: StringProtocol>(in string: S) -> Int { string.distance(to: self) }
}

