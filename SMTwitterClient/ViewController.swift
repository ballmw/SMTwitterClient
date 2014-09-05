//
//  ViewController.swift
//  SMTwitterClient
//
//  Created by Michael Ball on 8/26/14.
//  Copyright (c) 2014 Source Main LLC. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var twitterModel = TwitterModel();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        twitterModel.loadFeed() {
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return twitterModel.size();
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 100.0;
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as TweetCell;
        
        configureCell(cell, atIndexPath: indexPath);

        return cell;
    }
    
    func configureCell(cell: TweetCell, atIndexPath: NSIndexPath){
        cell.usernameLabel.text = self.twitterModel.entries[atIndexPath.row].username;
        cell.detailLabel.text = self.twitterModel.entries[atIndexPath.row].detail;
        
        var width = self.tableView.frame.size.width
        cell.usernameLabel.frame = CGRectMake(0,0, width, 0)
        cell.detailLabel.frame = CGRectMake(0,0, width, 0)
        
        cell.textLabel.sizeToFit()
        cell.detailLabel.sizeToFit();
        cell.sizeToFit();
    }
}

