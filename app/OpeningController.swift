//
//  OpeningController.swift
//  PictureThis
//
//  Created by Itai Reuveni on 2/15/17.
//  Copyright © 2017 PictureThis. All rights reserved.
//

import UIKit

class OpeningController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if (true) {// logged in (have some special key that a network call figures out is legit
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "Camera", sender: nil)
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "Home", sender: nil)
            })
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
