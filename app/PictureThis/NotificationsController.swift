//
//  NotificationsController.swift
//  PictureThis
//
//  Created by Logan Moy on 12/19/16.
//  Copyright © 2016 PictureThis. All rights reserved.
//

import UIKit

class NotificationsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var friendsList: UITableView!
    
    var allFriends = [String]()
    var displayedFriends = [String]()
    var selectedFriend = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsList.delegate = self
        searchBar.delegate = self
        
        friendsList.dataSource = self
        friendsList.allowsMultipleSelection = true
        
        let username = UserDefaults.standard.string(forKey: "username")
        let requestString = "http://localhost:8080/friends?username=".appending(username!)
        var request = URLRequest(url: URL(string: requestString)!)
        request.httpMethod = "GET"
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
            if (responseString == "fail") {
                print("TRY AGAIN")
            } else {
                let index = responseString?.index((responseString?.startIndex)!, offsetBy: 7)
                if (responseString?.substring(to: index!) == "SUCCESS") {
                    self.allFriends = (responseString?.substring(from: index!).components(separatedBy: ","))!
                    self.displayedFriends = self.allFriends
                }
            }
            
        }
        task.resume()
        while (allFriends.endIndex == 0) {}
        
        
        //allFriends = ["Abhi", "Akhil", "Amna", "Byran", "Danielle", "Davit", "Erica", "Jas", "Logan", "Navin", "Ross", "Tim", "Melissa Hsu", "Megan", "Hannah"]
        //displayedFriends = allFriends

        // Do any additional setup after loading the view.
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "game") {
            let chatController = segue.destination as! GameController
            chatController.currentFriend = selectedFriend
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedRow = tableView.cellForRow(at: indexPath) {
            selectedFriend = (selectedRow.textLabel?.text)!
        }
        self.performSegue(withIdentifier: "game", sender:self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.displayedFriends)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
