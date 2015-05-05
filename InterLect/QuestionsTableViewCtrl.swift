//
//  QuestionsTableViewCtrl.swift
//  InterLect
//
//  Created by Eduardo Tolmasquim on 03/05/15.
//  Copyright (c) 2015 Eduardo Tolmasquim. All rights reserved.
//

import Foundation
import UIKit

class QuestionsTableViewCtrl:UITableViewController {
    
    var question = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.question = ["- What kind of sickness have you lied about so you wouldn't go to work?", "- Do you trust anyone with your life?", "- What is your greatest strength or weakness?"]
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.question.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.tableView!.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.font = UIFont(name: "Futura", size: 14.0)
        cell.textLabel?.numberOfLines = 0
        tableView.rowHeight = 70
        
        cell.textLabel?.text = question[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
        
    }

}
