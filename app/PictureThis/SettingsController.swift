//
//  SettingsController.swift
//  PictureThis
//
//  Created by Logan Moy on 12/19/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var DateofBirth: UITextField!
    @IBOutlet weak var Gender: UISegmentedControl!
    @IBOutlet weak var Password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Username.delegate = self
        Password.delegate = self
        DateofBirth.delegate = self
        Username.text = "PENIS"
        Password.text = "*****"
        DateofBirth.text = "10/15/1994"
        
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if (textField == self.Username) {
            self.Password.becomeFirstResponder()
        } else if (textField == self.Password) {
            self.DateofBirth.becomeFirstResponder()
        }
        return true
    }
    
    @IBAction func Username(_ sender: Any) {
    }
    
    @IBAction func Password(_ sender: Any) {
    }
    
    @IBAction func Gender(_ sender: Any) {
    }
    
    @IBAction func DateofBirth(_ sender: Any) {
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
