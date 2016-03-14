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
            sendNotificationAt(time!)
        } else {
            waitTime.text = String(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the notification preferences
        localNotificationSettings()
        
        //Set up the notification listeners
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addOneToCount", name: "addOneNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "subOneFromCount", name: "subOneNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resetCount", name: "resetNotification", object: nil)
        
        //Load the count
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
    
    func sendNotificationAt(time: NSDate) {
        print("Sending notification at \(time)")
        
        //Create local notification
        let notification = UILocalNotification()
        notification.fireDate = time
        notification.alertBody = "The current count is \(count)"
        notification.alertAction = "Open App"
        
        //Sets it to a particular category type
        notification.category = "defaultCategory"
        
        //Delete all previous notifications and send the new one
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func localNotificationSettings() {
        let notificationSettings: UIUserNotificationSettings! = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        //Check if the settings have already been set, otherwise, set them
        if notificationSettings.types == .None {
            
            //Set up notification actions
            let addOneAction = UIMutableUserNotificationAction()
            addOneAction.identifier = "addOne"
            addOneAction.title = "Add One"
            addOneAction.activationMode = .Foreground
            addOneAction.destructive = false
            addOneAction.authenticationRequired = false
            
            let subOneAction = UIMutableUserNotificationAction()
            subOneAction.identifier = "subOne"
            subOneAction.title = "Sub One"
            subOneAction.activationMode = .Foreground
            subOneAction.destructive = false
            subOneAction.authenticationRequired = false
            
            let resetAction = UIMutableUserNotificationAction()
            resetAction.identifier = "reset"
            resetAction.title = "Reset Count"
            resetAction.activationMode = .Background
            resetAction.destructive = true
            resetAction.authenticationRequired = true
            
            //Set up the two different contexts
            let defaultActions = [resetAction, subOneAction, addOneAction]
            let minimalActions = [resetAction, addOneAction]
            
            //Set up the category
            //This is only useful if you have multiple categories, but it is necessary every time
            let notificationCategory = UIMutableUserNotificationCategory()
            notificationCategory.identifier = "defaultCategory"
            notificationCategory.setActions(defaultActions, forContext: .Default)
            notificationCategory.setActions(minimalActions, forContext: .Minimal)
            
            // Register the notification settings.
            let newNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: Set([notificationCategory]))
            UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
            
            
        }
        
    }

}

