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
private var handler:UInt?

extension String  {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        var hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.dealloc(digestLen)
        
        return String(format: hash as String)
    }
}

class DAOLecture {
    
    let rolePanelist = 1
    let roleAudience = 0
    
    ////////////////////////////////////////////////////////////////////////////////////
    // Não esquecer de trocar o firebase quando passar do desenvolvimento para produção
    //
    // Firebase para desenvolvimento
    let firebasePath = "https://interlectdev.firebaseio.com/InterLect/"
    //
    // Firebase para producao
    // let firebasePath = "https://scorching-torch-3197.firebaseio.com/InterLect/"
    ///////////////////////////////////////////////////////////////////////////////////
    
    func saveLecture(lecture:Lecture)->Bool {
        //verificar se pode criar!
        var refLectures = Firebase(url:firebasePath+"Lectures")
        var passwords = ["panelist": lecture.panelistPassword!.md5, "audience": lecture.audiencePassword!.md5]
        var lec = refLectures.childByAppendingPath(lecture.name)
        lec.setValue(passwords)
        
        var refQuestions = Firebase(url:firebasePath+"Questions")
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
                    if (role == rolePanelist && password.md5 == panelist) {
                        result = true
                    }
                    if (role == roleAudience && password.md5 == audience) {
                        result = true
                    }
                }
            }
        }
        return result
    }
    
    func updateDataBase() {
        var ref = Firebase(url:firebasePath+"Lectures")
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
    
    func dateOneOlder(dateOne:NSDate,dateTwo:NSDate)->Bool {
        switch (dateOne.compare(dateTwo)){
            case NSComparisonResult.OrderedAscending:
                return true
            case NSComparisonResult.OrderedSame:
                return false
            case NSComparisonResult.OrderedDescending:
                return false
        }
    }
    
    func sortByDate(array:[NSDate])->[NSDate] {
        var arrayCopy = [AnyObject]()
        arrayCopy = array as Array<AnyObject>
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd:HH:mm:ss:SS"
        for (var j=0;j<arrayCopy.count;j++) {
            for (var i=0;i<arrayCopy.count-1;i++) {
                var date1 = dateFormatter.dateFromString(arrayCopy[i] as! String)
                var date2 = dateFormatter.dateFromString(arrayCopy[i+1] as! String)
                if (dateOneOlder(date1!, dateTwo: date2!)) {
                    var temp: (AnyObject) = arrayCopy[i]
                    arrayCopy[i] = arrayCopy[i+1]
                    arrayCopy[i+1] = temp
                }
            }
        }
        return arrayCopy as! [NSDate]
    }
    
    func arrayFromDictSortedByDate(dict:NSDictionary)->[String] {
        var dictCopy: AnyObject = dict.mutableCopy()
        var keys = dict.allKeys as Array<AnyObject>
        //keys.sort(dateOneMoreRecent)
        keys = sortByDate(keys as! [NSDate])
        var array = [AnyObject]()
        for key in keys {
            array.append(dictCopy[(key as! String)] as! String)
        }
        return array as! [String]
    }
    
    func updateQuestions(name:String) {
        questions = [String]()
        var ref = Firebase(url:firebasePath+"/Questions/\(name)")
        if (ref != nil) {
            if (handler != nil) {
                ref.removeObserverWithHandle(handler!)
            }
            handler = ref.observeEventType(.Value, withBlock: { snapshot in
                if (snapshot.exists()) {
                    var dict = snapshot.value as! NSMutableDictionary
                    dict.removeObjectForKey("ignore")
                    questions = self.arrayFromDictSortedByDate(dict) as [String]
                }
            })
        }
    }
    
    func deleteQuestion(lectureName:String,questionText:String) {
        var ref = Firebase(url:firebasePath+"Questions/\(lectureName)")
        if (ref != nil) {
            ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                if (snapshot.exists()) {
                    var dic : NSDictionary = snapshot.value as! NSDictionary
                    for q in dic {
                        if (questionText == q.value as! String) {
                            var r = Firebase(url:self.firebasePath+"/Questions/\(lectureName)/\(q.key)")
                            r.removeValue();
                            //why this break doesn't work? it still removes two questions when they are equal.
                            break
                        }
                    }
                }
            })
        }
    }
    
    func stringFromCurrentDate()->String {
        var date = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd:HH:mm:ss:SS"
        return dateFormatter.stringFromDate(date)
    }
    
    func addQuestion(lectureName:String,questionText:String) {
        if (questionText != "") {
            var ref = Firebase(url:firebasePath+"Questions/\(lectureName)")
            if (ref != nil) {
                var key = stringFromCurrentDate()
                var post1Ref = ref.childByAppendingPath(key)
                post1Ref.setValue(questionText)
                self.audienceAddQuestion(lectureName, questionText: questionText)
            }
        }
    }
    
    func audienceAddQuestion(lectureName:String,questionText:String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var quests = self.audienceGetQuestions(lectureName)
        quests.append(questionText)
        defaults.setObject(quests, forKey: lectureName)
    }
    
    func audienceGetQuestions(lectureName:String)->[String] {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let quests = defaults.arrayForKey(lectureName)
        {
            return quests as! [String]
        }
        return []
    }
    
    func audienceDeleteQuestion(lectureName:String, questionText:String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        var quests = self.audienceGetQuestions(lectureName)
        for (var i=0;i<quests.count;i++) {
            if (quests[i] == questionText) {
                quests.removeAtIndex(i)
            }
        }
        defaults.setObject(quests, forKey: lectureName)
    }

}