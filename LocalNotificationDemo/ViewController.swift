//
//  ViewController.swift
//  LocalNotificationDemo
//
//  Created by Cory Jbara on 3/13/16.
//  Copyright © 2016 Cory Jbara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var count = 0
    var defaults = NSUserDefaults.standardUserDefaults()
    
    //Outlets for storyboard
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var waitTime: UITextField!
    
    @IBAction func addOne(sender: UIButton) {
        addOneToCount()
    }
    @IBAction func subOne(sender: UIButton) {
        subOneFromCount()
    }
    @IBAction func sendNotification(sender: UIButton) {
        if let wait = Int(waitTime.text!) {
            let time = NSCalendar.currentCalendar().dateByAddingUnit(.Second, value: wait, toDate: NSDate(), options: [])
            print("Send notification at \(time!)")
        } else {
            waitTime.text = String(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCount()
    }
    
    func saveCount() {
        defaults.setInteger(count, forKey: "count")
    }
    
    func loadCount() {
        count = defaults.integerForKey("count")
        if count == 0 { saveCount() }
        countLabel.text = String(count)
    }
    
    func addOneToCount() {
        count++
        saveCount()
        countLabel.text = String(count)
    }
    
    func subOneFromCount() {
        count--
        saveCount()
        countLabel.text = String(count)
    }
    
    func resetCount() {
        count = 0
        saveCount()
        countLabel.text = String(count)
    }


}

