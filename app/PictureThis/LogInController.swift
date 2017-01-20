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
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var logIn: UIButton!
    @IBOutlet weak var logInFacebook: UIButton!
    var usernameBool: Bool = false
    var passwordBool: Bool = false
    
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUp.layer.cornerRadius = 5
        signUp.layer.borderWidth = 1
        signUp.layer.borderColor = UIColor(colorLiteralRed: 0/255, green: 44/255, blue: 125/255, alpha: 1.0).cgColor
        logIn.layer.cornerRadius = 5
        Username.delegate = self
        logo.image = #imageLiteral(resourceName: "picturethis")
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
