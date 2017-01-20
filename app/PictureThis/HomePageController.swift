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
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = #imageLiteral(resourceName: "picturethis")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

