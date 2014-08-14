//
//  EventDetailController.swift
//  UEvents
//
//  Created by Sameet Sapra on 6/30/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import UIKit

class EventDetailController: GAITrackedViewController, UIScrollViewDelegate{
    @IBOutlet var coverImage : UIImageView?
    @IBOutlet var eventTitle : UILabel?
    @IBOutlet var eventWhen : UILabel?
    @IBOutlet var eventWhere : UILabel?
    @IBOutlet var eventAttending : UILabel?
    
    @IBOutlet weak var secondTag: UILabel!
    @IBOutlet weak var firstTag: UILabel!
    @IBOutlet var eventDescription : UITextView?
    @IBOutlet var scrollView : UIScrollView?

    @IBOutlet var mainView : UIView?
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet var rsvpSegButtons : UISegmentedControl?
    var firstTime:Bool = true
    var fbGraphObject:FBGraphObject = FBGraphObject()
    var eventStatus:String = "declining"
    var appearanceController: AppearanceController = AppearanceController()
    var colors:Dictionary<String, Dictionary<String, String>> = AppearanceController().getColors()
    var eventData: Event = Event()
    var userId:String = String()
    var height:CGFloat = 0
    var user:User?
    @IBAction func sharing(sender : UIBarButtonItem) {
        var text = "Hey there! I am going to '\(eventTitle!.text)' at '\(eventWhen!.text)'. If you want to check out more events, you should download UEvents on the App Store or the Play Store.\n\nHere is some more information about the Event:\n\n '\(eventWhere!.text)'\n'\(eventAttending!.text)' people attending! "
        var controller:UIActivityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
        heightConstraint!.constant = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rsvpSegButtons!.tintColor = appearanceController.colorWithHexString(colors["UChicago"]!["Primary"]!)
        self.navigationController.toolbarHidden = true
        self.scrollView!.scrollEnabled = true
        getRSVPStatus()
        updateView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Viewing Single Event \(eventTitle!.text)"
    }
    override func shouldAutorotate() -> Bool {
        return appearanceController.isIPAD()
    }
    override func viewDidLayoutSubviews() {
        self.scrollView!.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width,
            UIScreen.mainScreen().bounds.size.height/1.5 + height)
    }
    func updateView(){
        //Cover Image
        var urlString: NSString = eventData.coverURL as NSString
        if urlString.isEqualToString("null"){
            let image = UIImage(named: "DefaultCoverImage")
            var darkenedImage:UIImage = self.appearanceController.darkenImage(image: image, level: 0.5)
            coverImage!.image = darkenedImage
        }else{
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    //If the image doesn't exist, we must download
                    var imgURL: NSURL = NSURL(string: urlString)
                    var request: NSURLRequest = NSURLRequest(URL: imgURL)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                        if error == nil {
                            var imgData: NSData = NSData(contentsOfURL: imgURL)
                            var image = UIImage(data: data)
                            var darkenedImage:UIImage = self.appearanceController.darkenImage(image: image, level: 0.6)
                            self.coverImage!.image = darkenedImage
                            // Store the image in to our cache
                        }
                        else {
                            println("Error: \(error.localizedDescription)")
                        }
                    })
            })
        }
        var name:NSString = eventData.name as NSString
        var start_date:NSString = eventData.startDate as NSString
        var location:NSString = eventData.location as NSString
        var owner:NSString = eventData.owner as NSString
        var attending:NSString = eventData.attending as NSString
        //Title
        self.eventTitle!.text = name
        self.eventTitle!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.eventTitle!.numberOfLines = 0
        //When
        
        self.eventWhen!.text = start_date
        self.eventWhen!.font = UIFont(name: "HelveticaNeue", size: 16.0)
        self.eventWhen!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.eventWhen!.numberOfLines = 0
        
        self.eventWhere!.text = location
        self.eventWhere!.font = UIFont(name: "HelveticaNeue", size: 16.0)
        self.eventWhere!.adjustsFontSizeToFitWidth = false
        self.eventWhere!.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.eventWhere!.numberOfLines = 0
        
        self.eventAttending!.attributedText = appearanceController.boldTextWithColor(textToBold: attending, fullText: "\nattending", size: 16.0, color: appearanceController.colorWithHexString(colors["UChicago"]!["Primary"]!))
        self.eventAttending!.textAlignment = NSTextAlignment.Center
        self.eventAttending!.numberOfLines = 0
        self.eventAttending!.layer.borderColor = UIColor.grayColor().CGColor
        self.eventAttending!.layer.borderWidth = 2.0
        //Tags
        var tagArray:Array = eventData.tags as Array
        if tagArray.count == 1{
            var dictOne:NSDictionary = tagArray[0] as NSDictionary
            if dictOne != nil && dictOne["name"] != nil{
                self.firstTag.text = dictOne["name"] as String
            }
        } else{
            self.firstTag.text = "All Events"
        }
        if tagArray.count == 2{
            var dictTwo:NSDictionary = tagArray[1] as NSDictionary
            if dictTwo != nil && dictTwo["name"] != nil{
                self.secondTag.text = dictTwo["name"] as String
            }
        }else{
            self.secondTag.text = ""
        }
        var description:NSString = eventData.eventDescription as NSString
        self.eventDescription!.text = description
        self.eventDescription!.sizeToFit()
        self.eventDescription!.layoutIfNeeded()
        heightConstraint.constant = self.eventDescription!.sizeThatFits(CGSizeMake(self.eventDescription!.frame.size.width, CGFloat.max)).height
        println(heightConstraint.constant)
//        var frame:CGRect = self.eventDescription!.frame
//        var size:CGSize = self.eventDescription!.sizeThatFits(self.eventDescription!.frame.size)
//        heightConstraint.constant = size.height
    }
    @IBAction func rsvpStatusChanged(sender : UISegmentedControl) {
        var image:UIImage
        var toastText:String
        var newEventStatus:String
        switch(sender.selectedSegmentIndex){
            case 0:
                newEventStatus = "attending"
            case 1:
                newEventStatus = "maybe"
            case 2:
                newEventStatus = "declined"
            default:
                newEventStatus = eventStatus;
        }
        if (newEventStatus != eventStatus){
            eventStatus = newEventStatus;
            
            var headers:NSMutableDictionary = NSMutableDictionary()
            headers.setValue("application/json", forKey: "Accept")
            headers.setValue("application/json", forKey: "Content-type")
            var userParam = ["" : ""]
            var response:UNIHTTPJsonResponse = (UNIRest.postEntity({ (request: UNIBodyRequest!) -> Void in
                request.url = "http://localhost:3000/api/events/\(self.eventData.id)/\(self.eventStatus)?authentication_token=\(self.user!.authToken)"
                request.headers = headers
                request.body = NSJSONSerialization.dataWithJSONObject(userParam, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
            })).asJson()
            if (self.eventStatus == "declined"){
                toastText = "Not going to \(self.eventData.name)"
            } else if (self.eventStatus == "maybe"){
                toastText = "Interested in \(self.eventData.name)"
            } else{
                toastText = "Going to \(self.eventData.name)"
            }
            Toast.showToastInParentView(self.view, withText: toastText, withDuration: 1.5)
            self.eventData.eventStatus = self.eventStatus
//            FBRequestConnection.startForPostWithGraphPath("/\(eventData.id)/\(eventStatus)", graphObject: fbGraphObject, completionHandler: {(connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
//                    if error == nil {
//                        var jsonFeeds = result as FBGraphObject
//                        var toastText:String = ""
//                        if (self.eventStatus == "declined"){
//                            toastText = "Not going to \(self.eventData.name)"
//                        } else if (self.eventStatus == "maybe"){
//                            toastText = "Interested in \(self.eventData.name)"
//                        } else{
//                            toastText = "Going to \(self.eventData.name)"
//                        }
//                        Toast.showToastInParentView(self.view, withText: toastText, withDuration: 1.5)
//                        self.eventData.eventStatus = self.eventStatus
//                    } else{
//                        println("RSVP ERROR \(error)")
//                        var alert:UIAlertView = UIAlertView(title: "Error RSVP'ing", message: "Please check your internet connection and try again.", delegate: self, cancelButtonTitle: "Ok")
//                        alert.show()
//                    }
//                } as FBRequestHandler)
        }
    }
    func getRSVPStatus(){
        FBRequestConnection.startWithGraphPath("/\(eventData.id)/\(eventStatus)/\(userId)", completionHandler: {(connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
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
                println("RSVP ERROR \(error)")
            } as FBRequestHandler)
        eventData.eventStatus = eventStatus
    }
}