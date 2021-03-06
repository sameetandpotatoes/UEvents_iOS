//
//  SchoolSelector.swift
//  UEvents
//
//  Created by Sameet Sapra on 8/8/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

class SchoolSelector: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate, SchoolsProtocol{
    @IBOutlet weak var tableView: UITableView!
    var tableData: NSArray = NSArray()
    var user:User!
    var appearanceController: AppearanceController = AppearanceController()
    var colors:Dictionary<String, Dictionary<String, String>> = AppearanceController().getColors()
    var api:APIController!
    override func viewDidLoad(){
        setUpUI()
        SVProgressHUD.dismiss()
    }
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()){
            //API request to get schools
            self.api = APIController(curUser: self.user)
            self.api.schoolsP = self
            self.api.getSchools()
            UIView.setAnimationsEnabled(true)
        }
    }
    //Only rotate screen if iPad
    override func shouldAutorotate() -> Bool {
        return appearanceController.isIPAD()
    }
    func setUpUI(){
        dispatch_async(dispatch_get_main_queue()){
            self.navigationController.navigationBarHidden = false
            self.navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            self.navigationItem.title = "Choose Your School"
            self.navigationController.interactivePopGestureRecognizer.enabled = false;
            self.navigationController.navigationBar.barTintColor = self.appearanceController.hexToUI(self.colors["Normal"]!["P"]!)
            self.navigationController.navigationBar.tintColor = self.appearanceController.hexToUI(self.colors["Solid"]!["White"]!)
            self.navigationItem.hidesBackButton = true
            self.navigationController.toolbar.opaque = true
            self.navigationController.toolbar.barTintColor = self.appearanceController.hexToUI(self.colors["Normal"]!["P"]!)
            self.navigationController.toolbarHidden = true
            //to adjust for the full screen pages (this messed up the layouting for some reason
            self.view.frame = CGRectMake(0,0,self.appearanceController.width, self.appearanceController.height)
        }
    }
    func didReceiveSchools(results: NSArray) {
        self.tableData = results
        self.tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //For use in Google Analytics
        self.screenName = "Selecting School"
    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        var listItem:NSDictionary = tableData[indexPath.row] as NSDictionary
        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "schools")
        cell.textLabel.text = listItem["name"] as NSString
        return cell
    }
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        //Post school_id to API
        var env:ENVRouter = ENVRouter(curUser: user!)
        var listItem:NSDictionary = tableData[indexPath.row] as NSDictionary
        var headers:NSMutableDictionary = NSMutableDictionary()
        headers.setValue("application/json", forKey: "Accept")
        headers.setValue("application/json", forKey: "Content-type")
        var userParam = ["school_id" : String(listItem["id"] as Int)]
        var response:UNIHTTPJsonResponse = (UNIRest.putEntity({ (request: UNIBodyRequest!) -> Void in
            request.url = env.getUpdateUserURL()
            request.headers = headers
            request.body = NSJSONSerialization.dataWithJSONObject(userParam, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        })).asJson()
        
        //Redirect to Events
//        var allEvents:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events")
//            as EventsController
//        user!.schoolName = listItem["name"] as String
//        allEvents.user = user!
//        allEvents.tag = "All"
//        self.navigationController.pushViewController(allEvents, animated: true)
        var tutorial:TutorialController = self.storyboard.instantiateViewControllerWithIdentifier("Tutorial") as TutorialController
        user!.schoolName = listItem["name"] as String
        tutorial.user = user!
        self.navigationController.pushViewController(tutorial, animated: true)
    }
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat{
        return 50
    }
}