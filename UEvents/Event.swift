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
    override init(){
        
    }
    init(rowData : NSDictionary){
        self.name = rowData["title"].isEqual(NSNull())
            ? ""
            : rowData["title"] as NSString
        self.id = rowData["event_id"].isEqual(NSNull())
            ? ""
            : rowData["event_id"] as NSString
        self.owner = rowData["organizer"].isEqual(NSNull())
            ? ""
            : rowData["organizer"] as NSString
        self.startDate = rowData["start_date"].isEqual(NSNull())
            ? ""
            : DateFormatter.formatDate(input: rowData["start_date"] as NSString)
        self.coverURL = rowData["primary_image_url"].isEqual(NSNull())
            ? ""
            : rowData["primary_image_url"] as NSString
        self.pictureURL = rowData["secondary_image_url"].isEqual(NSNull())
            ? ""
            : rowData["secondary_image_url"] as NSString
        self.endDate = rowData["end_date"].isEqual(NSNull())
            ? ""
            : DateFormatter.formatDate(input: rowData["end_date"] as NSString)
        
        self.startTime = rowData["start_time"].isEqual(NSNull())
            ? ""
            : DateFormatter.formatTime(input: rowData["start_time"] as NSString)
        self.endTime = rowData["end_time"].isEqual(NSNull())
            ? ""
            : DateFormatter.formatTime(input: rowData["end_time"] as NSString)
        self.location = rowData["location"].isEqual(NSNull())
            ? ""
            : rowData["location"] as NSString
        self.eventDescription = rowData["description"].isEqual(NSNull())
            ? ""
            : rowData["description"] as NSString
        self.attending = rowData["attending"].isEqual(NSNull())
            ? "0"
            : String(rowData["attending"] as NSInteger)
        self.url = rowData["url"].isEqual(NSNull())
            ? ""
            : rowData["url"] as NSString
        self.tags = rowData["tags"] as NSArray
//        self.name = rowData["name"].isEqual(NSNull())
//                    ? ""
//            : String(format: rowData["name"] as NSString)
//        self.id = rowData["event_id"].isEqual(NSNull())
//                    ? ""
//            : String(format: rowData["event_id"] as NSString)
//        self.owner = rowData["owner"].isEqual(NSNull())
//                    ? ""
//            : String(format: rowData["owner"] as NSString)
//        self.startDate = rowData["start_date"].isEqual(NSNull())
//                    ? ""
//            : String(format: rowData["start_date"] as NSString)
//        self.coverURL = rowData["cover_url"].isEqual(NSNull())
//                    ? ""
//            : String(format: rowData["cover_url"] as NSString)
//        self.pictureURL = rowData["picture_url"].isEqual(NSNull())
//                    ? ""
//            : String(format: rowData["picture_url"] as NSString)
//        self.endDate = rowData["end_date"].isEqual(NSNull())
//                    ? ""
//            : String(format: rowData["end_date"] as NSString)
//        self.startTime = rowData["start_time"].isEqual(NSNull())
//                    ? ""
//            : String(format: rowData["start_time"] as NSString)
//        self.endTime = rowData["end_time"].isEqual(NSNull())
//                    ? ""
//            : String(format: rowData["end_time"] as NSString)
//        self.location = rowData["location"].isEqual(NSNull())
//                    ? ""
//            : String(format: rowData["location"] as NSString)
//        self.eventDescription = rowData["description"].isEqual(NSNull())
//                    ? ""
//            : String(format: rowData["description"] as NSString)
//        self.attending = rowData["attending"].isEqual(NSNull())
//                    ? "0"
//                    : String(rowData["attending"] as NSInteger)
//        self.tags = rowData["tags"] as NSArray
    }
}