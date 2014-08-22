////
////  PageContentViewController.swift
////  UEvents
////
////  Created by Sameet Sapra on 8/13/14.
////  Copyright (c) 2014 Sameet Sapra. All rights reserved.
////
//
//import Foundation
//import QuartzCore
//
//class PageContentViewController:GAITrackedViewController{
//    @IBOutlet var backgroundImageView:UIImageView!
//    @IBOutlet var pageControl:UIPageControl!
//    @IBOutlet var buttonLoginLogout:UIButton!
//    @IBOutlet var swipeText:UILabel!
//    @IBOutlet var introDescription:UITextView!
//    var pageIndex:Int = 0
//    var titleText:String = ""
//    var imageFile:String = ""
//    var env:ENVRouter!
//    var model:User!
//    var responseData:NSMutableData!
//    var appearance:AppearanceController = AppearanceController()
//    override init(){
//        
//    }
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    override func viewDidLoad(){
//        super.viewDidLoad()
//        if titleText == "1"{
//            self.introDescription.hidden = true
//            self.swipeText.hidden = false
//            self.pageControl.currentPage = 0
//        } else{
//            self.swipeText.hidden = true
//            self.introDescription.hidden = false
//            if self.appearance.isIPAD(){
//                self.introDescription.font = UIFont(name: "HelveticaNeue-Light", size: 25.0)
//            }
//            self.pageControl.currentPage = 1
//        }
//        
//        self.backgroundImageView!.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
//        self.backgroundImageView!.image = UIImage(named: self.imageFile)
//        self.backgroundImageView!.backgroundColor = UIColor.whiteColor()
//        //Scaling image
//        let size=CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height+40);//set the width and height
//        UIGraphicsBeginImageContext(size);
//        self.backgroundImageView!.image.drawInRect(CGRectMake(0,-40,size.width,size.height));
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        self.backgroundImageView!.image = newImage
//        //here is the scaled image which has been changed to the size specified
//        UIGraphicsEndImageContext();
//        
//        self.updateView()
//        
//        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        if (!appDelegate.session!.isOpen){
//            appDelegate.session = FBSession()
//            if appDelegate.session!.state == FBSessionState.CreatedTokenLoaded{
//                appDelegate.session?.openWithCompletionHandler({ (session: FBSession!, status: FBSessionState, error: NSError!) in
//                    //Logged in, so let's go
//                    self.updateView()
//                })
//            }
//        }
//    }
//    func updateView(){
//        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        if appDelegate.session!.isOpen{
//            SVProgressHUD.showWithMaskType(UInt(SVProgressHUDMaskTypeGradient))
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//                var apiRequest:String = "https://graph.facebook.com/me?access_token=\(appDelegate.session!.accessTokenData.accessToken)"
//                var headers:NSDictionary = ["Accept" : "application/json", "Content-type": "application/json"]
//                var json = NSMutableDictionary()
//                var asyncConnection:UNIUrlConnection = UNIRest.get({ (request: UNISimpleRequest!) -> Void in
////                    request.setUrl(apiRequest)
//                }).asJsonAsync({ (response: UNIHTTPJsonResponse!, error: NSError!) -> Void in
//                    var result = NSJSONSerialization.JSONObjectWithData(response.rawBody, options: NSJSONReadingOptions.MutableLeaves, error: nil) as NSDictionary
//                    self.model = User(user: result)
//                    self.model.accessToken = appDelegate.session!.accessTokenData.accessToken
//                    if self.createUser(){
//                        let allEvents = self.storyboard.instantiateViewControllerWithIdentifier("events") as EventsController
//                        allEvents.user = self.model
//                        allEvents.tag = "All"
//                        self.navigationController.pushViewController(allEvents, animated: true)
//                    } else{
//                        let school = self.storyboard.instantiateViewControllerWithIdentifier("school") as SchoolSelector
//                        school.user = self.model
//                        self.navigationController.pushViewController(school, animated: true)
//                    }
//                })
//            })
//        }
//    }
//    @IBAction func buttonClicked(sender: AnyObject){
//        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        if appDelegate.session!.isOpen{
//            appDelegate.session!.closeAndClearTokenInformation()
//        } else{
//            if appDelegate.session!.state != FBSessionState.Created{
//                appDelegate.session = FBSession()
//                appDelegate.session!.openWithCompletionHandler({ (session: FBSession!, status: FBSessionState, error: NSError!) in
//                    //Logged in, so let's go
//                    self.updateView()
//                })
//            }
//        }
//    }
//    func createUser() -> Bool{
//        self.env = ENVRouter(curUser: self.model)
//        var headers:NSDictionary = ["Accept" : "application/json", "Content-type": "application/json"]
//        var payload = NSMutableDictionary()
//        payload.setObject(self.model.firstName, forKey: "first_name")
//        payload.setObject(self.model.lastName, forKey: "last_name")
//        payload.setObject(self.model.pictureURL, forKey: "picture_url")
//        payload.setObject(self.model.userId, forKey: "id")
//        payload.setObject(self.model.email, forKey: "email")
//        payload.setObject(self.model.accessToken, forKey: "access_token")
//        payload.setObject("", forKey: "school_id")
//        payload.setObject("", forKey: "user")
//        
//        var response:UNIHTTPJsonResponse = UNIRest.postEntity { (request: UNIBodyRequest!) -> Void in
//            
//        }.asJson()
//        var result:NSDictionary = NSJSONSerialization.JSONObjectWithData(response.rawBody, options: 0, error: nil)
//        if result != NSNull(){
//            var innerData:NSDictionary = result.valueForKey("user") as NSDictionary
//            self.model.authToken = innerData.valueForKey("authentication_token") as String
//            var school:NSDictionary = innerData.valueForKey("school") as NSDictionary
//            if school != NSNull(){
//                self.model.schoolId = school.valueForKey("id") as String
//                self.model.schoolName = school.valueForKey("name") as String
//                return true
//            } else{
//                return false
//            }
//        } else{
//            return false
//        }
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        self.screenName = "Home Screen"
//    }
//}