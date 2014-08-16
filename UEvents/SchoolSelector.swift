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
    var user:User?
    var appearanceController: AppearanceController = AppearanceController()
    var colors:Dictionary<String, Dictionary<String, String>> = AppearanceController().getColors()
    override func viewDidLoad(){
        setUpUI()
        var api = SchoolAPI()
        api.schoolsP = self
        api.getSchools()
    }
    override func shouldAutorotate() -> Bool {
        return appearanceController.isIPAD()
    }
    func setUpUI(){
        self.navigationController.navigationBarHidden = false
        self.navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.title = "Choose Your School"
        self.navigationController.interactivePopGestureRecognizer.enabled = false;
        self.navigationController.navigationBar.barTintColor = appearanceController.colorWithHexString(colors["UChicago"]!["Primary"]!)
        self.navigationController.navigationBar.tintColor = appearanceController.colorWithHexString(colors["Default"]!["Secondary"]!)
        self.navigationItem.hidesBackButton = true
        self.navigationController.toolbar.opaque = true
        self.navigationController.toolbar.barTintColor = appearanceController.colorWithHexString(colors["UChicago"]!["Primary"]!)
        self.navigationController.toolbarHidden = true
        fixAnimation()
    }
    func fixAnimation(){
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            //make calculations
            dispatch_async(dispatch_get_main_queue(),{
                UIView.setAnimationsEnabled(true)
            })
        })
    }
    func didReceiveAPIResults(results: NSArray){
        self.tableData = results
        self.tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        //Post to API
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
        var allEvents:EventsController = self.storyboard.instantiateViewControllerWithIdentifier("events")
            as EventsController
        user!.schoolName = listItem["name"] as String
        allEvents.user = user!
        self.navigationController.pushViewController(allEvents, animated: false)
    }
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat{
        return 50
    }
}