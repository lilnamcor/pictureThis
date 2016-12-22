//
//  CameraController.swift
//  PictureThis
//
//  Created by Logan Moy on 12/19/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, UITextFieldDelegate {

    // buttons
    @IBOutlet weak var notifications: UIButton!
    @IBOutlet weak var capture: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var brightness: UIButton!
    @IBOutlet weak var zoom: UIButton!
    @IBOutlet weak var blur: UIButton!
    @IBOutlet weak var flash: UIButton!
    @IBOutlet weak var answer: UITextField!
    
    // flags to remember which buttons have been pressed
    var captureMode = true
    var blurPressed = false
    var zoomPressed = false
    var brightnessPressed = false
    var answerPressed = false
    var sendAction = false
    
    // stuff to capture images/video and show on the screen
    @IBOutlet weak var imageView: UIImageView!
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    @IBAction func sendAction(_ sender: Any) {
        if (captureMode) {
            
        } else {
            if (!answerPressed || answer.text == "") {
                sendAction = true
                answer.becomeFirstResponder()
            } else {
                self.performSegue(withIdentifier: "FriendsList", sender:self)
            }
        }
    }
    
    @IBAction func answerAction(_ sender: Any) {
        if (!answerPressed) {
            answer.text = ""
            answerPressed = true
        }
    }
    
    func resetAnswer() {
        answer.resignFirstResponder()
        if (answer.text == "") {
            answer.text = "_ _ _ _"
            answerPressed = false
        }
    }
    
    func resetButtons(button: UIButton) {
        
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        print(slider.value)
    }
    
    @IBAction func blurAction(_ sender: Any) {
        resetAnswer()
        if (!blurPressed){
            slider.isHidden = false
            slider.isEnabled = true
            brightnessPressed = false
            zoomPressed = false
            blurPressed = true
        } else {
            slider.isHidden = true
            slider.isEnabled = false
            blurPressed = false
        }
    }
    
    @IBAction func zoomAction(_ sender: Any) {
        resetAnswer()
        if (!zoomPressed){
            zoom.setBackgroundImage(#imageLiteral(resourceName: "magnifyingClicked"), for: .normal)
            slider.isHidden = false
            slider.isEnabled = true
            brightnessPressed = false
            zoomPressed = true
            blurPressed = false
        } else {
            zoom.setBackgroundImage(#imageLiteral(resourceName: "magnifying"), for: .normal)
            slider.isHidden = true
            slider.isEnabled = false
            zoomPressed = false
        }
    }
    
    @IBAction func brightnessAction(_ sender: Any) {
        resetAnswer()
        if (!brightnessPressed){
            slider.isHidden = false
            slider.isEnabled = true
            brightnessPressed = true
            zoomPressed = false
            blurPressed = false
        } else {
            slider.isHidden = true
            slider.isEnabled = false
            brightnessPressed = false
        }
    }
    
    // if in capture mode its flash if not then its an X to go back to capture mode
    @IBAction func flashAction(_ sender: Any) {
        resetAnswer()
        if (captureMode) {
        } else {
            self.captureSession?.startRunning()
            notifications.setTitle("notifications", for: .normal)
            settings.setTitle("settings", for: .normal)
            flash.setTitle("flash", for: .normal)
            disableButton(element: zoom)
            disableButton(element: brightness)
            disableButton(element: blur)
            answer.isHidden = true
            slider.isHidden = true
            slider.isEnabled = false
            self.previewLayer?.isHidden = false
            enableButton(element: capture)
            captureMode = true
            zoom.setBackgroundImage(#imageLiteral(resourceName: "magnifying"), for: .normal)
        }
    }
    
    // takes and saves the picture
    @IBAction func captureAction(_ sender: Any) {
        captureMode = false
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                self.captureSession?.stopRunning()
                self.previewLayer?.isHidden = true
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                self.imageView.image = UIImage(data: imageData!)
            }
        }
        notifications.setTitle("cancel", for: .normal)
        settings.setTitle("send", for: .normal)
        flash.setTitle("X", for: .normal)
        enableButton(element: zoom)
        enableButton(element: brightness)
        enableButton(element: blur)
        disableButton(element: capture)
        
        answer.isHidden = false
    }
    
    // this function is called when you press enter on a text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (sendAction) {
            self.performSegue(withIdentifier: "FriendsList", sender:self)
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.isContinuous = true
        
        notifications.setTitle("notifications", for: .normal)
        settings.setTitle("settings", for: .normal)
        flash.setTitle("flash", for: .normal)
        
        
        disableButton(element: zoom)
        disableButton(element: brightness)
        disableButton(element: blur)
        answer.isHidden = true
        slider.isHidden = true
        slider.isEnabled = false
        self.answer.delegate = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = self.view.layer.bounds
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
    
    func disableButton(element: UIButton) {
        element.isHidden = true
        element.isEnabled = false
    }
    
    func enableButton(element: UIButton) {
        element.isHidden = false
        element.isEnabled = true
    }

}
