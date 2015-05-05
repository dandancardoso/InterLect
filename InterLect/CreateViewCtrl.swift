//
//  CreateViewCtrl.swift
//  InterLect
//
//  Created by Eduardo Tolmasquim on 03/05/15.
//  Copyright (c) 2015 Eduardo Tolmasquim. All rights reserved.
//

import Foundation
import UIKit

class CreateViewCtrl:UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var panelistPassword: UITextField!
    @IBOutlet weak var audiencePassword: UITextField!
    let isPanelist = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.resignFirstResponder()
        self.panelistPassword.resignFirstResponder()
        self.audiencePassword.resignFirstResponder()
    }
    
    @IBAction func createLecture(sender: AnyObject) {
        let daoLecture = DAOLecture()
        if (self.name == nil || self.name.text == "" || self.panelistPassword == nil || self.panelistPassword.text == "" || audiencePassword == nil || self.audiencePassword.text == "" ) {
            //todo: alert em vez de println
            println("Please fill all the fields")
            return
        }
        if (!daoLecture.nameAvailable(self.name.text)) {
            //todo: alert em vez de println
            println("This name has already been used, please choose another")
        } else {
            var lecture = Lecture(name: self.name.text, panelistPassword: self.panelistPassword.text, audiencePassword: self.audiencePassword.text)
            if (daoLecture.saveLecture(lecture)) {
                //todo: alert em vez de println
                println("Palestra salva!")
            } else {
                println("Erro! A palestra não foi salva.")
            }
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "segueFromCreate"
//        {
//            if let destinationVC = segue.destinationViewController as? QuestionsTableViewCtrl{
//                destinationVC.isPanelist = self.isPanelist
//                destinationVC.nameLecture = self.name.text
//            }
//        }
//    }
    
}