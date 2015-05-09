//
//  CreateViewCtrl.swift
//  InterLect
//
//  Created by Eduardo Tolmasquim on 03/05/15.
//  Copyright (c) 2015 Eduardo Tolmasquim. All rights reserved.
//

import Foundation
import UIKit

class CreateViewCtrl:UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var panelistPassword: UITextField!
    @IBOutlet weak var audiencePassword: UITextField!
    let isPanelist = true
    var nameAvailable = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var daoLecture = DAOLecture()
        daoLecture.updateDataBase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.resignFirstResponder()
        self.panelistPassword.resignFirstResponder()
        self.audiencePassword.resignFirstResponder()
    }
    
    @IBAction func createLecture(sender: AnyObject) {
        let daoLecture = DAOLecture()
        if (self.name == nil || self.name.text == "" || self.panelistPassword == nil || self.panelistPassword.text == "" || audiencePassword == nil || self.audiencePassword.text == "" ) {
            return
        }
        self.nameAvailable = daoLecture.nameAvailable(self.name.text)
        if (!self.nameAvailable) {
            return
        } else {
            var lecture = Lecture(name: self.name.text, panelistPassword: self.panelistPassword.text, audiencePassword: self.audiencePassword.text)
            if (daoLecture.saveLecture(lecture)) {
            } else {
                println("Error!")
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        var result = false
        if identifier == "segueFromCreate" {
            if (self.panelistPassword.text.isEmpty || self.name.text.isEmpty || self.audiencePassword.text.isEmpty) {
                
                let alert = UIAlertView()
                alert.title = "No Text"
                alert.message = "Please enter text in all boxes!"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                result = false
            }
            else if(!self.nameAvailable) {
                
                let alert = UIAlertView()
                alert.title = "Existing Name"
                alert.message = "Name already been used, please choose another one."
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                result = false
            }
            else {
                
                let alert = UIAlertView()
                alert.title = "Saved"
                alert.message = "Good Lecture!"
                alert.addButtonWithTitle("Ok")
                alert.show()
                result = true
            }
        }
        return result
    }

    
}