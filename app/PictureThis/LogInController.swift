//
//  LogInController.swift
//  PictureThis
//
//  Created by Logan Moy on 12/10/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class LogInController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    var usernameBool: Bool = false
    var passwordBool: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        Username.delegate = self
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.Password.becomeFirstResponder()
        Password.text = ""
        return true
    }
    
    @IBAction func eraseUsername(_ sender: Any) {
        if (usernameBool == false) {
            Username.text = ""
        }
        usernameBool = true
    }

    @IBAction func erasePassword(_ sender: Any) {
        if (passwordBool == false) {
            Password.text = ""
        }
        passwordBool = true
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
