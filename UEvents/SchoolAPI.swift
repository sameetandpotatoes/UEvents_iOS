//
//  SchoolAPI.swift
//  UEvents
//
//  Created by Sameet Sapra on 8/8/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation

protocol SchoolsProtocol{
    func didReceiveAPIResults(results: NSArray)
}
class SchoolAPI:NSObject{
    var schools:NSURLConnection?
    var schoolsP:SchoolsProtocol?
    var data = NSMutableData()
    var schoolsArray = NSArray()
    override init(){
        
    }
    func getSchools() {
        var urlPath = "http://localhost:3000/api/schools.json"
        var url: NSURL = NSURL(string: urlPath)
        var request:NSURLRequest = NSURLRequest(URL: url)
        schools = NSURLConnection(request: request, delegate: self, startImmediately: false)
        schools!.start()
    }
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        println("Connection failed.\(error.localizedDescription)")
        var alert:UIAlertView = UIAlertView(title: "Error Retrieving Events", message: "Please check your internet connection and try again.", delegate: self, cancelButtonTitle: "Ok")
        alert.show()
    }
    func connection(connection: NSURLConnection, didRecieveResponse response: NSURLResponse)  {
        println("Received response")
    }
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // Recieved a new request, clear out the data object
        self.data = NSMutableData()
    }
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        // Append the recieved chunk of data to our data object
        self.data.appendData(data)
    }
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var dataAsString: NSString = NSString(data: self.data, encoding: NSUTF8StringEncoding)
        var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
        var jsonObject:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: error)
        if jsonObject != nil{
            schoolsArray = jsonObject as NSArray
        } else{
            //Error
        }
        schoolsP!.didReceiveAPIResults(schoolsArray)
    }
}