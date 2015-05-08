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
    var isPanelist:Bool?
    var nameLecture:String?
    var refreshCtrl:UIRefreshControl!
    let dao = DAOLecture()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (self.nameLecture != nil) {
            dao.updateQuestions(self.nameLecture!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.refreshCtrl = UIRefreshControl()
        self.refreshCtrl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshCtrl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshCtrl)
        self.question = questions
        
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
        
        cell.textLabel?.text = self.question[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.question.removeAtIndex(indexPath.row)
            let currentCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell?;
            dao.deleteQuestion(self.nameLecture!, questionText:currentCell!.textLabel!.text!)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            println(indexPath)
        }
    }

    func refresh(sender:AnyObject){
        
        //code to refresh table
        
        
        self.tableView.reloadData()
        
        self.refreshCtrl.endRefreshing()
    }

}
