//
//  ViewController.swift
//  MusicVideo
//
//  Created by Nikola Majcen on 17/07/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var videos = [Videos]()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
        case NOACCESS: view.backgroundColor = UIColor.redColor()
        case WIFI: view.backgroundColor = UIColor.greenColor()
        case WWAN: view.backgroundColor = UIColor.yellowColor()
        default: return
        }
    }
}

