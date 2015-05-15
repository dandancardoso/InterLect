//
//  AddQuestionViewCtrl.swift
//  InterLect
//
//  Created by Eduardo Tolmasquim on 03/05/15.
//  Copyright (c) 2015 Eduardo Tolmasquim. All rights reserved.
//

import Foundation
import UIKit

class AddQuestionViewCtrl:UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var arrow: UIImageView!
    var lectureName:String?
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()

    
    func progressBarDisplayer(indicator:Bool ) {
        
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 25, y: view.frame.midY - 25 , width: 50, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }

        view.addSubview(messageFrame)
    }

    func savingData() {
        if (self.question != nil && self.question.text != "" && self.lectureName != nil) {
            var dao = DAOLecture()
            let alert = UIAlertView()
            
            dao.addQuestion(self.lectureName!, questionText: self.question.text)
            //dao.updateQuestions(self.lectureName!)
            
            alert.title = "Question saved!"
            alert.message = "The question was sent to the panelist."
            alert.addButtonWithTitle("OK")
            alert.show()
            
        } else {
            let alert = UIAlertView()
            alert.title = "No text!"
            alert.message = "Please enter a text in the question box."
            alert.addButtonWithTitle("OK")
            alert.show()
            
        }
        self.question.text = ""
    }
    
    @IBAction func addQuestion(sender: AnyObject) {
        
        progressBarDisplayer(true)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.savingData()
            dispatch_async(dispatch_get_main_queue()) {
                self.messageFrame.removeFromSuperview()
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        self.question.resignFirstResponder()
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.arrow.hidden = true
        return true
    }
 

}