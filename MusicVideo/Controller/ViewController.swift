//
//  ViewController.swift
//  MusicVideo
//
//  Created by Nikola Majcen on 17/07/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var displayLabel: UILabel!
    
    var videos = [Videos]()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged),
                                                         name: "ReachStatusChanged", object: nil)
        reachabilityStatusChanged()
        
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json", completion: didLoadData)
    }
    
    func didLoadData(videos: [Videos]) {
        print(reachabilityStatus)
        
        self.videos = videos
        
        for item in videos {
            print("Name: \(item.vName)")
        }
        
        tableView.reloadData()
    }
    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
        case NOACCESS: view.backgroundColor = UIColor.redColor()
        case WIFI: view.backgroundColor = UIColor.greenColor()
        case WWAN: view.backgroundColor = UIColor.yellowColor()
        default: break
        }
        displayLabel.text = reachabilityStatus
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MusicVideoCell", forIndexPath: indexPath)
        let video = videos[indexPath.row]
        
        cell.textLabel?.text = "\(indexPath.row + 1). \(video.vName)"
        cell.detailTextLabel?.text = video.vArtist
        
        return cell
    }
}

