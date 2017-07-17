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
        password.isSecureTextEntry = true
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
        if (usernameActive) {
            usernameActive = false
            password.text = ""
            passwordActive = true
            passwordBool = true
            password.becomeFirstResponder()
        } else if (passwordBool && password.text != ""){
            login()
            print("LOGIN")
        }
        return true
    }

    func sha256Data(_ data: Data) -> Data? {
        guard let res = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH)) else { return nil }
        CC_SHA256((data as NSData).bytes, CC_LONG(data.count), res.mutableBytes.assumingMemoryBound(to: UInt8.self))
        return res as Data
    }
    
    func sha256(_ str: String) -> String? {
        guard
            let data = str.data(using: String.Encoding.utf8),
            let shaData = sha256Data(data)
            else { return nil }
        let rc = shaData.base64EncodedString(options: [])
        return rc
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        login()
    }
    
    func login() {
        UserDefaults.standard.set(true, forKey: "loggedIn")
        var request = URLRequest(url: URL(string: "http://localhost:8080/login")!)
        request.httpMethod = "POST"
        let postString = "username=".appending(username.text!).appending("&password=").appending(sha256(password.text!)!)
        request.httpBody = postString.data(using: .utf8)
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
                self.performSegue(withIdentifier: "camera", sender:self)
            }
            
        }
        task.resume()
    }
    
    @IBAction func LoginFacebookAction(_ sender: Any) {
        login()
    }
    
    @IBAction func eraseUsername(_ sender: Any) {
        if (usernameBool == false) {
            username.text = ""
        }
        usernameBool = true
        usernameActive = true
        passwordActive = false
    }

    @IBAction func erasePassword(_ sender: Any) {
        password.text = ""
        passwordBool = true
        passwordActive = true
        usernameActive = false
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
