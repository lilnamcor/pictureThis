//
//  GameController.swift
//  PictureThis
//
//  Created by Itai Reuveni on 2/7/17.
//  Copyright © 2017 PictureThis. All rights reserved.
//

import UIKit

class GameController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    var currentFriend = ""
    var answer = ""
    var lenAnswer = 0.0
    var keyboardActive = false
    var currentText = ""
    var numWrongGuesses = 0.0
    var numRightGuesses = 0.0
    
    var finalImage = UIImage()
    
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
        
        // get these from server
        answer = "Akhil"
        lenAnswer = Double(answer.characters.count)
        finalImage = #imageLiteral(resourceName: "Cat")
        image.image = finalImage
        blur = 1.0
        zoom = 0.33
        brightness = 0.75
        xOffset = 50
        yOffset = 50
        ImageFilters.filters.setBlurImage(image: CIImage(cgImage: (image.image?.cgImage!)!))
        image.image = ImageFilters.filters.applyFilters(blurValue: blur, brightnessValue: brightness, image: CIImage(cgImage: (image.image?.cgImage!)!))
        
        var temp = ""
        for _ in answer.characters {
            temp += "_ "
        }
        
        
        
        answerField.delegate = self
        currentText = temp
        answerField.text = temp
        answerField.tintColor = UIColor.clear
        answerField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let tapGestureRecognizer = UITapGestureRecognizer(target:self,  action:#selector(keyboardAction(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
        self.scrollView.bouncesZoom = true
        self.scrollView.isUserInteractionEnabled = false
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = CGFloat(self.MAXZOOM)
        self.scrollView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        image.frame = self.view.layer.bounds
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
    
    func textFieldDidChange(_ textField: UITextField) {
        //your code
        let text = textField.text
        let lastChar = text?.substring(from:(text?.index((text?.endIndex)!, offsetBy: -1))!)
        let index = answer.lowercased().range(of:lastChar!)
        textField.text = currentText
        // correct guess
        if index != nil {
            numRightGuesses += 1
            textField.text = replace(myString: textField.text!, index: (index?.lowerBound)!, newCharac: lastChar!)
            currentText = textField.text!
            image.image = ImageFilters.filters.applyFilters(blurValue: ((blur*(lenAnswer-numRightGuesses))/lenAnswer), brightnessValue: ((brightness*(lenAnswer-numRightGuesses))/lenAnswer), image: CIImage(cgImage: (finalImage.cgImage!)))
            self.scrollView.zoomScale = CGFloat(((self.zoom*(lenAnswer-numRightGuesses))/lenAnswer)*(self.MAXZOOM-1)+1)
        } else {
            numWrongGuesses += 1
            if (numWrongGuesses == 3) {
                // game over
            } else {
                
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
