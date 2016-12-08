//
//  ViewController.swift
//  PictureThis
//
//  Created by Itai Reuveni on 12/4/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var button: UIButton!

    @IBAction func changeColor(_ sender: Any) {
        print("HELLO WORLD")
        button.tintColor = UIColor.purple
        button.setTitleColor(UIColor.purple, for: .normal)
        background.image? = (background.image?.withRenderingMode(.alwaysTemplate))!
        background.tintColor = UIColor.magenta
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

