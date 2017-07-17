//
//  SettingsController.swift
//  PictureThis
//
//  Created by Logan Moy on 12/19/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var month: UIButton!
    @IBOutlet weak var day: UIButton!
    @IBOutlet weak var year: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var monthTable: UITableView!
    @IBOutlet weak var dayTable: UITableView!
    @IBOutlet weak var yearTable: UITableView!
    @IBOutlet weak var topView: UIView!
    
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
    
    var editMode = false
    
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    var daysInMonth = ["Jan": 31, "Feb" : 28, "Mar": 31, "Apr": 30, "May": 31, "Jun": 30, "Jul": 31,
                       "Aug": 31, "Sep": 30, "Oct": 31, "Nov": 30, "Dec": 31]

    var selectedMonth = "Jan"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = #imageLiteral(resourceName: "picturethis")
        let tapGestureRecognizer = UITapGestureRecognizer(target:self,  action:#selector(minimizeKeyboard(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        topView.isUserInteractionEnabled = true
        topView.addGestureRecognizer(tapGestureRecognizer)
        
        firstName.isEnabled = false
        lastName.isEnabled = false
        email.isEnabled = false
        password.isEnabled = false
        gender.isEnabled = false
        month.isEnabled = false
        day.isEnabled = false
        year.isEnabled = false
        
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
        
        email.text = "PENIS"
        password.text = "*****"
        
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        print("WHAT")
        if (textField == self.firstName) {
            self.lastName.becomeFirstResponder()
            firstNameActive = false
            lastNameActive = true
        }
        else if (textField == self.lastName) {
            self.email.becomeFirstResponder()
            lastNameActive = false
            emailActive = true
        }
        else if (textField == self.email) {
            self.password.becomeFirstResponder()
            emailActive = false
            passwordActive = true
        } else {
            self.email.resignFirstResponder()
        }
        return true
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
    
    @IBAction func editAction(_ sender: Any) {
        if (editMode == false) {
            firstName.isEnabled = true
            lastName.isEnabled = true
            email.isEnabled = true
            password.isEnabled = true
            gender.isEnabled = true
            month.isEnabled = true
            day.isEnabled = true
            year.isEnabled = true
            edit.setTitle("save", for: .normal)
            firstName.textColor = UIColor.black
            lastName.textColor = UIColor.black
            email.textColor = UIColor.black
            password.textColor = UIColor.black
            editMode = true
        } else {
            firstName.isEnabled = false
            lastName.isEnabled = false
            email.isEnabled = false
            password.isEnabled = false
            gender.isEnabled = false
            month.isEnabled = false
            day.isEnabled = false
            year.isEnabled = false
            monthTable.isHidden = true
            dayTable.isHidden = true
            yearTable.isHidden = true
            firstName.textColor = UIColor.lightGray
            lastName.textColor = UIColor.lightGray
            email.textColor = UIColor.lightGray
            password.textColor = UIColor.lightGray
            editMode = false
            edit.setTitle("edit", for: .normal)
        }
        
    }
    @IBAction func firstNameAction(_ sender: Any) {
        firstNameActive = true
    }
    
    @IBAction func lastNameAction(_ sender: Any) {
        lastNameActive = true
    }
    
    @IBAction func emailAction(_ sender: Any) {
        emailActive = true
    }
    
    @IBAction func passwordAction(_ sender: Any) {
        passwordActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return 31
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
    
    @IBAction func LogOutAction(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "loggedIn")
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
