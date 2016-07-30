//
//  MusicVideoTableViewController.swift
//  MusicVideo
//
//  Created by Nikola Majcen on 18/07/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class MusicVideoTableViewController: UITableViewController {
    
    var videos = [Video]()
    var filterSearch = [Video]()
    let resultSearchController = UISearchController(searchResultsController: nil)
    var limit = 10
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self,
                         selector: #selector(reachabilityStatusChanged),
                         name: "ReachStatusChanged", object: nil)
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self, selector: nil,
                         name: UIContentSizeCategoryDidChangeNotification, object: nil)
        reachabilityStatusChanged()
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        refreshControl?.endRefreshing()
        if resultSearchController.active == true {
            refreshControl?.attributedTitle = NSAttributedString(string: "Refresh is not allowed here.")
        } else {
            runAPI()
        }
    }
    
    
    func getAPICount() {
        if NSUserDefaults.standardUserDefaults().objectForKey("APICount") != nil {
            let value = NSUserDefaults.standardUserDefaults().objectForKey("APICount") as! Int
            limit = value
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let refreshDate = formatter.stringFromDate(NSDate())
        refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDate)")
    }
    
    func runAPI() {
        getAPICount()
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", completion: didLoadData)
    }
    
    func didLoadData(videos: [Video]) {
        self.videos = videos
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        title = "The iTunes Top \(limit) Music Videos"
        
        definesPresentationContext = true
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search for Artist, Name, Rank"
        resultSearchController.searchBar.searchBarStyle = .Prominent
        tableView.tableHeaderView = resultSearchController.searchBar
        
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
        if resultSearchController.active == true {
            return filterSearch.count
        }
        return videos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.musicVideoReuseIdentifier, forIndexPath: indexPath)
            as! MusicVideoTableViewCell
        
        if resultSearchController.active == true {
            cell.video = filterSearch[indexPath.row]
        } else {
            cell.video = videos[indexPath.row]
        }
        return cell
    }
    
    // MARK - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == storyboard.musicVideoDetailSegueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                let video: Video
                if resultSearchController.active == true {
                    video = filterSearch[indexPath.row]
                } else {
                    video = videos[indexPath.row]
                }
                let destionationViewController = segue.destinationViewController as! MusicVideoDetailViewController
                destionationViewController.video = video
            }
        }
    }
}

extension MusicVideoTableViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchController.searchBar.text?.lowercaseString
        filterSearch(searchController.searchBar.text!)
    }
    
    private func filterSearch(searchText: String) {
        filterSearch = videos.filter { videos in
            return videos.vArtist.lowercaseString.containsString(searchText.lowercaseString)
                || videos.vName.lowercaseString.containsString(searchText.lowercaseString)
                || "\(videos.vRank)".lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
}
