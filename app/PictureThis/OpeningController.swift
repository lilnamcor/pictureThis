//
//  OpeningController.swift
//  PictureThis
//
//  Created by Itai Reuveni on 3/15/17.
//  Copyright © 2017 PictureThis. All rights reserved.
//

import UIKit

class OpeningController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        loggedIn = false
        
        // Do any additional setup after loading the view.
        if (loggedIn) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Camera", sender: self)
            }
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Home", sender: self)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
