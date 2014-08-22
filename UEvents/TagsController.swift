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

class TagsController:GAITrackedViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarDelegate{
    var user:User!
    @IBOutlet var collectionView : UICollectionView?
    @IBOutlet weak var mainTabBar: UITabBar!
    var firstTime:Bool = true
    var appearance: AppearanceController = AppearanceController()
    var school:String = ""
    var colors:Dictionary<String, Dictionary<String, String>> = AppearanceController().getColors()
    var width = UIScreen.mainScreen().bounds.size.width
    var height = UIScreen.mainScreen().bounds.size.height
    var tagPhotos:[String] = ["Tag-All", "Tag-Food", "Tag-Music", "Tag-Nightlife", "Tag-Off-Campus","Tag-Sports"]
    var dividingFactor:CGFloat = 2.75
    @IBOutlet var scrollView : UIScrollView?
    
    @IBOutlet weak var allEvents: UIBarButtonItem!
    @IBOutlet weak var settings: UIBarButtonItem!
    @IBOutlet weak var myEvents: UIBarButtonItem!
    @IBOutlet weak var tags: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.mainTabBar.delegate = self
        scrollView!.scrollEnabled = true
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "TagCell")
        self.collectionView!.reloadData()
        if appearance.isIPAD(){
            dividingFactor = 2.75
        }
    }
    func setUpUI(){
        dispatch_async(dispatch_get_main_queue()){
            self.navigationController.interactivePopGestureRecognizer.enabled = false;
            self.navigationController.navigationBar.barTintColor = self.appearance.hexToUI(self.colors["Normal"]!["P"]!)
            self.navigationController.navigationBar.tintColor = self.appearance.hexToUI(self.colors["Solid"]!["White"]!)
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.navigationController.toolbar.opaque = true
            self.navigationController.toolbar.barTintColor = self.appearance.hexToUI(self.colors["Normal"]!["P"]!)
            self.navigationController.toolbarHidden = false
            self.navigationController.interactivePopGestureRecognizer.enabled = false;
            self.view.userInteractionEnabled = true
            self.navigationController.toolbarHidden = true
            self.mainTabBar.barTintColor = self.appearance.hexToUI(self.colors["Normal"]!["P"]!)
            self.mainTabBar.selectedImageTintColor = UIColor.whiteColor()
            self.mainTabBar.selectedItem = self.mainTabBar.items[1] as UITabBarItem
        }
    }
    //Only rotate if iPad
    override func shouldAutorotate() -> Bool {
        return appearance.isIPAD()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //For use in Google Analytics
        self.screenName = "Tags"
    }
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int{
        return tagPhotos.count
    }
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!{
        var cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("TagCell", forIndexPath: indexPath) as UICollectionViewCell
        var tagImage:UIImageView = UIImageView()
        tagImage.contentMode = UIViewContentMode.ScaleAspectFit
        tagImage.image = UIImage(named: tagPhotos[indexPath.row])
        tagImage.frame = CGRectMake(tagImage.frame.origin.x, tagImage.frame.origin.y+10, appearance.width/dividingFactor, appearance.height/4)
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
        events.user = user
        self.navigationController.pushViewController(events, animated: true)
    }
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize{
        //Double the size on an iPad
        if appearance.isIPAD(){
            return CGSizeMake(300, 300)
        } else{
            return CGSizeMake(appearance.width/2, 150)
        }
    }
    func tabBar(tabBar: UITabBar!, didSelectItem item: UITabBarItem!){
        switch(tabBar.selectedItem.title){
        case "All Events":
            var allEvents:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events")
                as EventsController
            allEvents.user = user!
            allEvents.tag = "All"
            self.navigationController.pushViewController(allEvents, animated: false)
        case "Tags":
            var tagsController:TagsController = self.storyboard.instantiateViewControllerWithIdentifier("tags") as TagsController
            tagsController.user = user!
            self.navigationController.pushViewController(tagsController, animated: false)
        case "My Events":
            var myEvents:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events") as EventsController
            myEvents.user = user!
            myEvents.tag = "User"
            self.navigationController.pushViewController(myEvents, animated: false)
        case "Settings":
            var settings:SettingsController = self.storyboard.instantiateViewControllerWithIdentifier("settings") as SettingsController
            settings.user = user!
            self.navigationController.pushViewController(settings, animated: false)
        default:
            println("not possible")
        }
    }
}