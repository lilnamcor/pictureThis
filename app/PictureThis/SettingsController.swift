//
//  SettingsController.swift
//  PictureThis
//
//  Created by Logan Moy on 12/19/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Gender: UISegmentedControl!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var month: UIButton!
    @IBOutlet weak var day: UIButton!
    @IBOutlet weak var year: UIButton!
    @IBOutlet weak var monthTable: UITableView!
    @IBOutlet weak var dayTable: UITableView!
    @IBOutlet weak var yearTable: UITableView!
    
    var monthVal = ""
    var dayVal = ""
    var yearVal = ""
    
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    var daysInMonth = ["Jan": 31, "Feb" : 28, "Mar": 31, "Apr": 30, "May": 31, "Jun": 30, "Jul": 31,
                       "Aug": 31, "Sep": 30, "Oct": 31, "Nov": 30, "Dec": 31]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Username.delegate = self
        Password.delegate = self
        
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
        
        Username.text = "PENIS"
        Password.text = "*****"
        
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if (textField == self.Username) {
            self.Password.becomeFirstResponder()
        }
        return true
    }
    
    @IBAction func Username(_ sender: Any) {
    }
    
    @IBAction func Password(_ sender: Any) {
    }
    
    @IBAction func Gender(_ sender: Any) {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
