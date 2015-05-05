//
//  DAOLecture.swift
//  InterLect
//
//  Created by Eduardo Tolmasquim on 03/05/15.
//  Copyright (c) 2015 Eduardo Tolmasquim. All rights reserved.
//

import Foundation

class DAOLecture {
    
    func saveLecture(lecture:Lecture)->Bool {
        //verificar se pode criar!
        var ref = Firebase(url:"https://scorching-torch-3197.firebaseio.com/InterLect/Lectures")
        var passwords = ["panelist": lecture.panelistPassword, "audience": lecture.audiencePassword]
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
    
    func getLecture(name:String)->Lecture? {
        //var path = "https://scorching-torch-3197.firebaseio.com/InterLect/Lectures/\(name)/panelist"
//        let ref = Firebase(url:"https://scorching-torch-3197.firebaseio.com/InterLect/Lectures/\(name)")
//        ref.queryOrderedByChild("panelist").observeEventType(.ChildAdded, withBlock: { snapshot in
//            if let panelist = snapshot.value["panelist"] as? String {
//                println("\(snapshot.key) is \(panelist)")
//            }
//        })
        return Lecture(name: "teste", panelistPassword: "teste", audiencePassword: "teste")
    }
    
    func isPanelist(name:String,password:String)->Bool {
        return true
    }
    
    func getQuestions(name:String)->[String] {
        return ["a","b","c","d","e"]
    }
}