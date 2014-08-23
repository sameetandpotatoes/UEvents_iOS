//
//  PageContentViewController.swift
//  UEvents
//
//  Created by Sameet Sapra on 8/13/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation
import QuartzCore

class PageContentViewController:GAITrackedViewController{
    @IBOutlet var backgroundImageView:UIImageView!
    @IBOutlet var pageControl:UIPageControl!
    @IBOutlet var buttonLoginLogout:UIButton!
    @IBOutlet var swipeText:UILabel!
    @IBOutlet var introDescription:UITextView!
    var pageIndex:Int = 0
    var titleText:String = ""
    var imageFile:String = ""
    var env:ENVRouter!
    var model:User!
    var responseData:NSMutableData!
    var appearance:AppearanceController = AppearanceController()
//    override init(){
//        
//    }
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func viewDidLoad(){
        super.viewDidLoad()
        if titleText == "1"{
            self.introDescription.hidden = true
            self.swipeText.hidden = false
            self.pageControl.currentPage = 0
        } else{
            self.swipeText.hidden = true
            self.introDescription.hidden = false
            if self.appearance.isIPAD(){
                self.introDescription.font = UIFont(name: "HelveticaNeue-Light", size: 25.0)
            }
            self.pageControl.currentPage = 1
        }
        
        self.backgroundImageView!.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.backgroundImageView!.image = UIImage(named: self.imageFile)
        self.backgroundImageView!.backgroundColor = UIColor.whiteColor()
        //Scaling image
        let size=CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height+40);//set the width and height
        UIGraphicsBeginImageContext(size);
        self.backgroundImageView!.image.drawInRect(CGRectMake(0,0,size.width,size.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        self.backgroundImageView!.image = newImage
        //here is the scaled image which has been changed to the size specified
        UIGraphicsEndImageContext();
        
        //This is just copied from buttonClicked - I'm sure you can just call this yourself to be DRY
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if (appDelegate.session != nil && appDelegate.session!.isOpen){
            println("Closed session")
            appDelegate.session!.closeAndClearTokenInformation()
        } else{
            if appDelegate.session == nil || appDelegate.session!.state != FBSessionState.Created{
                println("New session")
                appDelegate.session = FBSession()
            }
            appDelegate.session!.openWithCompletionHandler({ (session: FBSession!, status: FBSessionState, error: NSError!) in
                //Logged in, so let's go
                println("Logged in")
                self.updateView()
            })
        }
//        self.buttonClicked(nil)
    }
    func updateView(){
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        var session = (UIApplication.sharedApplication().delegate as AppDelegate).session as FBSession!
        if appDelegate.session != nil && appDelegate.session!.isOpen{
            SVProgressHUD.showWithMaskType(UInt(SVProgressHUDMaskTypeGradient))
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                var apiRequest:String = "https://graph.facebook.com/me?access_token=\(appDelegate.session!.accessTokenData.accessToken)"
                var headers:NSDictionary = ["Accept" : "application/json", "Content-type": "application/json"]
                var json = NSMutableDictionary()
                var asyncConnection:UNIUrlConnection = UNIRest.get({ (request: UNISimpleRequest!) -> Void in
                    request.url = apiRequest
                }).asJsonAsync({ (response: UNIHTTPJsonResponse!, error: NSError!) -> Void in
                    var result = NSJSONSerialization.JSONObjectWithData(response.rawBody, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
                    self.model = User(user: result)
                    println("Got the user's info!")
                    self.model.accessToken = appDelegate.session!.accessTokenData.accessToken
                    if self.createUser(){
                        println("Going to all events")
                        let allEvents = self.storyboard.instantiateViewControllerWithIdentifier("events") as EventsController
                        allEvents.user = self.model
                        allEvents.tag = "All"
                        self.navigationController.pushViewController(allEvents, animated: true)
                    } else{
                        println("Going to schools")
                        let school = self.storyboard.instantiateViewControllerWithIdentifier("school") as SchoolSelector
                        school.user = self.model
                        self.navigationController.pushViewController(school, animated: true)
                    }
                })
            })
        } else{
            println("Nothing")
        }
    }
    @IBAction func buttonClicked(sender: AnyObject){
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if (appDelegate.session != nil && appDelegate.session!.isOpen){
            println("Closed session")
            appDelegate.session!.closeAndClearTokenInformation()
        } else{
            if appDelegate.session == nil || appDelegate.session!.state != FBSessionState.Created{
                println("New session")
                appDelegate.session = FBSession()
            }
            appDelegate.session!.openWithCompletionHandler({ (session: FBSession!, status: FBSessionState, error: NSError!) in
                //Logged in, so let's go
                println("Logged in")
                self.updateView()
            })
        }
    }
    func createUser() -> Bool{
        self.env = ENVRouter(curUser: self.model)
        var headers:NSDictionary = ["Accept" : "application/json", "Content-type": "application/json"]
        var payload = NSMutableDictionary()
        payload.setObject(self.model.firstName, forKey: "first_name")
        payload.setObject(self.model.lastName, forKey: "last_name")
        payload.setObject(self.model.pictureURL, forKey: "picture_url")
        payload.setObject(self.model.userId, forKey: "id")
        payload.setObject(self.model.email, forKey: "email")
        payload.setObject(self.model.accessToken, forKey: "access_token")
        payload.setObject("", forKey: "school_id")
        payload.setObject("", forKey: "user")
        
        var response:UNIHTTPJsonResponse = UNIRest.postEntity { (request: UNIBodyRequest!) -> Void in
            request.url = self.env.getPostUserURL()
            request.headers = headers
            request.body = NSJSONSerialization.dataWithJSONObject(payload, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        }.asJson()
        let result = NSJSONSerialization.JSONObjectWithData(response.rawBody, options: NSJSONReadingOptions.MutableLeaves, error: nil) as? NSDictionary
        if result != NSNull(){
            var innerData:NSDictionary = result!.valueForKey("user") as NSDictionary
            self.model.authToken = innerData.valueForKey("authentication_token") as String
            var school = innerData.valueForKey("school")
            if let notnullSchool = school as? NSDictionary{
                self.model.schoolName = notnullSchool.valueForKey("name") as String
//                self.model.schoolId = notnullSchool.valueForKey("id") as String
                return true
            } else{
                return false
            }
        } else{
            return false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Home Screen"
    }
}