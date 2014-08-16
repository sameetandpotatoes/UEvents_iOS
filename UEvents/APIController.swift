//
//  APIController.swift
//  UEvents
//
//  Created by Sameet Sapra on 6/30/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import UIKit

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: Array<NSObject>)
}
protocol FilteredProtocol {
    func didReceiveAPIResults(results: Array<NSObject>)
}
protocol MyEventsProtocol {
    func didReceiveAPIResults(results: Array<NSObject>)
}
class APIController: NSObject {
    var allEvents:NSURLConnection?
    var filter:NSURLConnection?
    var userEvents:NSURLConnection?
    
    var allEventsP: APIControllerProtocol?
    var filterP: FilteredProtocol?
    var userEventsP: MyEventsProtocol?
    var env:ENVRouter?
    var data = NSMutableData()
    var eventsArray = NSArray()
    var schoolsArray = NSArray()
    var user:User = User()
    init(curUser: User){
        user = curUser
        env = ENVRouter(curUser: user)
    }
    func getEvents(tag: String!){
        var urlPath = env!.getFilterURL(tag)
        println(urlPath)
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        filter = NSURLConnection(request: request, delegate: self, startImmediately: true)
        filter!.start()
    }
    func getUserEvents(){
        var urlPath = env!.getUserEventsURL()
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        userEvents = NSURLConnection(request: request, delegate: self, startImmediately: true)
        userEvents!.start()
    }
    func getEvents() {
        var urlPath = env!.getEventsURL()
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        allEvents = NSURLConnection(request: request, delegate: self, startImmediately: true)
        allEvents!.start()
    }
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        println("Connection failed.\(error.localizedDescription)")
        var alert:UIAlertView = UIAlertView(title: "Error Retrieving Events", message: "Please check your internet connection and try again.", delegate: self, cancelButtonTitle: "Ok")
        alert.show()
    }
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse)  {
        println("Received response")
    }
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // Received a new request, clear out the data object
        println("Received new request")
        self.data = NSMutableData()
    }
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        // Append the recieved chunk of data to our data object
        self.data.appendData(data)
    }
    func parseEvents(connection: NSURLConnection!){
        var dataAsString: NSString = NSString(data: self.data, encoding: NSUTF8StringEncoding)
        //Convert the retrieved data in to an object through JSON deserialization
        var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
        var jsonObject:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: error)
        if jsonObject != nil{
            if allEvents == connection || filter == connection{
                if let nsDict = jsonObject as? NSDictionary{
                    if let swiftDict = nsDict as Dictionary?{
                        eventsArray = swiftDict["event_groups"] as NSArray
                    }
                }
            } else if userEvents == connection{
                if let nsDict = jsonObject as? NSDictionary{
                    if let swiftDict = nsDict as Dictionary?{
                        if let userNS = swiftDict["user"] as? NSDictionary{
                            if let user = userNS as Dictionary?{
                                eventsArray = user["events"] as NSArray
                            }
                        }
                    }
                }
            }
        } else{
            //ERROR
        }
        var objectEvents:Array<NSObject> = []
        if eventsArray.count > 2{
            formatDate()
        
            for index in 0..<eventsArray.count{
                var rowData:NSDictionary = eventsArray[index] as NSDictionary
                if let events = rowData["events"] as? NSArray{
                    if events.count > 0 {
                        objectEvents.append(rowData["date"] as NSString)
                    }
                    for event in 0..<events.count {
                        var currentEvent:Event = Event(rowData: events[event] as NSDictionary)
                        objectEvents.append(currentEvent)
                    }
                }
            }
        }
        if (allEvents == connection){
            allEventsP!.didReceiveAPIResults(objectEvents)
        } else if (userEvents == connection){
            userEventsP!.didReceiveAPIResults(objectEvents)
        } else if (filter == connection){
            filterP!.didReceiveAPIResults(objectEvents)
        }
    }
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        parseEvents(connection)
    }
    func formatDate(){
        if eventsArray.count == 1{
            return
        }
        for index in 0..<eventsArray.count {
            var rowData: NSDictionary = eventsArray[index] as NSDictionary
            var rawDate:String = rowData["date"] as String
            var formattedDate:String = DateFormatter.formatDate(input: rawDate)
            rowData.setValue(formattedDate, forKey: "date")
        }
    }
}
