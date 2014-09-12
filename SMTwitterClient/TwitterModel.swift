//
//  TwitterModel.swift
//  SMTwitterClient
//
//  Created by Michael Ball on 9/1/14.
//  Copyright (c) 2014 Source Main LLC. All rights reserved.
//

import Foundation
import Social
import Accounts


class TwitterModel{
    
    var url : NSURL
    
    var entries : [TwitterEntry] = []
    var accountStore : ACAccountStore
    let params = ["count": "100"]
    
    init(){
        accountStore =  ACAccountStore()
        url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")

    }
    
    func userHasAccessToTwitter() -> Bool
    {
        return SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
    }

    
    func loadFeed(closure: () -> ()) {
        if (userHasAccessToTwitter()) {
            
            //  Step 1:  Obtain access to the user's Twitter accounts
            var twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            
            func onComplete ( granted:Bool, error:NSError!) {
                if (granted) {
                    //  Step 2:  Create a request
                    var twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
                    var request = SLRequest(forServiceType:SLServiceTypeTwitter, requestMethod:SLRequestMethod.GET, URL:url, parameters:params)
                    
                    //  Attach an account to the request
                    request.account = twitterAccounts[0] as ACAccount
                    
                    request.performRequestWithHandler({ (data:NSData!, response:NSHTTPURLResponse!, error:NSError!) -> Void in
                        var json = NSString(data:data, encoding:NSUTF8StringEncoding)
                        var jsonResults = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as [NSDictionary]
                        for jsonResult in jsonResults
                        {
                            self.entries.append(TwitterEntry(entry:jsonResult))
                        }
                        closure()
                    })
                }
                else {
                    // Access was not granted, or an error occurred
                    NSLog(error.localizedDescription);
                }
        }
            
            accountStore.requestAccessToAccountsWithType(twitterAccountType, options:nil, completion: onComplete)
        } else {
            NSLog("User is not signed into Twitter")
        }

    }
    
    func size() -> Int{
        return entries.count
    }
    
}

    