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
    
    var finalImage: UIImage!
    var brightnessFilter: CIFilter!
    var blurFilter: CIFilter!
    var context = CIContext()
    
    func getFinalImage() -> UIImage {
        return self.finalImage
    }
    
    func setFinalImage(image: UIImage) {
        self.finalImage = image
    }
    
    func getImageFromCIImage(image: CIImage) -> UIImage? {
        return UIImage(ciImage:image, scale:1, orientation:UIImageOrientation(rawValue: 0)!)
    }
    
    func applyFilters(value: Float, mode: Int) -> UIImage {
        self.context = CIContext(options: nil)
        self.brightnessFilter = CIFilter(name: "CIColorControls")
        self.blurFilter = CIFilter(name: "CIGaussianBlur")
        if (mode == 0) {
            let temp = value * 5 + 1
            self.blurFilter.setValue(CameraOperations.camera.getBrightnessImage(), forKey: "inputImage")
            self.blurFilter.setValue(temp, forKey: "inputRadius")
            CameraOperations.camera.setBlurImage(image: self.blurFilter.outputImage!)
            self.finalImage = getImageFromCIImage(image: CameraOperations.camera.getBlurImage())!
        } else {
            self.brightnessFilter.setValue(CameraOperations.camera.getBlurImage(), forKey: "inputImage")
            self.brightnessFilter.setValue(value/2.0, forKey: "inputBrightness")
            CameraOperations.camera.setBrightnessImage(image: self.brightnessFilter.outputImage!)
            self.finalImage = getImageFromCIImage(image: CameraOperations.camera.getBrightnessImage())!
        }
        return self.finalImage
    }

}
