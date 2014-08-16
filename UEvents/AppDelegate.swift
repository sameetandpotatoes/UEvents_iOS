//
//  AppDelegate.swift
//  UEvents
//
//  Created by Sameet Sapra on 6/29/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    // FBSample logic
    // In this sample the app delegate maintains a property for the current
    // active session, and the view controllers reference the session via
    // this property, as well as play a role in keeping the session object
    // up to date; a more complicated application may choose to introduce
    // a simple singleton that owns the active FBSession object as well
    // as access to the object by the rest of the application
    var session:FBSession?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary) -> Bool {
        //Appirater
        Appirater.setAppId("YourAppId")
        Appirater.setDebug(false)
        Appirater.setDaysUntilPrompt(7)
        Appirater.setUsesUntilPrompt(0)
        Appirater.setSignificantEventsUntilPrompt(3)
        Appirater.setTimeBeforeReminding(2)
        Appirater.appLaunched(true)
        //GA
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().trackerWithTrackingId("UA-43806248-2")
        return true
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool {
//        var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
//        return wasHandled
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: self.session)
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        Appirater.appEnteredForeground(true)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBAppEvents.activateApp()
        FBAppCall.handleDidBecomeActiveWithSession(self.session)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.session!.close()
    }


}

