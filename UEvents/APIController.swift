//
//  APIController.swift
//  UEvents
//
//  Created by Sameet Sapra on 6/30/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import UIKit

protocol AllEventsProtocol {
    func didReceiveAllEvents(results: Array<NSObject>)
}
protocol FilteredProtocol {
    func didReceiveFilteredEvents(results: Array<NSObject>)
}
protocol MyEventsProtocol {
    func didReceiveUserEvents(results: Array<NSObject>)
}
protocol SchoolsProtocol {
    func didReceiveSchools(results: NSArray)
}
class APIController: NSObject {
    var allEvents   :NSURLConnection?
    var filter      :NSURLConnection?
    var userEvents  :NSURLConnection?
    var schools     :NSURLConnection?
    var allEventsP  :AllEventsProtocol?
    var filterP     :FilteredProtocol?
    var userEventsP :MyEventsProtocol?
    var schoolsP    :SchoolsProtocol?
    var env:ENVRouter!
    var data = NSMutableData()
    var eventsArray = NSArray()
    var schoolsArray = NSArray()
    var user:User!
    init(curUser: User){
        user = curUser
        env = ENVRouter(curUser: user)
    }
    /**
    * Starts the request to obtain events
    * @param tag The tag to filter events
    */
    func getEvents(tag: String!){
        var urlPath = env.getFilterURL(tag)
        println(urlPath)
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        filter = NSURLConnection(request: request, delegate: self, startImmediately: true)
        filter!.start()
    }
    /**
    * Starts the request to obtain user's events
    */
    func getUserEvents(){
        var urlPath = env!.getUserEventsURL()
        println(urlPath)
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        userEvents = NSURLConnection(request: request, delegate: self, startImmediately: true)
        userEvents!.start()
    }
    /**
    * Starts the request to all events for events index page
    */
    func getEvents() {
        var urlPath = env!.getEventsURL()
        println(urlPath)
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        allEvents = NSURLConnection(request: request, delegate: self, startImmediately: true)
        allEvents!.start()
    }
    /**
    * Starts the request to obtain schools available
    */
    func getSchools(){
        var urlPath = env!.getSchoolsURL()
        println(urlPath)
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        schools = NSURLConnection(request: request, delegate: self, startImmediately: false)
        schools!.start()
    }
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        println("Connection failed.\(error.localizedDescription)")
        var alert:UIAlertView = UIAlertView(title: "Error Retrieving Events", message: "Please check your internet connection and try again.", delegate: self, cancelButtonTitle: "Ok")
        alert.show()
    }
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // Received a new request, clear out the data object
        self.data = NSMutableData()
    }
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        // Append the recieved chunk of data to our data object
        self.data.appendData(data)
    }
    func parseEvents(connection: NSURLConnection!){
        //Convert the retrieved data in to an object through JSON deserialization
        var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
        var jsonObject:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: error)
        
        if !jsonObject.isEqual(nil){
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
                                eventsArray = user["event_groups"] as NSArray
                            }
                        }
                    }
                }
            } else{
                schoolsArray = jsonObject as NSArray
                //Bypass all of the events filtering
                schoolsP!.didReceiveSchools(schoolsArray)
            }
        } else{
            //Already handled error if connection failed
        }
        var objectEvents:Array<NSObject> = []
        formatDate()
        //Iterate through and add both dates and events to new array
        for index in 0..<eventsArray.count{
            var rowData:NSDictionary = eventsArray[index] as NSDictionary
            if let events = rowData["events"] as? NSArray{
                //Only add dates if there are events for that date
                if events.count > 0 {
                    objectEvents.append(rowData["date"] as NSString)
                }
                for event in 0..<events.count {
                    var currentEvent:Event = Event(rowData: events[event] as NSDictionary)
                    objectEvents.append(currentEvent)
                }
            }
        }
        //If there were no events, display something to the user
        if (objectEvents.count == 0){
            objectEvents.append("No events under this category")
        }
        //Callback
        if (allEvents == connection){
            allEventsP!.didReceiveAllEvents(objectEvents)
        } else if (userEvents == connection){
            userEventsP!.didReceiveUserEvents(objectEvents)
        } else if (filter == connection){
            filterP!.didReceiveFilteredEvents(objectEvents)
        }
    }
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        parseEvents(connection)
    }
    /**
    * Iterates over "date" objects in raw json result and formats them
    */
    func formatDate(){
        for index in 0..<eventsArray.count {
            var rowData: NSDictionary = eventsArray[index] as NSDictionary
            if !rowData.isEqual(nil){ //Just being extra careful here so we don't run into any errors
                var rawDate:String = rowData["date"] as String
                var formattedDate:String = DateFormatter.formatDate(input: rawDate)
                rowData.setValue(formattedDate, forKey: "date")
            }
        }
    }
}
