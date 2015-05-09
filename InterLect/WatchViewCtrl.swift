//
//  WatchViewCtrl.swift
//  InterLect
//
//  Created by Eduardo Tolmasquim on 03/05/15.
//  Copyright (c) 2015 Eduardo Tolmasquim. All rights reserved.
//

import Foundation
import UIKit

class WatchViewCtrl:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var role: UISegmentedControl!
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    var isPanelist:Bool?
    var isAuthentic = false
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var daoLecture = DAOLecture()
        daoLecture.updateDataBase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.password.resignFirstResponder()
        self.name.resignFirstResponder()
        var daoLecture = DAOLecture()
        role.selectedSegmentIndex = 0
    }
    
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        println(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    func loadingData () {
        var daoLecture = DAOLecture()
        var lecture:Lecture
        
        if (self.password == nil || self.password.text == "" || self.name == nil || self.name.text == "") {
            return
        }
        self.isAuthentic = daoLecture.authenticate(self.name.text,password: self.password.text,role:self.role.selectedSegmentIndex)
        if (!self.isAuthentic) {
            return
        } else {
            var lecture = daoLecture.getLecture(self.name.text)
            daoLecture.updateQuestions(self.name.text)
            return
        }
        
    }
    
    @IBAction func watchLecture(sender: AnyObject) {
        
        progressBarDisplayer("Loading data", true)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.loadingData()
            dispatch_async(dispatch_get_main_queue()) {
                self.messageFrame.removeFromSuperview()
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func editingDidEnd(sender: AnyObject) {
        var daoLecture = DAOLecture()
        if (self.name != nil && self.name.text != "") {
            daoLecture.updateQuestions(self.name.text)
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        var daoLecture = DAOLecture()
        self.isAuthentic = daoLecture.authenticate(self.name.text,password: self.password.text,role:self.role.selectedSegmentIndex)
        if identifier == "segueFromWatch" {
            if (self.password.text.isEmpty || self.name.text.isEmpty) {
                
                let alert = UIAlertView()
                alert.title = "No Text"
                alert.message = "Please enter text in all boxes!"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                return false
            }
            else if(!self.isAuthentic) {
                
                let alert = UIAlertView()
                alert.title = "Authentication Error"
                alert.message = "Name or password incorrect"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                return false
            }
            else {
                return true
            }
        }
        
        // by default, transition
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueFromWatch"
        {
            if let destinationVC = segue.destinationViewController as? QuestionsTableViewCtrl{
                if (self.role.selectedSegmentIndex == 0) {
                    destinationVC.isPanelist = true
                } else {
                    destinationVC.isPanelist = false
                }
                destinationVC.nameLecture = self.name.text
            }
        }
    }
}