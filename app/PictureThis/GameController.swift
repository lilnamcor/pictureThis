//
//  GameController.swift
//  PictureThis
//
//  Created by Itai Reuveni on 2/7/17.
//  Copyright © 2017 PictureThis. All rights reserved.
//

import UIKit

class GameController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    /*
    func keyWasTapped(character: String) {
        print(character)
        print(answerField.text)
        checkLetter(lastChar: character.lowercased())
        print(answerField.text)
    }
 */
    
    var currentFriend = ""
    var answer = ""
    var uniqueLetters = 0.0
    var keyboardActive = false
    var currentText = ""
    var numWrongGuesses = 0.0
    var correctGuesses = ""
    var numRightGuesses = 0.0
    
    var finalImage = UIImage()
    
    @IBOutlet weak var life1: UIImageView!
    @IBOutlet weak var life2: UIImageView!
    @IBOutlet weak var life3: UIImageView!
    @IBOutlet weak var life4: UIImageView!
    @IBOutlet weak var life5: UIImageView!
    @IBOutlet weak var life6: UIImageView!
    
    var MAXZOOM = 6.0
    
    var blur = 0.0
    var zoom = 0.0
    var brightness = 0.0
    var xOffset = CGFloat()
    var yOffset = CGFloat()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        // initialize custom keyboard
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
        keyboardView.delegate = self // the view controller will be notified by the keyboard whenever a key is tapped
        
        // replace system keyboard with custom keyboard
        answerField.inputView = keyboardView
        
*/
        // get these from server
        answer = "hello"
        var allLetters = Set<Character>()
        for letter in answer.characters {
            allLetters.insert(letter)
        }
        uniqueLetters = Double(allLetters.count)
        finalImage = #imageLiteral(resourceName: "akhil")
        image.image = finalImage
        blur = 1.0
        zoom = 0.33
        brightness = 0.75
        xOffset = 50
        yOffset = 50
        ImageFilters.filters.setBlurImage(image: CIImage(cgImage: (image.image?.cgImage!)!))
        image.image = ImageFilters.filters.applyFilters(blurValue: blur, brightnessValue: brightness, image: CIImage(cgImage: (image.image?.cgImage!)!))
        
        for _ in answer.characters {
            currentText += "_ "
        }
        
        
        
        answerField.delegate = self
        answerField.text = currentText
        answerField.tintColor = UIColor.clear
        answerField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let tapGestureRecognizer = UITapGestureRecognizer(target:self,  action:#selector(keyboardAction(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
        self.scrollView.isUserInteractionEnabled = false
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = CGFloat(self.MAXZOOM)
        self.scrollView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.zoomScale = CGFloat(self.zoom*(self.MAXZOOM-1)+1)
        self.scrollView.contentOffset.x = CGFloat(self.xOffset)
        self.scrollView.contentOffset.y = CGFloat(self.yOffset)
    }
    
    func replace(myString:String, index:String.Index, newCharac:String) -> String {
        let intValue = myString.distance(from: myString.startIndex, to: index)
        var firstIndex = index
        if (intValue > 0 ) {
            for _ in 0...(intValue-1) {
                firstIndex = myString.index(after: firstIndex)
            }
        }
        let lastIndex = myString.index(after: firstIndex)
        
        return myString.substring(to: (firstIndex)) + newCharac + myString.substring(from: lastIndex)
    }
    
    func replace(str:String, indices:[Int], char: Character) -> String {
        var toReturn = str
        for i in indices {
            let index = str.index(str.startIndex, offsetBy: i*2)
            toReturn.remove(at: index)
            toReturn.insert(char, at: index)
        }
        return toReturn
    }
    
    //func checkLetter(lastChar: String) {
    func textFieldDidChange(_ textField: UITextField) {
        let text = answerField.text
        let lastChar = text?.substring(from:(text?.index((text?.endIndex)!, offsetBy: -1))!)
        print(lastChar)
        let indexCorrect = correctGuesses.lowercased().range(of:lastChar!)
        var indices = [Int]()
        var count = 0
        for letter in answer.characters {
            print(letter)
            if (String(letter) == lastChar) {
                indices.append(count)
            }
            count += 1
        }
        if (indices.count > 0 && indexCorrect == nil) {
            numRightGuesses += 1
            correctGuesses += lastChar!
            answerField.text = replace(str: currentText, indices: indices, char: Character(lastChar!))
            currentText = answerField.text!
            let curEffect = (uniqueLetters-numRightGuesses)/uniqueLetters
            image.image = ImageFilters.filters.applyFilters(blurValue: (blur*curEffect), brightnessValue: (brightness*curEffect), image: CIImage(cgImage: (finalImage.cgImage!)))
            self.scrollView.zoomScale = CGFloat((self.zoom*curEffect)*(self.MAXZOOM-1)+1)
        } else {
            answerField.text = currentText
            numWrongGuesses += 1
            if (numWrongGuesses == 1) {
                life6.isHidden = true
            } else if (numWrongGuesses == 2) {
                life5.isHidden = true
            } else if (numWrongGuesses == 3){
                life4.isHidden = true
                // game over
            } else if (numWrongGuesses == 4) {
                life3.isHidden = true
            } else if (numWrongGuesses == 5) {
                life2.isHidden = true
            } else if (numWrongGuesses == 6) {
                life1.isHidden = true
            }
        }
        
    }
    
    func keyboardAction(_ sender: UITapGestureRecognizer) {
        if (keyboardActive) {
            answerField.resignFirstResponder()
            keyboardActive = false
        } else {
            answerField.becomeFirstResponder()
            keyboardActive = true
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
