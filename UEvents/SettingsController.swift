//
//  SettingsController.swift
//  UEvents
//
//  Created by Sameet Sapra on 7/3/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
class SettingsController: GAITrackedViewController, FBLoginViewDelegate{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var profilePictureView : UIImageView?
    var activeTabLayer:CALayer = CALayer()
    var appearanceController: AppearanceController = AppearanceController()
    var colors:Dictionary<String, Dictionary<String, String>> = AppearanceController().getColors()
    @IBOutlet weak var settings: UIBarButtonItem!
    @IBOutlet weak var myEvents: UIBarButtonItem!
    @IBOutlet weak var tags: UIBarButtonItem!
    @IBOutlet weak var allEvents: UIBarButtonItem!
    var user:User?
    var alreadyLoggedOut:Bool = false
    override func viewDidLoad() {
        var imgURL: NSURL = NSURL(string: "http://graph.facebook.com/\(user!.id)/picture?width=200&height=200")
        setUpUI()
        var imgData: NSData = NSData(contentsOfURL: imgURL)
        profilePictureView!.image = UIImage(data: imgData)
        profilePictureView!.layer.cornerRadius = profilePictureView!.frame.size.width/2
        profilePictureView!.layer.masksToBounds = true
        profilePictureView!.layer.borderWidth = 0
        if (self.respondsToSelector("setEdgesForExtendedLayout:")) { // if iOS 7
            self.edgesForExtendedLayout = UIRectEdge.None //layout adjustements
        }
        name.text = user!.name
        school.text = user!.schoolName as String
//        for sub in self.loginView.subviews{
//            if let button = sub as? UIButton{
//                button.backgroundColor = appearanceController.colorWithHexString(colors["UChicago"]!["Primary"]!)
//                button.setBackgroundImage(nil, forState: UIControlState.Normal)
//                button.setBackgroundImage(nil, forState: UIControlState.Highlighted)
//                button.setBackgroundImage(nil, forState: UIControlState.Selected)
//            }
//        }
        fixAnimation()
    }
    func fixAnimation(){
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //make calculations
            dispatch_async(dispatch_get_main_queue(),{
                UIView.setAnimationsEnabled(true)
            })
        })
    }
    func setUpUI(){
        self.navigationController.interactivePopGestureRecognizer.enabled = false;
        self.navigationController.navigationBar.barTintColor = appearanceController.colorWithHexString(colors["UChicago"]!["Primary"]!)
        self.navigationController.navigationBar.tintColor = appearanceController.colorWithHexString(colors["Default"]!["Secondary"]!)
        self.navigationItem.hidesBackButton = true
        self.navigationController.toolbar.opaque = true
        self.navigationController.toolbar.barTintColor = appearanceController.colorWithHexString(colors["UChicago"]!["Primary"]!)
        self.navigationController.toolbarHidden = false
        self.view.userInteractionEnabled = true
        allEvents.width = appearanceController.width/4 - allEvents.image.size.width/2
        allEvents.tintColor = UIColor.lightGrayColor()
        settings.width = appearanceController.width/4 - settings.image.size.width/2
        settings.tintColor = UIColor.whiteColor()
        myEvents.width = appearanceController.width/4 - myEvents.image.size.width/2
        myEvents.tintColor = UIColor.lightGrayColor()
        tags.width = appearanceController.width/4 - tags.image.size.width/2
        tags.tintColor = UIColor.lightGrayColor()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Settings"
    }

    
    @IBAction func handleLogOut(sender: AnyObject) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        FBSession.activeSession().closeAndClearTokenInformation()
        appDelegate.session!.closeAndClearTokenInformation()
        var home:UIViewController = self.storyboard.instantiateViewControllerWithIdentifier("login") as UIViewController
        self.navigationController.pushViewController(home, animated: true)
    }
    @IBAction func settings(sender : AnyObject) {
        self.activeTabLayer.removeFromSuperlayer()
        var settings:SettingsController = self.storyboard.instantiateViewControllerWithIdentifier("settings") as SettingsController
        settings.user = user!
        self.navigationController.pushViewController(settings, animated: false)
    }
    @IBAction func tags(sender: AnyObject){
        self.activeTabLayer.removeFromSuperlayer()
        var tagsController:TagsController = self.storyboard.instantiateViewControllerWithIdentifier("tags") as TagsController
        tagsController.user = user!
        self.navigationController.pushViewController(tagsController, animated: false)
    }
    @IBAction func myEvents(sender: AnyObject){
        self.activeTabLayer.removeFromSuperlayer()
        var myEvents:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events") as EventsController
        myEvents.user = user!
        myEvents.tag = "User"
        self.navigationController.pushViewController(myEvents, animated: false)
    }
    @IBAction func allEvents(sender: AnyObject){
        self.activeTabLayer.removeFromSuperlayer()
        var allEvents:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events") as EventsController
        allEvents.user = user!
        allEvents.tag = "All"
        self.navigationController.pushViewController(allEvents, animated: false)
    }
}