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
        self.question = throwNotDuplicatedToEnd(self.question, vet2: questions)
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
    
    func throwNotDuplicatedToEnd(vet1:[String],vet2:[String])->[String] {
        var newVet = vet1
        var tempVet = [String]()
        var i = 0
        for q in newVet {
            if (!isInVet(q, vet: vet2)) {
                tempVet.append(q)
                newVet.removeAtIndex(i)
            } else {
                i++
            }
        }
        for q in tempVet {
            newVet.append(q)
        }
        return newVet
    }
    
    func isInVet(val:String,vet:[String])->Bool {
        for q1 in vet {
            if (val == q1) {
                return true
            }
        }
        return false
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.tableView!.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "Futura", size: 14.0)
        cell.textLabel?.text = self.question[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        cell.textLabel?.text = self.question[indexPath.row]
        if (!isInVet(self.question[indexPath.row], vet: questions)) {
            cell.textLabel?.textColor = UIColor.redColor()
        } else {
            cell.textLabel?.textColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if (isInVet(self.question[indexPath.row], vet: questions)) {
                let alert = UIAlertView()
                alert.title = "Question wasn't answered!"
                alert.message = "Only questions that were answered can be deleted."
                alert.addButtonWithTitle("OK")
                alert.show()
            }
            else {
                self.question.removeAtIndex(indexPath.row)
                let currentCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell?;
                dao.audienceDeleteQuestion(self.nameLecture!, questionText:currentCell!.textLabel!.text!)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
    
    func refresh(sender:AnyObject){
        
        //code to refresh table
        if (self.nameLecture != nil) {
            self.question = dao.audienceGetQuestions(self.nameLecture!).reverse()
            self.question = throwNotDuplicatedToEnd(self.question, vet2: questions)
        }
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