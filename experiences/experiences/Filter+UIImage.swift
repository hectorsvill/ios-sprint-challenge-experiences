//
//  Filter+UIImage.swift
//  experiences
//
//  Created by Hector Steven on 7/12/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit


extension UIImage {
	func myCIColorControlsFilter(image: UIImage) -> UIImage{
		let filter = CIFilter(name: "CIColorControls")
		let context = CIContext(options: nil)
		
		guard let cgImage = image.cgImage else { return image}
		let ciImage = CIImage(cgImage: cgImage)
		filter?.setValue(ciImage, forKey: kCIInputImageKey)
		filter?.setValue(1.05, forKey: kCIInputSaturationKey)
		filter?.setValue(1, forKey: kCIInputBrightnessKey)
		filter?.setValue(3, forKey:  kCIInputContrastKey)
		
		guard let outputImage = filter?.outputImage else {
			NSLog("error")
			return image
		}
		
		guard let outputCGImage = context.createCGImage(outputImage,from: outputImage.extent) else { return image }
		
		return UIImage(cgImage: outputCGImage)
	}
	
}