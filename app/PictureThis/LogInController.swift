//
//  LogInController.swift
//  PictureThis
//
//  Created by Logan Moy on 12/10/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class LogInController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var logIn: UIButton!
    @IBOutlet weak var logInFacebook: UIButton!
    var usernameBool: Bool = false
    var passwordBool: Bool = false
    var usernameActive: Bool = false
    var passwordActive: Bool = false
 
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUp.layer.cornerRadius = 5
        signUp.layer.borderWidth = 1
        signUp.layer.borderColor = UIColor(colorLiteralRed: 0/255, green: 44/255, blue: 125/255, alpha: 1.0).cgColor
        logIn.layer.cornerRadius = 5
        username.delegate = self
        password.delegate = self
        logo.image = #imageLiteral(resourceName: "picturethis")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self,  action:#selector(minimizeKeyboard(_:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }

    func minimizeKeyboard(_ sender: UITapGestureRecognizer) {
        if (usernameActive) {
            usernameActive = false
            username.resignFirstResponder()
        }
        else if (passwordActive) {
            passwordActive = false
            password.resignFirstResponder()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if (passwordBool && password.text != "") {
            // login function
            print("LOGIN")
        } else {
            usernameActive = false
            password.text = ""
            passwordActive = true
            passwordBool = true
            password.becomeFirstResponder()
        }
        return true
    }

    @IBAction func LoginAction(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "loggedIn")
    }
    
    @IBAction func LoginFacebookAction(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "loggedIn")
    }
    
    @IBAction func eraseUsername(_ sender: Any) {
        if (usernameBool == false) {
            username.text = ""
        }
        usernameBool = true
        usernameActive = true
    }

    @IBAction func erasePassword(_ sender: Any) {
        password.text = ""
        passwordBool = true
        passwordActive = true
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
