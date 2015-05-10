//
//  AudienceQuestionsTableViewCtrl.swift
//  InterLect
//
//  Created by Eduardo Tolmasquim on 09/05/15.
//  Copyright (c) 2015 Eduardo Tolmasquim. All rights reserved.
//

import Foundation
import UIKit

class AudienceQuestionsTableViewController:UITableViewController {
    var nameLecture:String?
    var question = [String]()
    var refreshCtrl:UIRefreshControl!
    let dao = DAOLecture()
    
    @IBOutlet weak var addQuestion: UIBarButtonItem!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.question = dao.audienceGetQuestions(nameLecture!).reverse()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshCtrl = UIRefreshControl()
//        self.refreshCtrl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshCtrl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshCtrl)
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
    
    func refresh(sender:AnyObject){
        
        //code to refresh table
        if (self.nameLecture != nil) {
            dao.audienceGetQuestions(self.nameLecture!)
        }
        self.question = questions
        
        self.tableView.reloadData()
        
        self.refreshCtrl.endRefreshing()
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueFromAudienceQuestionsTableView"
        {
            if let destinationVC = segue.destinationViewController as? AddQuestionViewCtrl{
                destinationVC.lectureName = self.nameLecture
            }
        }
    }

}