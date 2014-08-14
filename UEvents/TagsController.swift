//
//  TagsController.swift
//  UEvents
//
//  Created by Sameet Sapra on 7/4/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class TagsController:GAITrackedViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    var user:User?
    var activeTabLayer:CALayer = CALayer()
    @IBOutlet var collectionView : UICollectionView?
    var firstTime:Bool = true
    var appearanceController: AppearanceController = AppearanceController()
    var school:String = ""
    var colors:Dictionary<String, Dictionary<String, String>> = AppearanceController().getColors()
    var width = UIScreen.mainScreen().bounds.size.width
    var height = UIScreen.mainScreen().bounds.size.height
    var tagPhotos:[String] = ["Tag-All", "Tag-Food", "Tag-Music", "Tag-Nightlife", "Tag-Off-Campus","Tag-Sports"]
    @IBOutlet var scrollView : UIScrollView?
    
    @IBOutlet weak var allEvents: UIBarButtonItem!
    @IBOutlet weak var settings: UIBarButtonItem!
    @IBOutlet weak var myEvents: UIBarButtonItem!
    @IBOutlet weak var tags: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        scrollView!.scrollEnabled = true
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "TagCell")
        self.collectionView!.reloadData()
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
        let xPos = (2 * (appearanceController.width/4)) - 44 - 16 - 5
        self.activeTabLayer.opacity = 0.5
        self.activeTabLayer.frame = CGRectMake(xPos, 0, 44+15, 44)
        self.activeTabLayer.backgroundColor = appearanceController.colorWithHexString("#B1746F").CGColor
        self.navigationController.toolbar.layer.addSublayer(self.activeTabLayer)
    }
    override func shouldAutorotate() -> Bool {
        return appearanceController.isIPAD()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Tags"
    }
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int{
        return tagPhotos.count
    }
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!{
        var cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("TagCell", forIndexPath: indexPath) as UICollectionViewCell
        var tagImage:UIImageView = UIImageView()
        tagImage.contentMode = UIViewContentMode.ScaleAspectFill
        tagImage.image = UIImage(named: tagPhotos[indexPath.row])
        tagImage.frame = CGRectMake(tagImage.frame.origin.x, tagImage.frame.origin.y+10, appearanceController.width/2, appearanceController.height/4)
        cell.backgroundView = tagImage
        return cell
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int{
        return 1
    }
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!){
        let tagevents:TagEventsController = self.storyboard.instantiateViewControllerWithIdentifier("tagevents") as TagEventsController
        var filter:String = ""
        switch indexPath.row{
            case 0:
                let allEvents:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events") as EventsController
                allEvents.user = user!
                allEvents.school = school
                self.navigationController.pushViewController(allEvents, animated: false)
            case 1:
                filter = "Food & Dining"
            case 2:
                filter = "Music & Fine Arts"
            case 3:
                filter = "Nightlife"
            case 4:
                filter = "Off-Campus"
            case 5:
                filter = "Sports"
            default:
                filter = "All"
        }
        filter = filter.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        filter = filter.stringByReplacingOccurrencesOfString("&", withString: "%26", options: NSStringCompareOptions.LiteralSearch, range: nil)
        tagevents.filter = filter
        tagevents.user = user!
        tagevents.school = school
        self.activeTabLayer.removeFromSuperlayer()
        self.navigationController.pushViewController(tagevents, animated: false)
    }
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize{
        let image = UIImage(named: tagPhotos[indexPath.row])
        return CGSizeMake(appearanceController.width/2, appearanceController.height/3.5)
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
    @IBAction func allEvents(sender: AnyObject) {
        self.activeTabLayer.removeFromSuperlayer()
        var allEvents:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events")
            as EventsController
        allEvents.user = user!
        self.navigationController.pushViewController(allEvents, animated: false)
    }
}