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
    var firstNameActive: Bool = false
    var lastNameActive: Bool = false
    var birthDateBool: Bool = false
    var birthDateActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.delegate = self
        lastName.delegate = self
        birthDate.delegate = self
        signUp.layer.cornerRadius = 5
        let tapGestureRecognizer = UITapGestureRecognizer(target:self,  action:#selector(minimizeKeyboard(_:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
    
        privacyPolicy.sizeToFit()
        privacyPolicy.adjustsFontSizeToFitWidth = true
        privacyPolicy.textAlignment = .center
        // Do any additional setup after loading the view.
    }
    
    func minimizeKeyboard(_ sender: UITapGestureRecognizer) {
        if (firstNameActive) {
            firstNameActive = false
            firstName.resignFirstResponder()
        }
        else if (lastNameActive) {
            lastNameActive = false
            lastName.resignFirstResponder()
        } else if (birthDateActive) {
            birthDateActive = false
            birthDate.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if (firstNameBool && lastNameBool && birthDateBool &&
            firstName.text != "" && lastName.text != "" && birthDate.text != "") {
            // SIGN UP
            print("SIGN UP")
        } else if (textField == self.firstName) {
            self.lastName.becomeFirstResponder()
            if (!lastNameBool) {
                lastName.text = ""
            }
            firstNameActive = false
            lastNameBool = true
            lastNameActive = true
        } else if (textField == self.lastName) {
            self.birthDate.becomeFirstResponder()
            if (!birthDateBool) {
                birthDate.text = ""
            }
            lastNameActive = false
            birthDateBool = true
            birthDateActive = true
        }
        return true
    }

    @IBAction func eraseBirthDate(_ sender: Any) {
        if (birthDateBool == false) {
            birthDate.text = ""
        }
        birthDateActive = true
        birthDateBool = true
    }
    
    @IBAction func eraseFirst(_ sender: Any) {
        if (firstNameBool == false) {
            firstName.text = ""
        }
        firstNameActive = true
        firstNameBool = true
    }
    
    @IBAction func eraseLast(_ sender: Any) {
        if (lastNameBool == false) {
            lastName.text = ""
        }
        lastNameActive = true
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
