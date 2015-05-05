//
//  Lecture.swift
//  InterLect
//
//  Created by Eduardo Tolmasquim on 03/05/15.
//  Copyright (c) 2015 Eduardo Tolmasquim. All rights reserved.
//

import Foundation

class Lecture {
    var name:String!
    var panelistPassword:String!
    var audiencePassword:String!
    var questions:[String]!
    
    init (name:String,panelistPassword:String,audiencePassword:String) {
        self.name = name
        self.panelistPassword = panelistPassword
        self.audiencePassword = audiencePassword
        self.questions = []
    }
}
