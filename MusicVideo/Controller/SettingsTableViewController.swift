//
//  SettingsTableViewController.swift
//  MusicVideo
//
//  Created by Nikola Majcen on 30/07/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit

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
