//
//  MusicVideoDetailViewController.swift
//  MusicVideo
//
//  Created by Nikola Majcen on 29/07/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MusicVideoDetailViewController: UIViewController {

    @IBOutlet weak var vName: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var vGenre: UILabel!
    @IBOutlet weak var vPrice: UILabel!
    @IBOutlet weak var vRights: UILabel!
    
    var video: Videos!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChange),
                                                         name: UIContentSizeCategoryDidChangeNotification, object: nil)
        title = video.vArtist
        vName.text = video.vName
        vGenre.text = video.vGenre
        vPrice.text = video.vPrice
        vRights.text = video.vRights
        
        if video.vImageData != nil {
            videoImage.image = UIImage(data: video.vImageData!)
        } else {
            videoImage.image = UIImage()
        }
    }
    
    func preferredFontChange() {
        vName.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vGenre.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vPrice.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vRights.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
    
    @IBAction func playVideo(sender: UIBarButtonItem) {
        let url = NSURL(string: video.vVideoUrl)
        let player = AVPlayer(URL: url!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        presentViewController(playerViewController, animated: true) { 
            playerViewController.player?.play()
        }
    }
}
