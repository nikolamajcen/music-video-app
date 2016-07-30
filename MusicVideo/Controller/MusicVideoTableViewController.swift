//
//  MusicVideoTableViewController.swift
//  MusicVideo
//
//  Created by Nikola Majcen on 18/07/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class MusicVideoTableViewController: UITableViewController {
    
    var videos = [Videos]()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reachabilityStatusChanged),
                                                         name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: nil,
                                                         name: UIContentSizeCategoryDidChangeNotification, object: nil)
        reachabilityStatusChanged()
    }
    
    func runAPI() {
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=200/json", completion: didLoadData)
    }
    
    func didLoadData(videos: [Videos]) {
        self.videos = videos
        tableView.reloadData()
    }
    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
        case NOACCESS:
            dispatch_async(dispatch_get_main_queue(), { 
                let alert = UIAlertController(title: "No internet access",
                    message: "Please make sure you are connected to internet",
                    preferredStyle: .Alert)
                let cancelActon = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
                    print("Cancel")
                })
                
                let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) in
                    print("Delete")
                })
                
                let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                    print("OK")
                    
                    alert.dismissViewControllerAnimated(true, completion: nil)
                })
                
                alert.addAction(okAction)
                alert.addAction(cancelActon)
                alert.addAction(deleteAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            })
        default:
            if videos.count == 0 {
                runAPI()
            } else {
                print("Do not refresh API")
            }
        }
    }
    
    private struct storyboard {
        static let musicVideoReuseIdentifier = "MusicVideoCell"
        static let musicVideoDetailSegueIdentifier = "MusicVideoDetailSegue"
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.musicVideoReuseIdentifier, forIndexPath: indexPath)
            as! MusicVideoTableViewCell
        cell.video = videos[indexPath.row]
        return cell
    }
    
    // MARK - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == storyboard.musicVideoDetailSegueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                let video = videos[indexPath.row]
                let destionationViewController = segue.destinationViewController as! MusicVideoDetailViewController
                destionationViewController.video = video
            }
        }
    }
    
}
