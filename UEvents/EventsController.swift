//
//  Events.swift
//  UEvents
//
//  Created by Sameet Sapra on 6/29/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore
import CoreImage

class EventsController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol{
    
    @IBOutlet weak var staticDateText: UILabel!
    @IBOutlet weak var staticDate: UIView!
    var activeTabLayer:CALayer = CALayer()
    var api:APIController? = nil
    var date:Date = Date()
    var appearanceController: AppearanceController = AppearanceController()
    var colors:Dictionary<String, Dictionary<String, String>> = AppearanceController().getColors()
    var data = NSMutableData()
    var tableData: Array<NSObject> = Array<NSObject>()
    var imageCache = NSMutableDictionary()
    var refreshControl:UIRefreshControl!
    var user:User?
    var school:String = ""
    var width = UIScreen.mainScreen().bounds.size.width
    var height = UIScreen.mainScreen().bounds.size.height
    var allNewDates:NSMutableArray = []
    var allNewDateIndexes:NSMutableArray = []
    var lastDateIndex = 0
    @IBOutlet var appsTableView : UITableView?
    @IBOutlet weak var allEvents: UIBarButtonItem!
    @IBOutlet weak var tags: UIBarButtonItem!
    @IBOutlet weak var settings: UIBarButtonItem!
    @IBOutlet weak var myEvents: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Events")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        appsTableView!.addSubview(refreshControl)
        self.view.userInteractionEnabled = true
        if (self.respondsToSelector("setEdgesForExtendedLayout:")) { // if iOS 7
            self.edgesForExtendedLayout = UIRectEdge.None //layout adjustements
        }
        api = APIController()
        self.api!.user = user
        self.api?.allEventsP = self
        self.refreshControl.beginRefreshing()
        self.api!.getEvents()
        self.staticDateText.textColor = appearanceController.colorWithHexString(colors["UChicago"]!["Primary"]!)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController.toolbarHidden = false
        self.screenName = "All Events"
    }
    func setUpUI(){
        self.navigationController.navigationBarHidden = false
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
        let xPos = (1 * (appearanceController.width/4)) - 44 - 16
        self.activeTabLayer.opacity = 0.5
        self.activeTabLayer.frame = CGRectMake(xPos, 0, 44+15, 44)
        self.activeTabLayer.backgroundColor = appearanceController.colorWithHexString("#B1746F").CGColor
        self.navigationController.toolbar.layer.addSublayer(self.activeTabLayer)
    }
    func didReceiveAPIResults(results: Array<NSObject>) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = results
            self.refreshControl.endRefreshing()
            self.appsTableView!.reloadData()
        })
    }
    override func shouldAutorotate() -> Bool {
        return appearanceController.isIPAD()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        var listItem:NSObject = self.tableData[indexPath.row]
        var cell:UITableViewCell?
        var index = indexPath.row
        if (listItem is NSString){
            cell = DateCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "EventCell")
            (cell as DateCell).date.text = listItem as NSString
        }
        if (listItem is Event){
            cell = EventCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "EventCell")
            var rowData:Event = self.tableData[index] as Event
            
            (cell as EventCell).eventTitle.text = rowData.name as String
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                var urlString: NSString = rowData.coverURL as NSString
                if (urlString != ""){
                    //Check image cache to see if we already downloaded the image
                    var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
                    if (image == nil){
                        //If the image doesn't exist, we must download
                        var imgURL: NSURL = NSURL(string: urlString)
                        var request: NSURLRequest = NSURLRequest(URL: imgURL)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                            if error == nil {
                                var imgData: NSData = NSData(contentsOfURL: imgURL)
                                image = UIImage(data: data)
                                var darkenedImage:UIImage = self.appearanceController.darkenImage(image: image!, level: 0.6)
                                (cell as EventCell).imageView.image = darkenedImage
                                // Store the image in to our cache
                                self.imageCache.setValue(darkenedImage, forKey: urlString)
                            }
                            else {
                                println("Error: \(error.localizedDescription)")
                            }
                            })
                    } else{
                        //Found in the cache, so let's retrieve it
                        (cell as EventCell).imageView.image = image!
                    }
                } else{
                    (cell as EventCell).imageView.image = UIImage(named: "DefaultCoverImage")
                    var darkenedImage:UIImage = self.appearanceController.darkenImage(image: (cell as EventCell).imageView.image, level: 0.5)
                    (cell as EventCell).imageView.image = darkenedImage
                }
            })
            (cell as EventCell).eventWhere.text = rowData.location
            (cell as EventCell).eventWhen.text = rowData.startTime
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        return cell
    }
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        checkStaticDate()
    }
    func checkStaticDate(){
        let array:NSArray = self.appsTableView!.visibleCells()
        for (index, item) in enumerate(array){
            if index == 0 && item is DateCell{
                self.staticDateText.text = (item as DateCell).date.text
            }
        }
    }
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        var selectedItem:NSObject = self.tableData[indexPath.row]
        if (selectedItem is Event){
            var rowData: Event = self.tableData[indexPath.row] as Event
            let singleEvent = self.storyboard.instantiateViewControllerWithIdentifier("details") as EventDetailController
            singleEvent.eventStatus = rowData.eventStatus
            singleEvent.userId = user!.id
            singleEvent.user = user
            singleEvent.eventData = rowData
            self.navigationController.pushViewController(singleEvent, animated: true)
        }
    }
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat{
        var listItem:NSObject = self.tableData[indexPath.row]
        if (listItem is Event){
            return 150
        } else{
            return 30
        }
    }
    func refresh(sender:AnyObject)
    {
        (api as APIController!).getEvents();
        self.refreshControl.endRefreshing()
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
        var allEvents:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events")
            as EventsController
        allEvents.user = user!
        self.navigationController.pushViewController(allEvents, animated: false)
    }
}