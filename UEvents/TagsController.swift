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
    @IBOutlet var collectionView : UICollectionView?
    var firstTime:Bool = true
    var appearanceController: AppearanceController = AppearanceController()
    var school:String = ""
    var colors:Dictionary<String, Dictionary<String, String>> = AppearanceController().getColors()
    var width = UIScreen.mainScreen().bounds.size.width
    var height = UIScreen.mainScreen().bounds.size.height
    var tagPhotos:[String] = ["Tag-All", "Tag-Food", "Tag-Music", "Tag-Nightlife", "Tag-Off-Campus","Tag-Sports"]
    var dividingFactor:CGFloat = 2
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
        if appearanceController.isIPAD(){
            dividingFactor = 2.75
        }
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
        settings.tintColor = UIColor.lightGrayColor()
        myEvents.width = appearanceController.width/4 - myEvents.image.size.width/2
        myEvents.tintColor = UIColor.lightGrayColor()
        tags.width = appearanceController.width/4 - tags.image.size.width/2
        tags.tintColor = appearanceController.colorWithHexString("#FFFFFF")
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
        tagImage.contentMode = UIViewContentMode.ScaleAspectFit
//        tagImage.contentMode = UIViewContentMode.ScaleAspectFill
        tagImage.image = UIImage(named: tagPhotos[indexPath.row])
        tagImage.frame = CGRectMake(tagImage.frame.origin.x, tagImage.frame.origin.y+10, appearanceController.width/dividingFactor, appearanceController.height/4)
//        tagImage.frame = CGRectMake(tagImage.frame.origin.x, tagImage.frame.origin.y + 10, 500, 500)
        cell.backgroundView = tagImage
        return cell
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int{
        return 1
    }
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!){
        var filter:String = ""
        switch indexPath.row{
            case 0:
                filter = "All"
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
        let events:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events") as EventsController
        events.tag = filter
        events.user = user!
        self.navigationController.pushViewController(events, animated: true)
    }
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize{
//        let image = UIImage(named: tagPhotos[indexPath.row])
        return CGSizeMake(300, 300)
//        return CGSizeMake(appearanceController.width/dividingFactor, appearanceController.height/3.5)
    }
    @IBAction func settings(sender : AnyObject) {
        var settings:SettingsController = self.storyboard.instantiateViewControllerWithIdentifier("settings") as SettingsController
        settings.user = user!
        self.navigationController.pushViewController(settings, animated: false)
    }
    @IBAction func tags(sender: AnyObject){
        var tagsController:TagsController = self.storyboard.instantiateViewControllerWithIdentifier("tags") as TagsController
        tagsController.user = user!
        self.navigationController.pushViewController(tagsController, animated: false)
    }
    @IBAction func myEvents(sender: AnyObject){
        var myEvents:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events") as EventsController
        myEvents.user = user!
        myEvents.tag = "User"
        self.navigationController.pushViewController(myEvents, animated: false)
    }
    @IBAction func allEvents(sender: AnyObject) {
        var allEvents:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events")
            as EventsController
        allEvents.user = user!
        allEvents.tag = "All"
        self.navigationController.pushViewController(allEvents, animated: false)
    }
}