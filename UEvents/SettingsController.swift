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
    @IBOutlet var profilePictureView : UIImageView?
    var activeTabLayer:CALayer = CALayer()
    var appearanceController: AppearanceController = AppearanceController()
    var colors:Dictionary<String, Dictionary<String, String>> = AppearanceController().getColors()
    @IBOutlet weak var settings: UIBarButtonItem!
    @IBOutlet weak var myEvents: UIBarButtonItem!
    @IBOutlet weak var tags: UIBarButtonItem!
    @IBOutlet weak var allEvents: UIBarButtonItem!
    var user:User?
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
        allEvents.width = appearanceController.width/4 - 15
        allEvents.tintColor = appearanceController.colorWithHexString("#FFFFFF")
        settings.width = appearanceController.width/4 - 15
        settings.tintColor = appearanceController.colorWithHexString("#D6D6CE")
        myEvents.width = appearanceController.width/4 - 15
        myEvents.tintColor = appearanceController.colorWithHexString("#D6D6CE")
        tags.width = appearanceController.width/4 - 15
        tags.tintColor = appearanceController.colorWithHexString("#D6D6CE")
        UITabBar.appearance().selectedImageTintColor = UIColor.whiteColor()
        let xPos = (4 * (appearanceController.width/4)) - 44 - 16 - 15
        self.activeTabLayer.opacity = 0.5
        self.activeTabLayer.frame = CGRectMake(xPos, 0, 44+15, 44)
        self.activeTabLayer.backgroundColor = appearanceController.colorWithHexString("#B1746F").CGColor
        self.navigationController.toolbar.layer.addSublayer(self.activeTabLayer)

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Settings"
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
        var myEvents:MyEventsController = self.storyboard.instantiateViewControllerWithIdentifier("myevents") as MyEventsController
        myEvents.user = user!
        self.navigationController.pushViewController(myEvents, animated: false)
    }
    @IBAction func allEvents(sender: AnyObject){
        self.activeTabLayer.removeFromSuperlayer()
        var allEvents:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events") as EventsController
        allEvents.user = user!
        self.navigationController.pushViewController(allEvents, animated: false)
    }
}