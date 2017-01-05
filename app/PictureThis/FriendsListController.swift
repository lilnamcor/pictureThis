//
//  FriendsListController.swift
//  PictureThis
//
//  Created by Itai Reuveni on 12/19/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class FriendsListController: UIViewController {

    var globalImage = CIImage()
    var blurValue = 0.0
    var zoomValue = 0.0
    var brightnessValue = 0.0
    
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
            cameraController.captureMode = false
            cameraController.blurValue = blurValue
            cameraController.zoomValue = zoomValue
            cameraController.brightnessValue = brightnessValue
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
