//
//  LogInController.swift
//  PictureThis
//
//  Created by Logan Moy on 12/10/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class LogInController: UIViewController {
    @IBOutlet weak var Username: UITextField!
    var usernameCounter: Int = 0
    var passwordCounter: Int = 0
    @IBOutlet weak var Password: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func eraseUsername(_ sender: Any) {
        if (usernameCounter == 0) {
            Username.text = ""
        }
        usernameCounter += 1
    }

    @IBAction func erasePassword(_ sender: Any) {
        if (passwordCounter == 0) {
            Password.text = ""
        }
        passwordCounter += 1
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
