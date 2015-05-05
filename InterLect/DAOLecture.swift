//
//  DAOLecture.swift
//  InterLect
//
//  Created by Eduardo Tolmasquim on 03/05/15.
//  Copyright (c) 2015 Eduardo Tolmasquim. All rights reserved.
//

import Foundation

var dataBase:FDataSnapshot?

class DAOLecture {
    
    func saveLecture(lecture:Lecture)->Bool {
        //verificar se pode criar!
        var ref = Firebase(url:"https://scorching-torch-3197.firebaseio.com/InterLect/Lectures")
        var passwords = ["panelist": lecture.panelistPassword!, "audience": lecture.audiencePassword!]
        var usersRef = ref.childByAppendingPath(lecture.name)
        usersRef.setValue(passwords)
        
        return true
    }
    
    func nameAvailable(name:String)->Bool {
        return true
    }
    
    func authenticate(name:String,password:String)->Bool {
        return true
    }
    
    func beginDataBase() {
        var ref = Firebase(url:"https://scorching-torch-3197.firebaseio.com/InterLect/Lectures/class 1")
        ref.observeEventType(.Value, withBlock: { snapshot in
            println(snapshot.value)
            dataBase = snapshot
            println(dataBase)
        })

    }
    
    func getLecture(name:String)->Lecture? {
        //println(dataBase!.value["class 1"])
        
//        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            
//            snapshot.value["panelist"]
//            var temp:AnyObject! = snapshot.value["panelist"]
//            self.panelistPassword = "\(temp)"
//            println(self.panelistPassword!)
//            temp = snapshot.value["audience"]
//            self.audiencePassword = "\(temp)"
//            println(self.audiencePassword!)
//            self.semaphor = true
//        })
        
//        ref.observeEventType(.Value, withBlock: { snapshot in
//            snapshot.value["panelist"]
//            var temp:AnyObject! = snapshot.value["panelist"]
//            panelistPassword = "\(temp)"
//            println(panelistPassword)
//            temp = snapshot.value["audience"]
//            audiencePassword = "\(temp)"
//            println(audiencePassword)
//            }, withCancelBlock: { error in
//                println(error.description)
//        })
        return nil
    }
    
    func isPanelist(name:String,password:String)->Bool {
        return true
    }
    
    func getQuestions(name:String)->[String] {
        return ["a","b","c","d","e"]
    }
}