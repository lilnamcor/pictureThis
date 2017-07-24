//
//  FriendsListController.swift
//  PictureThis
//
//  Created by Itai Reuveni on 12/19/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class FriendsListController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var friendsList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var send: UIButton!
    var globalImage = CIImage()
    var blurValue = 0.0
    var zoomValue = 0.0
    var brightnessValue = 0.0
    var answer = NSString()
    var xOffset = CGFloat()
    var yOffset = CGFloat()
    var allFriends = [String]()
    var displayedFriends = [String]()
    var selectedFriends = [String]()
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        displayedFriends = allFriends
        friendsList.reloadData()
        var index = IndexPath()
        var text = ""
        for i in 0..<displayedFriends.count {
            index = IndexPath(row: i, section: 0)
            if let selectedRow = friendsList.cellForRow(at: index) {
                text = (selectedRow.textLabel?.text)!
                if selectedFriends.contains(text) {
                    friendsList.selectRow(at: index, animated: false, scrollPosition: UITableViewScrollPosition.middle)
                }
            }
        }
        searchBar.resignFirstResponder()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsList.delegate = self
        searchBar.delegate = self
        
        friendsList.dataSource = self
        friendsList.allowsMultipleSelection = true
        
        let username = UserDefaults.standard.string(forKey: "username")
        var request = URLRequest(url: URL(string: "http://localhost:8080/friends")!)
        request.httpMethod = "GET"
        print("WE IN HERE")
        let parameterString = "username=".appending(username!)
        request.httpBody = parameterString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            if (responseString == "fail") {
                print("TRY AGAIN")
            } else {
                print(responseString)
            }
            
        }
        task.resume()
        
        allFriends = ["Abhi", "Akhil", "Amna", "Byran", "Danielle", "Davit", "Erica", "Jas", "Logan", "Navin", "Ross", "Tim", "Melissa Hsu", "Megan", "Hannah"]
        displayedFriends = allFriends
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendAction(_ sender: Any) {
        print(selectedFriends)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        displayedFriends = filterFriends(friends: allFriends, start: searchText)
        friendsList.reloadData()
        var index = IndexPath()
        var text = ""
        for i in 0..<displayedFriends.count {
            index = IndexPath(row: i, section: 0)
            if let selectedRow = friendsList.cellForRow(at: index) {
                text = (selectedRow.textLabel?.text)!
                if selectedFriends.contains(text) {
                    friendsList.selectRow(at: index, animated: false, scrollPosition: UITableViewScrollPosition.middle)
                }
            }
        }
    }
    
    func filterFriends(friends: [String], start: String) -> [String] {
        let len = start.endIndex
        var toReturn = [String]()
        for friend in friends {
            if (len < friend.endIndex) {
                let temp = friend.substring(to: len)
                if (temp == start as String) {
                    toReturn.append(friend)
                }
            }
        }
        return toReturn
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedRow = tableView.cellForRow(at: indexPath) {
            selectedFriends.append((selectedRow.textLabel?.text)!)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var selection = ""
        if let selectedRow = tableView.cellForRow(at: indexPath) {
            selection = (selectedRow.textLabel?.text)!
        }
        let index = selectedFriends.index(of: selection)
        selectedFriends.remove(at: index!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedFriends.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "td")
        cell.textLabel?.text = displayedFriends[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FriendsToCamera") {
            let cameraController = segue.destination as! CameraController
            cameraController.answerText = answer
            cameraController.captureMode = false
            if (blurValue > 0.0) {
                cameraController.blurValue = blurValue
                cameraController.blurActive = true
            } else {
                cameraController.blurValue = 0.0
            }
            if (zoomValue > 0.0) {
                cameraController.zoomActive = true
                cameraController.xOffset = xOffset
                cameraController.yOffset = yOffset
            }
            if (brightnessValue > 0.0) {
                cameraController.brightnessValue = brightnessValue
                cameraController.brightnessActive = true
            } else {
                cameraController.brightnessValue = 0.0
            }
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
