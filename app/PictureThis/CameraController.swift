//
//  CameraController.swift
//  PictureThis
//
//  Created by Logan Moy on 12/19/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

class CameraController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

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
    @IBOutlet weak var scrollView: UIScrollView!
    
    // flags to remember which buttons have been pressed
    var captureMode = true
    var blurPressed = false
    var blurValue = 0.5
    var blurActive = false
    var zoomPressed = false
    var zoomValue = 0.5
    var answerText = NSString()
    var zoomActive = false
    var brightnessPressed = false
    var brightnessValue = 0.5
    var brightnessActive = false
    var answerPressed = false
    var sendAction = false
    
    
    // zoom factor
    var maxZoom = 3.0
    
    // stuff to capture images/video and show on the screen
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func notificationAction(_ sender: Any) {
        animationContract(button: notifications)
        if (captureMode) {
            self.performSegue(withIdentifier: "Notifications", sender:self)
        } else {
            slider.isEnabled = false
            slider.isHidden = true
            lockZoom()
            if (blurPressed) {
                blurValue = Double(0.5)
                blurActive = false
                zoomPressed = false
                brightnessPressed = false
                zoom.setImage(#imageLiteral(resourceName: "Logo"), for: .normal)
                brightness.setImage(#imageLiteral(resourceName: "Brightness"), for: .normal)
                if (brightnessActive) {
                    imageView.image = ImageFilters.filters.applyFilters(value: 0.0, mode: 0)
                } else{
                    imageView.image = ImageFilters.filters.getImageFromCIImage(image: CameraOperations.camera.getGlobalImage())
                }
            } else if (zoomPressed) {
                zoomValue = Double(0.5)
                scrollView.zoomScale = 1.0
                blurPressed = false
                brightnessPressed = false
                blur.setImage(#imageLiteral(resourceName: "Blur"), for: .normal)
                brightness.setImage(#imageLiteral(resourceName: "Brightness"), for: .normal)
            } else {
                brightnessValue = Double(0.5)
                brightnessActive = false
                blurPressed = false
                zoomPressed = false
                blur.setImage(#imageLiteral(resourceName: "Blur"), for: .normal)
                zoom.setImage(#imageLiteral(resourceName: "Logo"), for: .normal)
                if (brightnessActive) {
                    self.imageView.image = ImageFilters.filters.applyFilters(value: 0, mode: 1)
                } else{
                    imageView.image = ImageFilters.filters.getImageFromCIImage(image: CameraOperations.camera.getGlobalImage())
                }
                ImageFilters.filters.setFinalImage(image: imageView.image!)
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
        lockZoom()
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
    
    var prevBlurValue = 0.5
    
    @IBAction func sliderAction(_ sender: Any) {
        if (blurPressed) {
            blurValue = Double(slider.value)
            if (abs(blurValue - prevBlurValue) > 0.1) {
                prevBlurValue = blurValue
                self.imageView.image = ImageFilters.filters.applyFilters(value: Float(blurValue), mode: 0)
            }
        } else if (zoomPressed) {
            zoomValue = Double(slider.value)
            scrollView.zoomScale = CGFloat(Double(slider.value)*(Double(maxZoom)-1)+1)
        } else {
            brightnessValue = Double(slider.value)
            self.imageView.image = ImageFilters.filters.applyFilters(value: Float(brightnessValue), mode: 1)

        }
    }
    
    @IBAction func blurAction(_ sender: Any) {
        blurActive = true
        lockZoom()
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
            self.imageView.image = ImageFilters.filters.applyFilters(value: Float(blurValue), mode: 0)
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
            unLockZoom()
            slider.isHidden = false
            slider.isEnabled = true
            slider.value = Float(zoomValue)
            scrollView.zoomScale = CGFloat(zoomValue*(maxZoom-1)+1)
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
            lockZoom()
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
        brightnessActive = true
        lockZoom()
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
            self.imageView.image = ImageFilters.filters.applyFilters(value: Float(brightnessValue), mode: 1)
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
        scrollView.zoomScale = 1.0
        resetAnswer()
        if (captureMode) {
            animationContract(button: flash)
        } else {
            scrollView.isUserInteractionEnabled = false
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
            CameraOperations.camera.getCameraFeed(imageView: imageView)
            blur.setImage(#imageLiteral(resourceName: "Blur"), for: .normal)
            zoom.setImage(#imageLiteral(resourceName: "Logo"), for: .normal)
            brightness.setImage(#imageLiteral(resourceName: "Brightness"), for: .normal)
            disableButton(element: blur)
            blurActive = false
            disableButton(element: zoom)
            disableButton(element: brightness)
            blurValue = 0.5
            zoomValue = 0.5
            brightnessValue = 0.5
            brightnessActive = false
            blurPressed = false
            zoomPressed = false
            brightnessPressed = false
            answerPressed = false
            answer.isHidden = true
            answer.isEnabled = false
            answer.text = "_ _ _ _"
            slider.isHidden = true
            slider.isEnabled = false
            enableButton(element: capture)
            captureMode = true
        }
    }
    
    // takes and saves the picture
    @IBAction func captureAction(_ sender: Any) {
        scrollView.isUserInteractionEnabled = true
        lockZoom()
        captureMode = false
        settings.setImage(#imageLiteral(resourceName: "Send"), for: .normal)
        notifications.setImage(#imageLiteral(resourceName: "Undo"), for: .normal)
        CameraOperations.camera.takePhoto(imageView: imageView)
        flash.setImage(#imageLiteral(resourceName: "X"), for: .normal)
        enableButton(element: zoom)
        enableButton(element: brightness)
        enableButton(element: blur)
        disableButton(element: notifications)
        disableButton(element: capture)
        answer.isHidden = false
        answer.isEnabled = true
    }
    
    func lockZoom() {
        scrollView.bounces = false
        scrollView.maximumZoomScale = 1.0
    }
    
    func unLockZoom() {
        scrollView.bounces = true
        scrollView.maximumZoomScale = CGFloat(self.maxZoom)
    }
    
    
    
    // this function is called when you press enter on a text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (sendAction) {
            sendAction = false
            self.performSegue(withIdentifier: "FriendsList", sender:self)
        } else {
            if (answer.text == "") {
                answer.text = "_ _ _ _"
                answerPressed = false
            }
        }
        return true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // this gets rid of momentum
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: true)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if (zoomPressed) {
            slider.value = Float((scale-1)/(self.scrollView.maximumZoomScale-1))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (captureMode) {
            scrollView.isUserInteractionEnabled = false
        
            /*
            let aUIImage = self.imageView.image
            let aCGImage = aUIImage?.cgImage
            CameraOperations.camera.setGlobalImage(image: CIImage(cgImage: aCGImage!))
            */
            self.scrollView.bouncesZoom = true
            self.scrollView.minimumZoomScale = 1.0;
            self.scrollView.maximumZoomScale = CGFloat(self.maxZoom)
        
            slider.isContinuous = true
            slider.maximumTrackTintColor = UIColor.darkGray
            
            disableButton(element: zoom)
            disableButton(element: brightness)
            disableButton(element: blur)
            answer.isHidden = true
            slider.isHidden = true
            slider.isEnabled = false
            self.answer.delegate = self
            let tapGestureRecognizer = UITapGestureRecognizer(target:self,  action:#selector(imageTapped(img:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
        } else {
            answerPressed = true
            answer.text = answerText as String
            disableButton(element: notifications)
            slider.isHidden = true
            slider.isEnabled = false
            settings.setImage(#imageLiteral(resourceName: "Send"), for: .normal)
            notifications.setImage(#imageLiteral(resourceName: "Undo"), for: .normal)
            captureMode = false
            flash.setImage(#imageLiteral(resourceName: "X"), for: .normal)
            disableButton(element: capture)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FriendsList") {
            let friendsListController = segue.destination as! FriendsListController
            friendsListController.globalImage = CameraOperations.camera.getGlobalImage()
            friendsListController.blurValue = blurValue
            friendsListController.zoomValue = zoomValue
            friendsListController.brightnessValue = brightnessValue
            friendsListController.answer = answer.text! as NSString
        }
    }
    
    func imageTapped(img: AnyObject)
    {
        if (answerPressed) {
            if (answer.text == "") {
                answer.text = "_ _ _ _"
                answerPressed = false
            }
            answer.resignFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.frame = self.view.layer.bounds
        
        if (captureMode) {
            CameraOperations.camera.getCameraFeed(imageView: imageView)
        } else {
            self.imageView.image = ImageFilters.filters.getFinalImage()
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
