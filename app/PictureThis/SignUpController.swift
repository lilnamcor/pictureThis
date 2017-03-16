//
//  SignUpController.swift
//  PictureThis
//
//  Created by Itai Reuveni on 12/11/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class SignUpController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var sexField: UISegmentedControl!
    @IBOutlet weak var privacyPolicy: UILabel!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var month: UIButton!
    @IBOutlet weak var day: UIButton!
    @IBOutlet weak var year: UIButton!
    
    @IBOutlet weak var monthTable: UITableView!
    @IBOutlet weak var dayTable: UITableView!
    @IBOutlet weak var yearTable: UITableView!
    
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    var daysInMonth = ["Jan": 31, "Feb" : 28, "Mar": 31, "Apr": 30, "May": 31, "Jun": 30, "Jul": 31,
        "Aug": 31, "Sep": 30, "Oct": 31, "Nov": 30, "Dec": 31]
    
    var selectedMonth = "Jan"
    
    var firstNameBool: Bool = false
    var lastNameBool: Bool = false
    var firstNameActive: Bool = false
    var lastNameActive: Bool = false
    
    var emailBool: Bool = false
    var passwordBool: Bool = false
    var emailActive: Bool = false
    var passwordActive: Bool = false
    
    var monthVal = ""
    var dayVal = ""
    var yearVal = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUp.layer.cornerRadius = 5
        logo.image = #imageLiteral(resourceName: "picturethis")
        let tapGestureRecognizer = UITapGestureRecognizer(target:self,  action:#selector(minimizeKeyboard(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        topView.isUserInteractionEnabled = true
        topView.addGestureRecognizer(tapGestureRecognizer)
        privacyPolicy.sizeToFit()
        privacyPolicy.adjustsFontSizeToFitWidth = true
        privacyPolicy.textAlignment = .center
        
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        monthTable.delegate = self
        dayTable.delegate = self
        yearTable.delegate = self
        
        monthTable.dataSource = self
        dayTable.dataSource = self
        yearTable.dataSource = self
        
        monthTable.allowsMultipleSelection = false
        dayTable.allowsMultipleSelection = false
        yearTable.allowsMultipleSelection = false
        
        monthTable.isHidden = true
        dayTable.isHidden = true
        yearTable.isHidden = true
        
        
        let path = IndexPath(row: 20, section: 0)
        
        yearTable.scrollToRow(at: path, at: .top, animated: false)
    }
    
    @IBAction func SignUpAction(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "loggedIn")
    }
    
    @IBAction func SignUpFacebookAction(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "loggedIn")
    }
    
    func minimizeKeyboard(_ sender: UITapGestureRecognizer) {
        if (firstNameActive) {
            firstNameActive = false
            firstName.resignFirstResponder()
        }
        else if (lastNameActive) {
            lastNameActive = false
            lastName.resignFirstResponder()
        }
        else if (emailActive) {
            emailActive = false
            email.resignFirstResponder()
        }
        else if (passwordActive) {
            passwordActive = false
            password.resignFirstResponder()
        }
        monthTable.isHidden = true
        dayTable.isHidden = true
        yearTable.isHidden = true
    }
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == firstName) { firstName.textColor = UIColor.black
        }
        else if (textField == lastName) {
            lastName.textColor = UIColor.black
        }
        else if (textField == email) {
            email.textColor = UIColor.black
        }
        else if (textField == password) {
            password.textColor = UIColor.black
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if (firstNameBool && lastNameBool && emailBool && passwordBool &&
            firstName.text != "" && lastName.text != "" && email.text != "" && password.text != "") {
            // SIGN UP
        } else if (textField == self.firstName) {
            self.lastName.becomeFirstResponder()
            if (!lastNameBool) {
                lastName.text = ""
            }
            firstNameActive = false
            lastNameBool = true
            lastNameActive = true
        } else if (textField == self.lastName) {
            self.email.becomeFirstResponder()
            if (!emailBool) {
                email.text = ""
            }
            lastNameActive = false
            emailBool   = true
            emailActive = true
        } else if (textField == self.email) {
            self.password.becomeFirstResponder()
            if (!passwordBool) {
                password.text = ""
            }
            emailActive = false
            passwordBool = true
            passwordActive = true
        }
        return true
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
    
    @IBAction func eraseEmail(_ sender: Any) {
        if (emailBool == false) {
            email.text = ""
        }
        emailActive = true
        emailBool = true
    }
    
    @IBAction func erasePassword(_ sender: Any) {
        if (passwordBool == false) {
            password.text = ""
        }
        passwordActive = true
        passwordBool = true
    }
    
    @IBAction func monthAction(_ sender: Any) {
        monthTable.isHidden = false
        dayTable.isHidden = true
        yearTable.isHidden = true
    }
    
    @IBAction func dayAction(_ sender: Any) {
        monthTable.isHidden = true
        dayTable.isHidden = false
        yearTable.isHidden = true
    }
    
    @IBAction func yearAction(_ sender: Any) {
        monthTable.isHidden = true
        dayTable.isHidden = true
        yearTable.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == monthTable) {
            if let selectedRow = tableView.cellForRow(at: indexPath) {
                monthVal = (selectedRow.textLabel?.text)!
                month.setTitle(monthVal, for: .normal)
                monthTable.isHidden = true
                dayTable.isHidden = true
                yearTable.isHidden = true
                selectedMonth = monthVal
                dayTable.reloadData()
            }
        } else if (tableView == dayTable) {
            if let selectedRow = tableView.cellForRow(at: indexPath) {
                dayVal = (selectedRow.textLabel?.text)!
                day.setTitle(dayVal, for: .normal)
                monthTable.isHidden = true
                dayTable.isHidden = true
                yearTable.isHidden = true
            }
        } else if (tableView == yearTable) {
            if let selectedRow = tableView.cellForRow(at: indexPath) {
                yearVal = (selectedRow.textLabel?.text)!
                year.setTitle(yearVal, for: .normal)
                monthTable.isHidden = true
                dayTable.isHidden = true
                yearTable.isHidden = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == monthTable) {
            return 12
        } else if (tableView == dayTable) {
            return daysInMonth[selectedMonth]!
        } else {
            return 100
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == monthTable) {
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "td")
            cell.textLabel?.text = months[indexPath.row]
            return cell
        } else if (tableView == dayTable) {
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "td")
            cell.textLabel?.text = String(indexPath.row+1)
            return cell
        } else {
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "td")
            cell.textLabel?.text = String(2017-indexPath.row)
            return cell
        }
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
