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

class EventsController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate, AllEventsProtocol, FilteredProtocol, MyEventsProtocol, UITabBarDelegate{
    
    @IBOutlet weak var mainTabBar: UITabBar!
    @IBOutlet weak var staticDateText: UILabel!
    @IBOutlet weak var staticDate: UIView!
    var api:APIController!
    var appearance: AppearanceController = AppearanceController()
    var c:Dictionary<String, Dictionary<String, String>>!
    var data = NSMutableData()
    var tableData: Array<NSObject> = Array<NSObject>()
    var imageCache = NSMutableDictionary()
    var refreshControl:UIRefreshControl!
    var user:User!
    var env:ENVRouter!
    var tag:String = ""
    
    @IBOutlet var appsTableView : UITableView?
    @IBOutlet weak var allEvents: UIBarButtonItem!
    @IBOutlet weak var tags: UIBarButtonItem!
    @IBOutlet weak var settings: UIBarButtonItem!
    @IBOutlet weak var myEvents: UIBarButtonItem!
    var tagsController:TagsController!
    var eventsController:EventsController!
    var settingsController:SettingsController!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.mainTabBar.delegate = self
        SVProgressHUD.dismiss()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dispatch_async(dispatch_get_main_queue()) {
            self.screenName = "Events | \(self.tag)"
        }
    }
    override func viewDidAppear(animated: Bool) {
        //Ensures that any UI changes are processed by UIKit correctly without disable animations
        dispatch_async(dispatch_get_main_queue()) {
            self.api = APIController(curUser: self.user)
            self.refreshControl.beginRefreshing()
            self.staticDateText.textColor = self.appearance.hexToUI(self.c["Normal"]!["P"]!)
            if self.tag == "All" {
                self.navigationItem.setHidesBackButton(true, animated: true)
                self.navigationController.navigationBar.topItem.title = ""
                self.navigationItem.title = "All Events"
                self.mainTabBar.selectedItem = self.mainTabBar.items[0] as UITabBarItem
                self.api.allEventsP = self
                self.api.getEvents()
            } else if self.tag == "User" {
                self.navigationItem.setHidesBackButton(true, animated: true)
                self.navigationController.navigationBar.topItem.title = ""
                self.navigationItem.title = "\(self.user!.firstName)'s Events"
                self.api.userEventsP = self
                self.mainTabBar.selectedItem = self.mainTabBar.items[2] as UITabBarItem
                self.api.getUserEvents()
            } else{
                var titleFilter:String = self.tag.stringByReplacingOccurrencesOfString("%20", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
                titleFilter = titleFilter.stringByReplacingOccurrencesOfString("%26", withString: "&", options: NSStringCompareOptions.LiteralSearch, range: nil)
                self.navigationItem.title = titleFilter.capitalizedString
                self.mainTabBar.selectedItem = self.mainTabBar.items[1] as UITabBarItem
                self.api.filterP = self
                self.api.getEvents(self.tag)
            }
            UIView.setAnimationsEnabled(true)
        }
    }
    override func viewDidLayoutSubviews() {
        dispatch_async(dispatch_get_main_queue(), {

        })
    }
    func setUpUI(){
        dispatch_async(dispatch_get_main_queue(), {
            //Toolbar and Navigation Bar Setup and Colors
            self.c = self.appearance.getColors()
            self.navigationController.navigationBarHidden = false
            self.navigationController.interactivePopGestureRecognizer.enabled = false;
            self.navigationController.navigationBar.barTintColor = self.appearance.hexToUI(self.c["Normal"]!["P"]!)
            self.navigationController.navigationBar.tintColor = self.appearance.hexToUI(self.c["Solid"]!["White"]!)
            self.navigationController.toolbar.barTintColor = self.appearance.hexToUI(self.c["Normal"]!["P"]!)
            self.navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            self.navigationController.interactivePopGestureRecognizer.enabled = false;
            self.view.userInteractionEnabled = true
            self.navigationController.toolbarHidden = true
            
            self.mainTabBar.barTintColor = self.appearance.hexToUI(self.c["Normal"]!["P"]!)
            self.mainTabBar.selectedImageTintColor = UIColor.whiteColor()
            
            //Swipe Up to Refresh
            self.refreshControl = UIRefreshControl()
            self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Events")
            self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
            self.appsTableView!.addSubview(self.refreshControl)
            //when coming from tutorial pages, this messed up margin
//            self.view.frame = CGRectMake(0,0,self.appearance.width, self.appearance.height)
        })
    }
    func didReceiveAllEvents(results: Array<NSObject>) {
        handleEventsReceived(results)
    }
    func didReceiveFilteredEvents(results: Array<NSObject>) {
        handleEventsReceived(results)
    }
    func didReceiveUserEvents(results: Array<NSObject>) {
        handleEventsReceived(results)
    }
    func handleEventsReceived(results: Array<NSObject>){
        self.tableData = results
        self.refreshControl.endRefreshing()
        self.appsTableView!.reloadData()
    }
    override func shouldAutorotate() -> Bool {
        return appearance.isIPAD()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("EventCell") as UITableViewCell
        var listItem:NSObject = self.tableData[indexPath.row]
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //Must differentiate between what type of cell we are dealing with
        if (listItem is NSString){
            if cell.isEqual(nil) || !(cell is DateCell){
                cell = DateCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "EventCell")
            }
            //Update UI
            dispatch_async(dispatch_get_main_queue()) {
                (cell as DateCell).date.text = listItem as NSString
            }
        }
        if (listItem is Event){
            if cell.isEqual(nil) || !(cell is EventCell){
                cell = EventCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "EventCell")
            }
            var rowData:Event = self.tableData[indexPath.row] as Event
            dispatch_async(dispatch_get_main_queue()) {
                (cell as EventCell).eventWhere.text = rowData.location
                (cell as EventCell).eventWhen.text = rowData.startTime
                (cell as EventCell).eventTitle.text = rowData.name as String
                //Placeholder image
                (cell as EventCell).imageView.image = UIImage(named: "DefaultCoverImage")
                var darkenedImage:UIImage = self.appearance.darkenImage(image: (cell as EventCell).imageView.image, level: 0.5)
                (cell as EventCell).imageView.image = darkenedImage
                //Now lets download the real image
                if rowData.coverURL != ""{
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
                                        var darkenedImage:UIImage = self.appearance.darkenImage(image: image!, level: 0.6)
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
                        }
                    })
                }
            }
        }
        return cell
    }
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        checkStaticDate()
    }
    /**
    * Updates the static date at the top of the UITableView
    * if we reached a new date
    */
    func checkStaticDate(){
        dispatch_async(dispatch_get_main_queue()) {
            let array:NSArray = self.appsTableView!.visibleCells()
            for (index, item) in enumerate(array){
                if index == 0 && item is DateCell{
                    let text = (item as DateCell).date.text
                    self.staticDateText.text = (text != nil && text == "No events under this category") ? "" : text
                }
            }
        }
    }
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        var selectedItem:NSObject = self.tableData[indexPath.row]
        if (selectedItem is Event){
            var rowData: Event = self.tableData[indexPath.row] as Event
            let singleEvent = self.storyboard.instantiateViewControllerWithIdentifier("details") as EventDetailController
            //Pass along the data
            singleEvent.eventStatus = rowData.eventStatus
            singleEvent.user = user
            singleEvent.eventData = rowData
            self.navigationController.pushViewController(singleEvent, animated: true)
        }
    }
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat{
        var listItem:NSObject = self.tableData[indexPath.row]
        if (listItem is Event){
            if appearance.isIPAD(){
                return 300
            } else{
                return 150
            }
        } else{ //DateCell
            return 25
        }
    }
    func refresh(sender:AnyObject)
    {
        dispatch_async(dispatch_get_main_queue()) {
            self.refreshControl.beginRefreshing()
            let delay = 1 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                self.handleEventsReceived(self.tableData)
            })
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