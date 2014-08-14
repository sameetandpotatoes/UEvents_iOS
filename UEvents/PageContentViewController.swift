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
//    @IBOutlet var loginView:FBLoginView?
//    @IBOutlet var backgroundImageView:UIImageView?
//    var pageIndex:Int = 0
//    var titleText:String = ""
//    var imageFile:String = ""
//    var fbl:FBLoginView
////    func initWithNibName(nibNameOrNil: NSString, nibBundleOrNil: NSBundle) -> id{
////    }
//    override func viewDidLoad(){
//        super.viewDidLoad()
//        self.fbl = FBLoginView()
//        self.fbl.delegate = self
//        self.loginView!.readPermissions = ["public_profile", "email", "user_friends"]
//        for var obj in loginView.subviews{
//            if (obj.isKindOfClass(UILabel))
//            {
//                var loginLabel:UILabel = obj
//                loginLabel.text = "CONNECT WITH FACEBOOK"
//                loginLabel.font = UIFont(fontWithName:"HelveticaNeue",size:14.0)
//            }
//        }
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
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        self.screenName = "Home Screen"
//    }
//    func loginViewFetchedUserInfo(loginView: FBLoginView, user: FBGraphUser){
//        
//    }
//    func loginViewShowingLoggedOutUser(loginView: FBLoginView){
//        FBSession.activeSession().closeAndClearTokenInformation()
//        let name:String = self.topMostController().
//        if
//        FBSession.activeSession.closeAndClearTokenInformation;
//        NSString *name = NSStringFromClass([[self topMostController] class]);
//        if ([name rangeOfString:@"ViewController"].location == NSNotFound){
//            UINavigationController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"nav"];
//            [self presentViewController:loginViewController animated:true completion:nil];
//        } else {
//            [self performSelector: @selector(login) withObject:nil afterDelay:100000.0];
//        }
//    }
//    func topMostController() -> UIViewController{
//        return self.navigationController.visibleViewController
//    }
//}