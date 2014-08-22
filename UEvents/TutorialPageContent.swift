//
//  TutorialPageContent.swift
//  UEvents
//
//  Created by Sameet Sapra on 8/22/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation

class TutorialPageContent:GAITrackedViewController{
    @IBOutlet var backgroundImageView:UIImageView!
    @IBOutlet var pageControl:UIPageControl!
    var pageIndex:Int = 0
    var imageFile:String = ""
    var user:User!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundImageView!.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.backgroundImageView!.image = UIImage(named: self.imageFile)
        self.backgroundImageView!.backgroundColor = UIColor.whiteColor()
        //Scaling image
        let size=CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);//set the width and height
        UIGraphicsBeginImageContext(size);
        self.backgroundImageView!.image.drawInRect(CGRectMake(0,0,size.width,size.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        self.backgroundImageView!.image = newImage
        //here is the scaled image which has been changed to the size specified
        UIGraphicsEndImageContext();
    }
    @IBAction func okButton(sender: AnyObject) {
        //All Events
        var allEvents:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events")
            as EventsController
        allEvents.user = user!
        allEvents.tag = "All"
        self.navigationController.pushViewController(allEvents, animated: true)
    }
    
}