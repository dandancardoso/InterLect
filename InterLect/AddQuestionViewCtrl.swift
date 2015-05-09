//
//  AddQuestionViewCtrl.swift
//  InterLect
//
//  Created by Eduardo Tolmasquim on 03/05/15.
//  Copyright (c) 2015 Eduardo Tolmasquim. All rights reserved.
//

import Foundation
import UIKit

class AddQuestionViewCtrl:UIViewController {
    
    @IBOutlet weak var question: UITextField!
    var lectureName:String?
    
    @IBAction func addQuestion(sender: AnyObject) {
        if (self.question != nil && self.question.text != "" && self.lectureName != nil) {
            var dao = DAOLecture()
            dao.addQuestion(self.lectureName!, questionText: self.question.text)
            dao.updateQuestions(self.lectureName!)
        }
    }
}