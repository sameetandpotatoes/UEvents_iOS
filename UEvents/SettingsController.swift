//
//  SettingsController.swift
//  UEvents
//
//  Created by Sameet Sapra on 7/3/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
class SettingsController: GAITrackedViewController, FBLoginViewDelegate, UITabBarDelegate{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var profilePictureView : UIImageView?
    
    @IBOutlet weak var mainTabBar: UITabBar!
    var appearanceController: AppearanceController = AppearanceController()
    var colors:Dictionary<String, Dictionary<String, String>>!
    var user:User!
    override func viewDidLoad() {
        colors = appearanceController.getColors()
        self.setUpUI()
        self.mainTabBar.delegate = self
        //Updating Image and Text
        dispatch_async(dispatch_get_main_queue()){
            //Update image
            self.mainTabBar.selectedItem = self.mainTabBar.items[3] as UITabBarItem
            var imgURL: NSURL = NSURL(string: "http://graph.facebook.com/\(self.user.userId)/picture?width=200&height=200")
            var request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    var imgData: NSData = NSData(contentsOfURL: imgURL)
                    self.profilePictureView!.image = UIImage(data: imgData)
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            //Update text
            self.name.text = self.user.name
            self.school.text = self.user.schoolName as String
            self.loginButton.backgroundColor = self.appearanceController.hexToUI(self.colors["Normal"]!["P"]!)
            //Customize image
            self.profilePictureView!.layer.cornerRadius = self.profilePictureView!.frame.size.width/2
            self.profilePictureView!.layer.masksToBounds = true
            self.profilePictureView!.layer.borderWidth = 0
        }
    }
    func setUpUI(){
        dispatch_async(dispatch_get_main_queue()){
            self.navigationController.interactivePopGestureRecognizer.enabled = false;
            self.navigationController.navigationBar.barTintColor = self.appearanceController.hexToUI(self.colors["Normal"]!["P"]!)
            self.navigationController.navigationBar.tintColor = self.appearanceController.hexToUI(self.colors["Solid"]!["White"]!)
            self.navigationController.toolbarHidden = true
            //Hide back button completely
            self.navigationItem.setHidesBackButton(true, animated: true)
            self.navigationController.navigationBar.topItem.title = ""
            //But keep the centered title
            self.navigationItem.title = "Settings"
            self.view.userInteractionEnabled = true
            self.mainTabBar.barTintColor = self.appearanceController.hexToUI(self.colors["Normal"]!["P"]!)
            self.mainTabBar.selectedImageTintColor = UIColor.whiteColor()
            UIView.setAnimationsEnabled(true)
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //For use in Google Analytics
        self.screenName = "Settings"
    }
    @IBAction func handleLogOut(sender: AnyObject) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        //Double checking both sessions are closed and cleared
        FBSession.activeSession().closeAndClearTokenInformation()
        appDelegate.session!.closeAndClearTokenInformation()
        //Go back to home page
        var home:UIViewController = self.storyboard.instantiateViewControllerWithIdentifier("login") as UIViewController
        self.navigationController.pushViewController(home, animated: true)
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
            break
            //Don't reload the entire class
            var settings:SettingsController = self.storyboard.instantiateViewControllerWithIdentifier("settings") as SettingsController
            settings.user = user!
            self.navigationController.pushViewController(settings, animated: false)
        default:
            println("not possible")
        }
    }}