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
//        var path = "https://scorching-torch-3197.firebaseio.com/InterLect/Lectures/\(name)"
//        var ref = Firebase(url:path)
//        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
//            let panelistPassword = snapshot.value.objectForKey("panelist") as? String
//            let audiencePassword = snapshot.value.objectForKey("audience") as? String
//            println("panelist:\(panelistPassword) audience:\(audiencePassword)")
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