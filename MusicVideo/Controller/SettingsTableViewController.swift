//
//  SettingsTableViewController.swift
//  MusicVideo
//
//  Created by Nikola Majcen on 30/07/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var aboutDisplay: UILabel!
    @IBOutlet weak var feedbackDisplay: UILabel!
    @IBOutlet weak var securityDisplay: UILabel!
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var bestImageQualityDisplay: UILabel!
    @IBOutlet weak var APICount: UILabel!
    @IBOutlet weak var sliderCount: UISlider!
    
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
        title = "Settings"
        tableView.alwaysBounceVertical = false
        
        touchID.on = NSUserDefaults.standardUserDefaults().boolForKey("SecuritySettings")
        if NSUserDefaults.standardUserDefaults().objectForKey("APICount") != nil {
            let value = NSUserDefaults.standardUserDefaults().objectForKey("APICount") as! Int
            APICount.text = "\(value)"
            sliderCount.value = Float(value)
        } else {
            sliderCount.value = 10.0
            APICount.text = "\(Int(sliderCount.value))"
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            let mailComposeViewController = configureMail()
            
            if MFMailComposeViewController.canSendMail() {
                presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                mailAlert()
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    @IBAction func touchIDSecurity(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if touchID.on == true {
            defaults.setBool(true, forKey: "SecuritySettings")
        } else {
            defaults.setBool(false, forKey: "SecuritySettings")
        }
    }
    
    @IBAction func valueChanged(sender: UISlider) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(Int(sliderCount.value), forKey: "APICount")
        APICount.text = ("\(Int(sliderCount.value))")
    }
    
    func preferredFontChange() {
        aboutDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        feedbackDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        securityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        bestImageQualityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        APICount.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }
}

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    
    private func configureMail() -> MFMailComposeViewController {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients(["user@example.com"])
        mailComposeViewController.setSubject("Music Video Application Feedback")
        mailComposeViewController.setMessageBody("Enter feedback below: ", isHTML: false)
        return mailComposeViewController
    }
    
    private func mailAlert() {
        let alertController = UIAlertController(title: "No e-email account",
                                                message: "No e-mail account for this iPhone. Please setup account.",
                                                preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail canceled.")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved.")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent.")
        case MFMailComposeResultFailed.rawValue:
            print("Mail failed.")
        default:
            print("Unknown issue.")
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}
