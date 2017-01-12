//
//  CameraOperations.swift
//  PictureThis
//
//  Created by Itai Reuveni on 12/24/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

final class CameraOperations: NSObject {
    
    static let camera = CameraOperations()
    
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var globalImage = CIImage()
    var blurImage = CIImage()
    var brightnessImage = CIImage()
    
    var started = false
    
    func getBlurImage() -> CIImage {
        return self.blurImage
    }
    
    func setBlurImage(image: CIImage) {
        self.blurImage = image
    }
    
    func getBrightnessImage() -> CIImage {
        return self.brightnessImage
    }
    
    func setBrightnessImage(image: CIImage) {
        self.brightnessImage = image
    }
    
    func getGlobalImage() -> CIImage {
        return self.globalImage
    }
    
    func setGlobalImage(image: CIImage) {
        self.globalImage = image
        self.blurImage = image.copy() as! CIImage
        self.brightnessImage = image.copy() as! CIImage
    }
    
    func getCameraFeed(imageView: UIImageView) {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPresetPhoto //AVCaptureSessionPreset1920x1080
        
        let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        var error : NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error == nil && captureSession?.canAddInput(input) != nil){
        
            captureSession?.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            
            if (captureSession?.canAddOutput(stillImageOutput) != nil){
                captureSession?.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                
                imageView.layer.addSublayer(previewLayer!)
                captureSession?.startRunning()
                previewLayer?.frame = imageView.frame
                started = true
            }
        }
    }
    
    func takePhoto(imageView: UIImageView) {
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                self.captureSession?.stopRunning()
                self.previewLayer?.isHidden = true
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                imageView.image = UIImage(data: imageData!)
                
                self.setGlobalImage(image: CIImage(cgImage: (imageView.image?.cgImage!)!))
            }
        }
    }

}
