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
import LocalAuthentication

class MusicVideoDetailViewController: UIViewController {

    @IBOutlet weak var vName: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var vGenre: UILabel!
    @IBOutlet weak var vPrice: UILabel!
    @IBOutlet weak var vRights: UILabel!
    
    var video: Video!
    var securitySwitch: Bool = false
    
    deinit {
        NSNotificationCenter
            .defaultCenter()
            .removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self, selector: #selector(preferredFontChange),
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
    
    @IBAction func socialMedia(sender: UIBarButtonItem) {
        securitySwitch = NSUserDefaults.standardUserDefaults().boolForKey("SecuritySettings")
        switch securitySwitch {
        case true:
            touchIdCheck()
        default:
            shareMedia()
        }
    }
    
    func touchIdCheck() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .Cancel, handler: nil))
        
        let context = LAContext()
        var touchIdError: NSError?
        let reasonString = "Touch ID authentification is needed to share information on Social Media."
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &touchIdError) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { success, policyError in
                if success == true {
                    dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                        self.shareMedia()
                    })
                } else {
                    alert.title = "Unsuccessful"
                    switch LAError(rawValue: policyError!.code)! {
                    case .AppCancel:
                        alert.message = "Authentification was cancelled by application."
                    case .AuthenticationFailed:
                        alert.message = "The user failed to provide valid credentials."
                    case .PasscodeNotSet:
                        alert.message = "Passcode is not set on the device."
                    case .SystemCancel:
                        alert.message = "Authentification was cancelled by the system."
                    case.TouchIDLockout:
                        alert.message = "Too many failed attempts."
                    case .UserCancel:
                        alert.message = "You cancelled the request."
                    case .UserFallback:
                        alert.message = "Password not accepted, must be Touch ID."
                    default:
                        alert.message = "Unable to authentificate."
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            })
        } else {
            alert.title = "Error"
            switch LAError(rawValue: touchIdError!.code)! {
            case .TouchIDNotEnrolled:
                alert.message = "Touch ID is not enrolled."
            case .TouchIDNotAvailable:
                alert.message = "Touch ID is not available."
            case .PasscodeNotSet:
                alert.message = "Passcode has not been set."
            case .InvalidContext:
                alert.message = "The context is invalid."
            default:
                alert.message = "Local authentification not available."
            }
            
            dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }
    }
    
    func shareMedia() {
        let videoTitle = "\(video.vName) by \(video.vArtist)"
        let videoUrl = "\nLink: \(video.vLinkToiTunes)"
        
        let activityViewController = UIActivityViewController(activityItems: [videoTitle, videoUrl], applicationActivities: nil)
        // activityViewController.excludedActivityTypes = [UIActivityTypeMail, UIActivityTypePostToTwitter]
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if activity == UIActivityTypeMail {
                print("Email selected")
            }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
}
