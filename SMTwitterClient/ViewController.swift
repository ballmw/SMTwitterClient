//
//  ViewController.swift
//  SMTwitterClient
//
//  Created by Michael Ball on 8/26/14.
//  Copyright (c) 2014 Source Main LLC. All rights reserved.
//

import UIKit
import Social

class ViewController: UITableViewController {
    
    let twitterModel = TwitterModel()
    
    @IBOutlet var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        twitterModel.loadFeed {
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
        }
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func refresh(sender:AnyObject){
        NSLog("refreshing");
        twitterModel.loadFeed {
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twitterModel.size()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as TweetCell
        
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: TweetCell, atIndexPath: NSIndexPath){
        cell.usernameLabel.text = self.twitterModel.entries[atIndexPath.row].username
        cell.detailLabel.text = self.twitterModel.entries[atIndexPath.row].detail
        
        var width = self.tableView.frame.size.width
        cell.usernameLabel.frame = CGRectMake(0,0, width, 0)
        cell.detailLabel.frame = CGRectMake(0,0, width, 0)
        
        cell.detailLabel.sizeToFit()
        
        cell.iconImage.image = UIImage(named:"Placeholder.png")
        
        self.twitterModel.entries[atIndexPath.row].loadImage{ (image: UIImage) in
            
            dispatch_async(dispatch_get_main_queue()){
                cell.iconImage.alpha = 0
                cell.iconImage.image = image
                UIView.animateWithDuration(1.0, animations:{
                    cell.iconImage.alpha = 1
                })
                
            }
        }
        
        cell.sizeToFit()
    }
    
    @IBAction func doPost(sender: AnyObject) {
        if(SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)){
            let composer = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
            
            func completionHandler(result:SLComposeViewControllerResult) {
                switch (result) {
                case SLComposeViewControllerResult.Cancelled:
                    NSLog("Post Canceled");
                    break;
                case SLComposeViewControllerResult.Done:
                    NSLog("Post Sucessful");
                    break;
                default:
                    break;
                }
            }
            
            composer.completionHandler = completionHandler
            
            self.presentViewController(composer, animated: true, completion: { () -> Void in } )
            
        }
    }

}

