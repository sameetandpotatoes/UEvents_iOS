//
//  EventDetailController.swift
//  UEvents
//
//  Created by Sameet Sapra on 6/30/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import UIKit
import EventKit
import QuartzCore

class EventDetailController: GAITrackedViewController, UIScrollViewDelegate{
    @IBOutlet var coverImage : UIImageView?
    @IBOutlet var eventTitle : UILabel?
    @IBOutlet var eventWhen : UILabel?
    @IBOutlet var eventWhere : UILabel?
    @IBOutlet var eventAttending : UILabel?
    @IBOutlet weak var tagHolder: UIView!
    @IBOutlet weak var secondTagImage: UIImageView!
    @IBOutlet weak var secondTag: UILabel!
    @IBOutlet weak var firstTag: UILabel!
    @IBOutlet var eventDescription : UITextView?
    @IBOutlet var scrollView : UIScrollView?

    @IBOutlet var mainView : UIView?
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet var rsvpSegButtons : UISegmentedControl?
    
    var attendingLayer:CALayer = CALayer()
    var tagLayer:CALayer = CALayer()
    var eventStatus:String = "declining"
    var appearance:AppearanceController = AppearanceController()
    var c:Dictionary<String, Dictionary<String, String>>!
    var eventData:Event!
    var height:CGFloat = 0
    var user:User!
    var env:ENVRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        c = appearance.getColors()
        env = ENVRouter(curUser: self.user)
        addToolbar()
        getRSVPStatus()
        updateView()
        //Safeguard to prevent animations from breaking
        UIView.setAnimationsEnabled(true)
    }
    /**
    * Adds share and calendar to the UINavigation right bar button items
    */
    func addToolbar(){
        let shareImage = UIImage(named: "Share")
        var share:UIBarButtonItem = UIBarButtonItem(image: shareImage, style: UIBarButtonItemStyle.Plain, target: self, action: "sharing")
        let calImage = UIImage(named: "Calendar")
        var calendar:UIBarButtonItem = UIBarButtonItem(image: calImage, style: UIBarButtonItemStyle.Plain, target: self, action: "addToCal")
        self.navigationItem.rightBarButtonItems = [share, calendar]
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //For use in Google Analytics
        self.screenName = "Viewing Single Event \(eventTitle!.text)"
    }
    //Only rotate if iPad
    override func shouldAutorotate() -> Bool {
        return appearance.isIPAD()
    }
    override func viewDidLayoutSubviews() {
        //Handles scrolling of event details - almost perfect
        self.scrollView!.contentSize = CGSizeMake(0, (heightConstraint.constant * 1.1) + 300)
        
        //Customizing UISegmentedControl
        var constraint:NSLayoutConstraint = NSLayoutConstraint(item: self.rsvpSegButtons, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 44)
        self.rsvpSegButtons!.addConstraint(constraint)

        self.eventAttending!.frame = CGRectMake(self.rsvpSegButtons!.frame.origin.x,
            self.rsvpSegButtons!.frame.origin.y+self.rsvpSegButtons!.frame.height,
            self.rsvpSegButtons!.frame.width/3,
            self.rsvpSegButtons!.frame.height)
        self.tagHolder.frame = CGRectMake(self.eventAttending!.frame.origin.x+self.eventAttending!.frame.width, self.eventAttending!.frame.origin.y, self.eventAttending!.frame.width * 2, self.eventAttending!.frame.height)
        
        /*
            Event Attending and Tag Holder frames are changing, so we need to
            update the the CALayers (gray borders) that correspond to these 
            UILabels or UIViews.
        */
        attendingLayer = appearance.addBottomBorder(self.eventAttending!)
        tagLayer = appearance.addBottomBorder(self.tagHolder)
    }
    func fixSelectedSegment(){
        var numSegments:Int = self.rsvpSegButtons!.subviews.count
        for var i = 0; i < numSegments; i++ {
            (self.rsvpSegButtons!.subviews[i] as UIView).tintColor = nil
            (self.rsvpSegButtons!.subviews[i] as UIView).tintColor = self.appearance.hexToUI(self.c["Solid"]!["Gray"]!)
        }
//        var sortedViews = self.rsvpSegButtons!.subviews
//        sortedViews = sortedViews.sorted {
//            var v1:CGFloat = ($0 as UIView).frame.origin.x
//            var v2:CGFloat = ($1 as UIView).frame.origin.x
//            if v1 < v2{
//                return NSComparisonResult.OrderedDescending
//            } else if v1 > v2{
//                return NSComparisonResult.OrderedAscending
//            } else{
//                return NSComparisonResult.OrderedSame
//            }
//        }
//        (sortedViews[self.rsvpSegButtons!.selectedSegmentIndex] as UIView).tintColor = self.appearance.hexToUI(self.c["Normal"]!["P"]!)
//        for view in self.rsvpSegButtons!.subviews{
//            view.removeFromSuperview()
//        }
//        for view in sortedViews{
//            self.rsvpSegButtons!.addSubview(view as UIView)
//        }
    }
    func compareViewsByOrigin(sp1: AnyObject!, sp2: AnyObject!, context: Void) -> NSComparisonResult{
        // UISegmentedControl segments use UISegment objects (private API). Then we can safely
        //   cast them to UIView objects.
        var v1:CGFloat = (sp1 as UIView).frame.origin.x
        var v2:CGFloat = (sp2 as UIView).frame.origin.x
        if v1 < v2{
            return NSComparisonResult.OrderedDescending
        } else if v1 > v2{
            return NSComparisonResult.OrderedAscending
        } else{
            return NSComparisonResult.OrderedSame
        }
    }
    func updateView(){
        dispatch_async(dispatch_get_main_queue()) {
            //UISegmentedControl UI Changes
            self.rsvpSegButtons!.tintColor = self.appearance.hexToUI(self.c["Solid"]!["Gray"]!)
            self.rsvpSegButtons!.frame = CGRectMake(self.rsvpSegButtons!.frame.origin.x,
                self.rsvpSegButtons!.frame.origin.y,
                self.rsvpSegButtons!.frame.width,
                44)
            var customFont:UIFont = UIFont(name: "HelveticaNeue", size: 16.0)
            //Change font and non-selected segment text color
            self.rsvpSegButtons!.setTitleTextAttributes([NSForegroundColorAttributeName : self.appearance.hexToUI(self.c["Normal"]!["P"]!), NSFontAttributeName : customFont], forState: UIControlState.Normal)
            
            //fix selected segment color in UISegmentedControl
            self.fixSelectedSegment()
            self.navigationController.toolbarHidden = true
            self.scrollView!.scrollEnabled = true
            
            //Cover Image
            var urlString: NSString = self.eventData.coverURL as NSString
            let image = UIImage(named: "DefaultCoverImage")
            var darkenedImage:UIImage = self.appearance.darkenImage(image: image, level: 0.5)
            self.coverImage!.image = darkenedImage
            if !urlString.isEqualToString(""){
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    //If the image doesn't exist, we must download
                    dispatch_async(dispatch_get_main_queue()) {
                        var imgURL: NSURL = NSURL(string: urlString)
                        var request: NSURLRequest = NSURLRequest(URL: imgURL)
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                            if error == nil {
                                var imgData: NSData = NSData(contentsOfURL: imgURL)
                                dispatch_async(dispatch_get_main_queue(), {
                                    var image = UIImage(data: data)
                                    var darkenedImage:UIImage = self.appearance.darkenImage(image: image, level: 0.6)
                                    self.coverImage!.image = darkenedImage
                                })
                            }
                            else {
                                println("Error: \(error.localizedDescription)")
                            }
                        })
                    }
                })
            }
            var name:NSString = self.eventData.name as NSString
            var start_date:NSString = self.eventData.shortStartDate as NSString
            var start_time:NSString = self.eventData.startTime as NSString
            var location:NSString = self.eventData.location as NSString
            var owner:NSString = self.eventData.owner as NSString
            var attending:NSString = self.eventData.attending as NSString
            //Event Title
            self.eventTitle!.text = name
            self.eventTitle!.lineBreakMode = NSLineBreakMode.ByWordWrapping
            self.eventTitle!.numberOfLines = 0
            
            //When
            self.eventWhen!.text = start_date + " " + start_time
            self.eventWhen!.font = UIFont(name: "HelveticaNeue", size: 16.0)
            self.eventWhen!.lineBreakMode = NSLineBreakMode.ByWordWrapping
            self.eventWhen!.numberOfLines = 0
            
            //Where
            self.eventWhere!.text = location
            self.eventWhere!.font = UIFont(name: "HelveticaNeue", size: 16.0)
            self.eventWhere!.adjustsFontSizeToFitWidth = false
            self.eventWhere!.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            self.eventWhere!.numberOfLines = 0
            
            
            //Attending
            self.eventAttending!.attributedText = self.appearance.boldTextWithColor(textToBold: attending, fullText: "\nattending", size: 22.0, color: self.appearance.hexToUI(self.c["Normal"]!["P"]!))
            self.eventAttending!.textAlignment = NSTextAlignment.Center
            self.eventAttending!.numberOfLines = 0
            
            //Tags
            var tagArray:Array = self.eventData.tags as Array
            if tagArray.count == 1{
                var dictOne:NSDictionary = tagArray[0] as NSDictionary
                if !dictOne.isEqual(nil) && dictOne["name"] != nil{
                    self.firstTag.text = dictOne["name"] as String
                }
            } else{
                //Add default tag so that it shows something if there are no tags for an event
                self.firstTag.text = "All Events"
            }
            if tagArray.count == 2{
                var dictTwo:NSDictionary = tagArray[1] as NSDictionary
                if !dictTwo.isEqual(nil) && dictTwo["name"] != nil{
                    self.secondTag.text = dictTwo["name"] as String
                }
            }else{
                self.secondTag.text = ""
                self.secondTagImage.hidden = true
            }
            
            //Event Details
            //Because of AutoLayout, we must size description text automatically
            var description:NSString = self.eventData.eventDescription as NSString
            self.eventDescription!.text = description
            self.eventDescription!.sizeToFit()
            var height:CGFloat = 25
            var size = CGSizeMake(self.appearance.width - 20, 10000)
            height += description.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: nil, context: nil).size.height
            //Update height constraint on UITextView so it can scroll
            self.heightConstraint.constant = height
            
            //Add the gray borders to tag view and event attending
            self.addBorders()
        }
    }
    /**
    * Handler for when UISegmentedControl is clicked. Updates
    * event status and posts to api
    */
    @IBAction func rsvpStatusChanged(sender : UISegmentedControl) {
        var newEventStatus:String
        switch(sender.selectedSegmentIndex){
            case 0:
                newEventStatus = "attending"
            case 1:
                //Interested really is maybe for FB
                newEventStatus = "maybe"
            case 2:
                newEventStatus = "declined"
            default:
                newEventStatus = eventStatus;
        }
        //Make sure we selected new event
        if (newEventStatus != eventStatus){
            eventStatus = newEventStatus;
            //Post to API
            var headers:NSMutableDictionary = NSMutableDictionary()
            headers.setValue("application/json", forKey: "Accept")
            headers.setValue("application/json", forKey: "Content-type")
            var userParam = ["" : ""]
            var response:UNIHTTPJsonResponse = (UNIRest.postEntity({ (request: UNIBodyRequest!) -> Void in
                request.url = self.env.getSingleEventURL(self.eventData.id, eventStatus: self.eventStatus)
                request.headers = headers
                request.body = NSJSONSerialization.dataWithJSONObject(userParam, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
            })).asJson()
            //Update eventStatus in our event
            self.eventData.eventStatus = self.eventStatus
        }
    }
    /**
    * Gets the current FB status of this event and
    * updates UISegmentedControl
    */
    func getRSVPStatus(){
        FBRequestConnection.startWithGraphPath("/\(eventData.id)/\(eventStatus)/\(user.userId)?access_token=\(user.accessToken)", completionHandler: {(connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                if error == nil {
                    var jsonFeeds = result as FBGraphObject
                    var feeds = jsonFeeds["data"] as NSMutableArray
                    var resultsHash = feeds[0] as NSMutableDictionary
                    var thisEventStatus = resultsHash["rsvp_status"] as NSString
                    if (thisEventStatus == "attending"){
                        self.eventStatus = "attending"
                        self.rsvpSegButtons!.selectedSegmentIndex = 0
                    } else if (thisEventStatus == "unsure"){
                        self.eventStatus = "interested"
                        self.rsvpSegButtons!.selectedSegmentIndex = 1
                    }
                }
            } as FBRequestHandler)
        eventData.eventStatus = eventStatus
    }
    /**
    * Adds borders to the Tag View and Event Attending View
    * @return url depending on user environment
    */
    func addBorders(){
        self.tagHolder.layer.addSublayer(self.tagLayer)
        self.eventAttending!.layer.addSublayer(self.attendingLayer)
    }
    /**
    * Handles sharing text and opens UIActivityViewController
    */
    func sharing(){
        var text = ""
        if eventWhere!.text == "No Location"{
            text = "Hey, I'm interested in \(eventTitle!.text) at \(eventWhen!.text). Want to join me? \n\nFind more events with UEvents, available on the App Store or the Play Store.\n\n\n\n\nhttp://www.uevents.io"
        } else{
            text = "Hey, I'm interested in \(eventTitle!.text) at \(eventWhere!.text). Want to join me? \n\nFind more events with UEvents, available on the App Store or the Play Store.\n\n\n\n\nhttp://www.uevents.io"
        }
        var controller:UIActivityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    /**
    * Formats event data to be put in user's default Calendar application
    */
    func addToCal(){
        let eventStore = EKEventStore()
        var eventSaved:Bool = false
        eventStore.requestAccessToEntityType(EKEntityTypeEvent) {
            (granted: Bool, err: NSError!) in
            if granted {
                var event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.eventTitle!.text
                event.startDate = self.eventData.startDateObj
                event.endDate = self.eventData.endDateObj
                event.calendar = eventStore.defaultCalendarForNewEvents
                eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
                eventSaved = true
            } else{
                eventSaved = false
            }
            dispatch_async(dispatch_get_main_queue()) {
                if (eventSaved){
                    SVProgressHUD.showSuccessWithStatus("Event saved successfully!")
                } else{
                    SVProgressHUD.showErrorWithStatus("Failed to save event")
                }
                //1 second delay to dismiss SVProgressHUD
                let delay = 1 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    SVProgressHUD.dismiss()
                })
            }
        }
    }
}