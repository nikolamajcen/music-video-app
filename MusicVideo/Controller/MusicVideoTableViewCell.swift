//
//  MusicVideoTableViewCell.swift
//  MusicVideo
//
//  Created by Nikola Majcen on 18/07/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class MusicVideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var musicTitle: UILabel!
    
    var video: Videos? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        musicTitle.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        rank.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        musicTitle.text = video?.vName
        rank.text = "\(video!.vRank)"
        if video?.vImageData != nil {
            musicImage.image = UIImage(data: video!.vImageData!)
        } else {
            getVideoImage(video!, imageView: musicImage)
        }
    }
    
    private func getVideoImage(video: Videos, imageView: UIImageView) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: NSURL(string: video.vImageUrl)!)
            
            var image: UIImage?
            if data != nil {
                video.vImageData = data
                image = UIImage(data: data!)
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                imageView.image = image
            })
        }
    }
}
