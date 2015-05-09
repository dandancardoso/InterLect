//
//  DAOLecture.swift
//  InterLect
//
//  Created by Eduardo Tolmasquim on 03/05/15.
//  Copyright (c) 2015 Eduardo Tolmasquim. All rights reserved.
//

import Foundation

var dataBase:FDataSnapshot?
var questions = [String]()

class DAOLecture {
    
    let rolePanelist = 0
    let roleAudience = 1
    
    func saveLecture(lecture:Lecture)->Bool {
        //verificar se pode criar!
        var refLectures = Firebase(url:"https://scorching-torch-3197.firebaseio.com/InterLect/Lectures")
        var passwords = ["panelist": lecture.panelistPassword!, "audience": lecture.audiencePassword!]
        var lec = refLectures.childByAppendingPath(lecture.name)
        lec.setValue(passwords)
        
        var refQuestions = Firebase(url:"https://scorching-torch-3197.firebaseio.com/InterLect/Questions")
        var questionText = ["ignore":""]
        var question = refQuestions.childByAppendingPath(lecture.name)
        question.setValue(questionText)
        
        return true
    }
    
    func nameAvailable(name:String)->Bool {
        var result = true
        if (dataBase != nil) {
            for rest in dataBase!.children.allObjects as! [FDataSnapshot] {
                var dict : NSDictionary = rest.value as! NSDictionary
                var count = 0
                if (name == rest.key)
                {
                    result = false
                }
                
            }
        }
        return result
    }
    
    func authenticate(name:String,password:String,role:Int)->Bool {
        var result = false
        if (dataBase != nil){
            for rest in dataBase!.children.allObjects as! [FDataSnapshot] {
                var dict : NSDictionary = rest.value as! NSDictionary
                if (name == rest.key)
                {
                    var panelist = dict["panelist"] as! String
                    var audience = dict["audience"] as! String
                    if (role == rolePanelist && password == panelist) {
                        result = true
                    }
                    if (role == roleAudience && password == audience) {
                        result = true
                    }
                }
            }
        }
        return result
    }
    
    func updateDataBase() {
        var ref = Firebase(url:"https://scorching-torch-3197.firebaseio.com/InterLect/Lectures")
        var keys = [AnyObject]()
        ref.observeEventType(.Value, withBlock: { snapshot in
            dataBase = snapshot
//            println(dataBase)
        })
    }
    
    func getLecture(name:String!)->Lecture? {
        var lecture:Lecture? = nil
        if (dataBase != nil) {
            for rest in dataBase!.children.allObjects as! [FDataSnapshot] {
                var dict : NSDictionary = rest.value as! NSDictionary
                if (name == rest.key)
                {
                    var panelist = dict["panelist"] as! String
                    var audience = dict["audience"] as! String
                    lecture = Lecture(name: name, panelistPassword: panelist, audiencePassword: audience)
                }
            }
        }
        return lecture
    }
    
    func updateQuestions(name:String) {
        var ref = Firebase(url:"https://scorching-torch-3197.firebaseio.com/InterLect/Questions/\(name)")
        if (ref != nil) {
            ref.observeEventType(.Value, withBlock: { snapshot in
                questions = [String]()
                var dict = snapshot.value as! NSDictionary
                for question in dict {
                    if (question.value as! String != "" || question.key as! String != "ignore") {
                        questions.append(question.value as! String)
                    }
                }
            })
        }
    }
    
    func deleteQuestion(lectureName:String,questionText:String) {
        var ref = Firebase(url:"https://scorching-torch-3197.firebaseio.com/InterLect/Questions/\(lectureName)")
        if (ref != nil) {
            ref.observeEventType(.Value, withBlock: { snapshot in
                var dic : NSDictionary = snapshot.value as! NSDictionary
                for q in dic {
                    if (questionText == q.value as! String) {
                        var r = Firebase(url:"https://scorching-torch-3197.firebaseio.com/InterLect/Questions/\(lectureName)/\(q.key)")
                        r.removeValue();
                        //why this break doesn't work? it still removes two questions when they are equal.
                        break
                    }
                }
            })
        }
    }
    
    
    func addQuestion(lectureName:String,questionText:String) {
        if (questionText != "") {
            var ref = Firebase(url:"https://scorching-torch-3197.firebaseio.com/InterLect/Questions/\(lectureName)")
            if (ref != nil) {
                //save in firebase
                var post1Ref = ref.childByAutoId()
                post1Ref.setValue(questionText)
            }
        }
    }

}