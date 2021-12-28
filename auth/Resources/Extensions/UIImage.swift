//
//  UIImage.swift
//  auth
//
//  Created by Alexandr on 28.12.2021.
//


import UIKit

//MARK: - Scale Image For Upload
extension UIImage {
	var scaledToSafeUploadSize: UIImage? {
	  let maxImageSideLength: CGFloat = 480
	  
	  let largerSide: CGFloat = max(size.width, size.height)
	  let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
	  let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
	  
	  return image(scaledTo: newImageSize)
	}
	
	func image(scaledTo size: CGSize) -> UIImage? {
	  defer {
		UIGraphicsEndImageContext()
	  }
	  
	  UIGraphicsBeginImageContextWithOptions(size, true, 0)
	  draw(in: CGRect(origin: .zero, size: size))

	  return UIGraphicsGetImageFromCurrentImageContext()
	}
}

//MARK: - Get Encoded String
public extension UIImage {
	func base64Encode() -> String? {
		
		guard let scaledImage = self.scaledToSafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return nil }
		
		let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
		let fullBase64String = "data:image/png;base64,\(base64String))"
		
		return fullBase64String
	}
}


