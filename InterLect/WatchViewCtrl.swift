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
    var isPanelist:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.password.resignFirstResponder()
        self.name.resignFirstResponder()
    }
    
    @IBAction func watchLecture(sender: AnyObject) {
        var daoLecture = DAOLecture()
        var lecture:Lecture
        var isPanelist:Bool
        if (self.password == nil || self.password.text == "" || self.name == nil || self.name.text == "") {
            //todo:alert em vez de println
            println("Please fill all the fields")
            return
        }
        if (daoLecture.authenticate(self.name.text,password: self.password.text)) {
            lecture = daoLecture.getLecture(self.name.text)!
            self.isPanelist = daoLecture.isPanelist(self.name.text,password: self.password.text)
        } else {
            //todo: alert em vez de println
            println("Wrong name or password")
            return
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "segueFromWatch"
//        {
//            if let destinationVC = segue.destinationViewController as? QuestionsTableViewCtrl{
//                destinationVC.isPanelist = self.isPanelist
//                destinationVC.nameLecture = self.name.text
//            }
//        }
//    }

}