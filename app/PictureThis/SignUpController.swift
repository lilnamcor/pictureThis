//
//  SignUpController.swift
//  PictureThis
//
//  Created by Itai Reuveni on 12/11/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class SignUpController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var birthDate: UITextField!
    @IBOutlet weak var sexField: UISegmentedControl!
    @IBOutlet weak var privacyPolicy: UILabel!
    @IBOutlet weak var signUp: UIButton!
    var firstNameBool: Bool = false
    var lastNameBool: Bool = false
    var birthDateBool: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.delegate = self
        lastName.delegate = self
        birthDate.delegate = self
        signUp.layer.cornerRadius = 5
        privacyPolicy.sizeToFit()
        privacyPolicy.adjustsFontSizeToFitWidth = true
        privacyPolicy.textAlignment = .center
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if (textField == self.firstName) {
            self.lastName.becomeFirstResponder()
            if (!lastNameBool) {
                lastName.text = ""
            }
            lastNameBool = true
        } else if (textField == self.lastName) {
            self.birthDate.becomeFirstResponder()
            if (!birthDateBool) {
                birthDate.text = ""
            }
            birthDateBool = true
        }
        return true
    }

    @IBAction func eraseBirthDate(_ sender: Any) {
        if (birthDateBool == false) {
            birthDate.text = ""
        }
        birthDateBool = true
    }
    @IBAction func eraseFirst(_ sender: Any) {
        if (firstNameBool == false) {
            firstName.text = ""
        }
        firstNameBool = true
    }
    
    @IBAction func eraseLast(_ sender: Any) {
        if (lastNameBool == false) {
            lastName.text = ""
        }
        lastNameBool = true
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
