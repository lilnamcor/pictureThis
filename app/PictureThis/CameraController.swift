//
//  CameraController.swift
//  PictureThis
//
//  Created by Logan Moy on 12/19/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {

    @IBOutlet weak var notifications: UIButton!
    @IBOutlet weak var capture: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var brightness: UIButton!
    @IBOutlet weak var zoom: UIButton!
    @IBOutlet weak var blur: UIButton!
    @IBOutlet weak var flash: UIButton!
    @IBOutlet weak var answer: UITextField!
    
    
    @IBOutlet weak var imageView: UIImageView!
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notifications.setTitle("notifications", for: .normal)
        settings.setTitle("settings", for: .normal)
        flash.setTitle("flash", for: .normal)
        
        
        slider.isHidden = true
        zoom.isHidden = true
        brightness.isHidden = true
        blur.isHidden = true
        answer.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = self.view.layer.bounds
    }
    
    @IBAction func captureAction(_ sender: Any) {
        notifications.setTitle("cancel", for: .normal)
        settings.setTitle("send", for: .normal)
        flash.setTitle("X", for: .normal)
        zoom.isHidden = false
        brightness.isHidden = false
        blur.isHidden = false
        answer.isHidden = false
        capture.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
                
            }
            
            
        }
        
        
    }

}
