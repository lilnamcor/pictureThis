//
//  ViewController.swift
//  PictureThis
//
//  Created by Itai Reuveni on 12/4/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var signUp: UIButton!
    @IBAction func changeImage(_ sender: Any) {
        if (logo.image == #imageLiteral(resourceName: "dog")) {
            logo.image = #imageLiteral(resourceName: "Cat")
        } else {
            logo.image = #imageLiteral(resourceName: "dog")
        }
    }
    @IBOutlet weak var login: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login.layer.borderWidth = 0.8
        login.layer.borderColor = UIColor.gray.cgColor
        signUp.layer.borderWidth = 0.8
        signUp.layer.borderColor = UIColor.gray.cgColor
        logo.image = #imageLiteral(resourceName: "dog")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

