//
//  Event.swift
//  UEvents
//
//  Created by Sameet Sapra on 7/1/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation

class Event:NSObject{
    var eventDescription:String = ""
    var id:String = ""
    var name:String = ""
    var owner:String = ""
    var startDate:String = ""
    var pictureURL:String = ""
    var coverURL:String = ""
    var endDate:String = ""
    var startTime:String = ""
    var endTime:String = ""
    var location:String = ""
    var attending:String = ""
    var url:String = ""
    var eventStatus:String = "declined"
    var tags:NSArray = []
    var startDateObj:NSDate?
    var endDateObj:NSDate?
    var shortStartDate:String = ""
    init(rowData : NSDictionary){
        //Parsing raw JSON into Event class
        //Null checking for each
        self.name = rowData["title"]!.isEqual(NSNull())
            ? ""
            : rowData["title"] as NSString
        self.id = rowData["event_id"]!.isEqual(NSNull())
            ? ""
            : rowData["event_id"] as NSString
        self.owner = rowData["organizer"]!.isEqual(NSNull())
            ? ""
            : rowData["organizer"] as NSString
        self.startDate = rowData["start_date"]!.isEqual(NSNull())
            ? ""
            : DateFormatter.formatDate(input: rowData["start_date"] as NSString)
        self.shortStartDate = rowData["start_date"]!.isEqual(NSNull())
            ? ""
            : DateFormatter.formatShortDate(input: rowData["start_date"] as NSString)
        self.coverURL = rowData["primary_image_url"]!.isEqual(NSNull())
            ? ""
            : rowData["primary_image_url"] as NSString
        self.pictureURL = rowData["secondary_image_url"]!.isEqual(NSNull())
            ? ""
            : rowData["secondary_image_url"] as NSString
        self.endDate = rowData["end_date"]!.isEqual(NSNull())
            ? ""
            : DateFormatter.formatDate(input: rowData["end_date"] as NSString)
        
        self.startTime = rowData["start_time"]!.isEqual(NSNull())
            ? ""
            : DateFormatter.formatTime(input: rowData["start_time"] as NSString)
        self.endTime = rowData["end_time"]!.isEqual(NSNull())
            ? ""
            : DateFormatter.formatTime(input: rowData["end_time"] as NSString)
        self.location = rowData["location"]!.isEqual(NSNull())
            ? "No Location"
            : rowData["location"] as NSString
        self.eventDescription = rowData["description"]!.isEqual(NSNull())
            ? ""
            : rowData["description"] as NSString
        self.attending = rowData["attending"]!.isEqual(NSNull())
            ? "0"
            : String(rowData["attending"] as NSInteger)
        self.url = rowData["url"]!.isEqual(NSNull())
            ? ""
            : rowData["url"] as NSString
        self.tags = rowData["tags"] as NSArray
        
        self.startDateObj = DateFormatter.returnDateObject(input: (rowData["start_time"] as String))
        if !(rowData["end_date"]!.isEqual(NSNull())){
            self.endDateObj = DateFormatter.returnDateObject(input: (rowData["end_time"] as String))
        } else{
            self.endDateObj = self.startDateObj
        }
    }
}