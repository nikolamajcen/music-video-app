//
//  MusicVideoDetailViewController.swift
//  MusicVideo
//
//  Created by Nikola Majcen on 29/07/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

class MusicVideoDetailViewController: UIViewController {

    @IBOutlet weak var vName: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var vGenre: UILabel!
    @IBOutlet weak var vPrice: UILabel!
    @IBOutlet weak var vRights: UILabel!
    
    var video: Videos!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
