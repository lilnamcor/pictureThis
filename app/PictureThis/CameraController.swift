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
    var blurValue = 0.5
    var zoomPressed = false
    var zoomValue = 0.5
    var brightnessPressed = false
    var brightnessValue = 0.5
    var answerPressed = false
    var sendAction = false
    
    // stuff to capture images/video and show on the screen
    @IBOutlet weak var imageView: UIImageView!
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    @IBAction func notificationAction(_ sender: Any) {
        animationContract(button: notifications)
        if (captureMode) {
            self.performSegue(withIdentifier: "Notifications", sender:self)
        } else {
            slider.isEnabled = false
            slider.isHidden = true
            if (blurPressed) {
                blurValue = Double(0)
                zoomPressed = false
                brightnessPressed = false
                zoom.setImage(#imageLiteral(resourceName: "Logo"), for: .normal)
                brightness.setImage(#imageLiteral(resourceName: "Brightness"), for: .normal)
            } else if (zoomPressed) {
                zoomValue = Double(0)
                blurPressed = false
                brightnessPressed = false
                blur.setImage(#imageLiteral(resourceName: "Blur"), for: .normal)
                brightness.setImage(#imageLiteral(resourceName: "Brightness"), for: .normal)
            } else {
                brightnessValue = Double(0)
                blurPressed = false
                zoomPressed = false
                blur.setImage(#imageLiteral(resourceName: "Blur"), for: .normal)
                zoom.setImage(#imageLiteral(resourceName: "Logo"), for: .normal)
            }
            blurPressed = false
            zoomPressed = false
            brightnessPressed = false
        }
    }
    @IBAction func sendAction(_ sender: Any) {
        if (captureMode) {
            self.performSegue(withIdentifier: "Settings", sender:self)
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
    
    @IBAction func sliderAction(_ sender: Any) {
        if (blurPressed) {
            blurValue = Double(slider.value)
        } else if (zoomPressed) {
            zoomValue = Double(slider.value)
        } else {
            brightnessValue = Double(slider.value)
        }
    }
    
    @IBAction func blurAction(_ sender: Any) {
        animationContract(button: blur)
        resetAnswer()
        if (!blurPressed){
            slider.isHidden = false
            slider.isEnabled = true
            slider.value = Float(blurValue)
            brightnessPressed = false
            zoomPressed = false
            blurPressed = true
            blur.setImage(#imageLiteral(resourceName: "Blur"), for: .normal)
            zoom.setImage(#imageLiteral(resourceName: "Logo Dark"), for: .normal)
            brightness.setImage(#imageLiteral(resourceName: "Brightness Dark"), for: .normal)
            notifications.isEnabled = true
            notifications.isHidden = false
        } else {
            slider.isHidden = true
            slider.isEnabled = false
            blurPressed = false
            blur.setImage(#imageLiteral(resourceName: "Blur"), for: .normal)
            zoom.setImage(#imageLiteral(resourceName: "Logo"), for: .normal)
            brightness.setImage(#imageLiteral(resourceName: "Brightness"), for: .normal)
            notifications.isEnabled = false
            notifications.isHidden = true
        }
    }
    
    @IBAction func zoomAction(_ sender: Any) {
        animationContract(button: zoom)
        resetAnswer()
        if (!zoomPressed){
            slider.isHidden = false
            slider.isEnabled = true
            slider.value = Float(zoomValue)
            brightnessPressed = false
            zoomPressed = true
            blurPressed = false
            blur.setImage(#imageLiteral(resourceName: "Blur Dark"), for: .normal)
            zoom.setImage(#imageLiteral(resourceName: "Logo"), for: .normal)
            brightness.setImage(#imageLiteral(resourceName: "Brightness Dark"), for: .normal)
            notifications.setImage(#imageLiteral(resourceName: "Undo"), for: .normal)
            notifications.isEnabled = true
            notifications.isHidden = false
        } else {
            slider.isHidden = true
            slider.isEnabled = false
            zoomPressed = false
            blur.setImage(#imageLiteral(resourceName: "Blur"), for: .normal)
            zoom.setImage(#imageLiteral(resourceName: "Logo"), for: .normal)
            brightness.setImage(#imageLiteral(resourceName: "Brightness"), for: .normal)
            notifications.setImage(#imageLiteral(resourceName: "Undo"), for: .normal)
            notifications.isEnabled = false
            notifications.isHidden = true
        }
    }
    
    @IBAction func brightnessAction(_ sender: Any) {
        animationContract(button: brightness)
        resetAnswer()
        if (!brightnessPressed){
            slider.isHidden = false
            slider.isEnabled = true
            slider.value = Float(brightnessValue)
            brightnessPressed = true
            zoomPressed = false
            blurPressed = false
            blur.setImage(#imageLiteral(resourceName: "Blur Dark"), for: .normal)
            zoom.setImage(#imageLiteral(resourceName: "Logo Dark"), for: .normal)
            brightness.setImage(#imageLiteral(resourceName: "Brightness"), for: .normal)
            notifications.setImage(#imageLiteral(resourceName: "Undo"), for: .normal)
            notifications.isEnabled = true
            notifications.isHidden = false
        } else {
            slider.isHidden = true
            slider.isEnabled = false
            brightnessPressed = false
            blur.setImage(#imageLiteral(resourceName: "Blur"), for: .normal)
            zoom.setImage(#imageLiteral(resourceName: "Logo"), for: .normal)
            brightness.setImage(#imageLiteral(resourceName: "Brightness"), for: .normal)
            notifications.isEnabled = false
            notifications.isHidden = true
        }
    }
    
    // if in capture mode its flash if not then its an X to go back to capture mode
    @IBAction func flashAction(_ sender: Any) {
        resetAnswer()
        if (captureMode) {
            animationContract(button: flash)
        } else {
            UIView.animate(withDuration: 0,
                animations: {
                    self.flash.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            )
            settings.setImage(#imageLiteral(resourceName: "Settings"), for: .normal)
            flash.setImage(#imageLiteral(resourceName: "Flash"), for: .normal)
            notifications.isEnabled = true
            notifications.isHidden = false
            notifications.setImage(#imageLiteral(resourceName: "Notification"), for: .normal)
            self.captureSession?.startRunning()
            blur.setImage(#imageLiteral(resourceName: "Blur"), for: .normal)
            zoom.setImage(#imageLiteral(resourceName: "Logo"), for: .normal)
            brightness.setImage(#imageLiteral(resourceName: "Brightness"), for: .normal)
            disableButton(element: blur)
            disableButton(element: zoom)
            disableButton(element: brightness)
            blurPressed = false
            zoomPressed = false
            brightnessPressed = false
            answer.isHidden = true
            slider.isHidden = true
            slider.isEnabled = false
            self.previewLayer?.isHidden = false
            enableButton(element: capture)
            captureMode = true
        }
    }
    
    // takes and saves the picture
    @IBAction func captureAction(_ sender: Any) {
        captureMode = false
        settings.setImage(#imageLiteral(resourceName: "Send"), for: .normal)
        notifications.isEnabled = false
        notifications.isHidden = true
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                self.captureSession?.stopRunning()
                self.previewLayer?.isHidden = true
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                self.imageView.image = UIImage(data: imageData!)
            }
        }
        flash.setImage(#imageLiteral(resourceName: "X"), for: .normal)
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
        slider.maximumTrackTintColor = UIColor.darkGray
        
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
    
    // All the code for expanding and contracting the buttons
    func animationExpand(button: UIButton) {
        UIView.animate(withDuration: 0.2,
            animations: {
                button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }
        )
    }
    
    func animationContract(button: UIButton) {
        UIView.animate(withDuration: 0.2,
            animations: {
                button.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        )
    }
    
    @IBAction func blurExpandAction(_ sender: Any) {
        animationExpand(button: blur)
    }
    
    @IBAction func blurDragExitAction(_ sender: Any) {
        animationContract(button: blur)
    }
    
    @IBAction func blurDragEnterAction(_ sender: Any) {
        animationExpand(button: blur)
    }
    
    @IBAction func zoomExpandAction(_ sender: Any) {
        animationExpand(button: zoom)
    }
    
    @IBAction func zoomDragExitAction(_ sender: Any) {
        animationContract(button: zoom)
    }
    
    @IBAction func zoomDragEnterAction(_ sender: Any) {
        animationExpand(button: zoom)
    }
    
    @IBAction func brightnessExpandAction(_ sender: Any) {
        animationExpand(button: brightness)
    }
    
    @IBAction func brightnessDragExitAction(_ sender: Any) {
        animationContract(button: brightness)
    }
    
    @IBAction func brightnessDragEnterAction(_ sender: Any) {
        animationExpand(button: brightness)
    }
    
    @IBAction func flashExpandAction(_ sender: Any) {
        animationExpand(button: flash)
    }
    
    @IBAction func flashDragExitAction(_ sender: Any) {
        animationContract(button: flash)
    }
    
    @IBAction func flashDragEnterAction(_ sender: Any) {
        animationExpand(button: flash)
    }
    
    @IBAction func sendExpandAction(_ sender: Any) {
        animationExpand(button: settings)
    }
    
    @IBAction func sendDragExitAction(_ sender: Any) {
        animationContract(button: settings)
    }
    
    @IBAction func sendDragEnterAction(_ sender: Any) {
        animationExpand(button: settings)
    }
    
    @IBAction func notificationExpandAction(_ sender: Any) {
        animationExpand(button: notifications)
    }
    
    @IBAction func notificationDragExitAction(_ sender: Any) {
        animationContract(button: notifications)
    }
    
    @IBAction func notificationDragEnterAction(_ sender: Any) {
        animationExpand(button: notifications)
    }

}
