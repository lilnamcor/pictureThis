//
//  FriendsListController.swift
//  PictureThis
//
//  Created by Itai Reuveni on 12/19/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class FriendsListController: UIViewController {

    @IBOutlet weak var friendsList: UITableView!
    
    var globalImage = CIImage()
    var blurValue = 0.0
    var zoomValue = 0.0
    var brightnessValue = 0.0
    var answer = NSString()
    var xOffset = CGFloat()
    var yOffset = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FriendsToCamera") {
            let cameraController = segue.destination as! CameraController
            cameraController.answerText = answer
            cameraController.captureMode = false
            if (blurValue > 0.0) {
                cameraController.blurValue = blurValue
                cameraController.blurActive = true
            } else {
                cameraController.blurValue = 0.0
            }
            if (zoomValue > 0.0) {
                cameraController.zoomActive = true
                cameraController.xOffset = xOffset
                cameraController.yOffset = yOffset
            }
            if (brightnessValue > 0.0) {
                cameraController.brightnessValue = brightnessValue
                cameraController.brightnessActive = true
            } else {
                cameraController.brightnessValue = 0.0
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
