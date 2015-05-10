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
    let dao = DAOLecture()
    
    @IBOutlet weak var addQuestion: UIBarButtonItem!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.question = dao.audienceGetQuestions(nameLecture!).reverse()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
       // cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
        
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