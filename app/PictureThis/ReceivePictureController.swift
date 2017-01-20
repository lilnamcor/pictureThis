//
//  ReceivePictureController.swift
//  PictureThis
//
//  Created by Abhinav Gianey on 1/18/17.
//  Copyright © 2017 PictureThis. All rights reserved.
//

import UIKit

class ReceivePictureController: UIViewController {
    
    var answer = NSString()
    var image = UIImage()
    var alteredImage = UIImage()
    @IBOutlet weak var answerText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mockImage()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = image
        self.view.insertSubview(backgroundImage, at: 0)
        var i = 0
        while i < answer.length {
            answerText.text = answerText.text! + " _"
            i = i + 1
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func receivePicture(img: UIImage, alteredImg: UIImage, ans: NSString) {
        answer = ans
        image = img
        alteredImage = alteredImg
    }
    
    func mockImage() {
        // used to test page. Will delete later
        let catPath = "Cat.png"
        let tempImg = UIImage(named: catPath)!
        receivePicture(img: tempImg, alteredImg: tempImg, ans: "cat")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func handleText(_ sender: Any) {
        
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
