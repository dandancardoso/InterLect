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
        var ref = Firebase(url:"https://scorching-torch-3197.firebaseio.com/InterLect/Lectures")
        var passwords = ["panelist": lecture.panelistPassword!, "audience": lecture.audiencePassword!,"questions":["1":""]]
        var usersRef = ref.childByAppendingPath(lecture.name)
        usersRef.setValue(passwords)
        
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
        var ref = Firebase(url:"https://scorching-torch-3197.firebaseio.com/InterLect/Lectures/\(name)/questions")
        if (ref != nil) {
            ref.observeEventType(.Value, withBlock: { snapshot in
                for rest in snapshot.children.allObjects as! [FDataSnapshot] {
                    var question : NSString = rest.value as! NSString
                    questions.append(question as String)
                }
            })
        }
    }
}