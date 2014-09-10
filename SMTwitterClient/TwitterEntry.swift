//
//  TwitterEntry.swift
//  SMTwitterClient
//
//  Created by Michael Ball on 9/1/14.
//  Copyright (c) 2014 Source Main LLC. All rights reserved.
//

import Foundation
import UIKit

class TwitterEntry {
    var twitterEntryID: NSString = ""
    var username: NSString = ""
    var userIcon : UIImage = UIImage()
    var detail : NSString = ""
    var iconImageUrl: NSString = ""
    
    init(entry:NSDictionary){
        self.twitterEntryID = entry["id_str"] as NSString
        var user = entry["user"] as NSDictionary
        self.username = user["name"] as NSString
        self.detail = entry["text"] as NSString
        self.iconImageUrl = user["profile_image_url"] as NSString
    }
    
    func loadImage(closure: (UIImage) -> ()) {
        let url = NSURL(string: self.iconImageUrl)
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration:config)
        
        func onComplete( data:NSData!,  response:NSURLResponse!, error:NSError!) {
            if (response.isKindOfClass(NSHTTPURLResponse))
            {
                let httpResponse = response as NSHTTPURLResponse;
                
                if (httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299)
                {
                    let image = UIImage(data:data);
                    closure(image);
                }
            }
        };
        
        let task = session.dataTaskWithURL(url, completionHandler:onComplete);
        
        task.resume();
    }
}