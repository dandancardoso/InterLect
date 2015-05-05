//
//  WatchViewCtrl.swift
//  InterLect
//
//  Created by Eduardo Tolmasquim on 03/05/15.
//  Copyright (c) 2015 Eduardo Tolmasquim. All rights reserved.
//

import Foundation
import UIKit

class WatchViewCtrl:UIViewController {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var role: UISegmentedControl!
    var isPanelist:Bool?
    var isAuthentic = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.password.resignFirstResponder()
        self.name.resignFirstResponder()
        var daoLecture = DAOLecture()
        role.selectedSegmentIndex = 0
    }
    
    @IBAction func watchLecture(sender: AnyObject) {
        var daoLecture = DAOLecture()
        var lecture:Lecture
        
        if (self.password == nil || self.password.text == "" || self.name == nil || self.name.text == "") {
            return
        }
        self.isAuthentic = daoLecture.authenticate(self.name.text,password: self.password.text,role:self.role.selectedSegmentIndex)
        println(self.isAuthentic)
        if (!self.isAuthentic) {
            return
        } else {
            var lecture = daoLecture.getLecture(self.name.text)
            self.isPanelist = daoLecture.isPanelist(self.name.text,password: self.password.text)
            return
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
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
                alert.title = "No Text"
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
                destinationVC.isPanelist = self.isPanelist
                destinationVC.nameLecture = self.name.text
            }
        }
    }

}