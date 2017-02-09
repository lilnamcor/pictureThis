//
//  ImageFilters.swift
//  PictureThis
//
//  Created by Itai Reuveni on 12/24/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

final class ImageFilters: NSObject {
    
    static let filters = ImageFilters()
    
    var blurImage: CIImage!
    var brightnessFilter: CIFilter!
    var blurFilter: CIFilter!
    var context = CIContext()
    var prevBlur = 0.0
    
    override init() {
        self.context = CIContext(options: nil)
        self.brightnessFilter = CIFilter(name: "CIColorControls")
        self.blurFilter = CIFilter(name: "CIGaussianBlur")
    }
    
    func getBlurImage() -> CIImage {
        return self.blurImage
    }
    
    func setBlurImage(image: CIImage) {
        self.blurImage = image
    }
    
    func getImageFromCIImage(image: CIImage) -> UIImage? {
        return UIImage(ciImage: image)
        //return UIImage(ciImage:image, scale:1, orientation:UIImageOrientation(rawValue: 0)!)
    }
    
    func applyFilters(blurValue: Double, brightnessValue: Double, image: CIImage) -> UIImage {
        if (blurValue == 0 && brightnessValue == 0) {
            return self.getImageFromCIImage(image: image)!
        }
        var toReturn = CIImage()
        if (blurValue != prevBlur) {
            let temp = blurValue * 5 + 1
            self.blurFilter.setValue(image, forKey: "inputImage")
            self.blurFilter.setValue(temp, forKey: "inputRadius")
            self.setBlurImage(image: self.blurFilter.outputImage!)
            toReturn = self.getBlurImage()
        }
        if (brightnessValue > 0) {
            self.brightnessFilter.setValue(self.getBlurImage(), forKey: "inputImage")
            self.brightnessFilter.setValue(brightnessValue/2.0, forKey: "inputBrightness")
            toReturn = self.brightnessFilter.outputImage!
        }
        prevBlur = blurValue
        return self.getImageFromCIImage(image: toReturn)!
    }

}
