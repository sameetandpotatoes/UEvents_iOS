//
//  Date.swift
//  UEvents
//
//  Created by Sameet Sapra on 7/1/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation

class Date:NSDate{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d)
    }
    class func parseDate(dateStr:String, format:String="yyyy-MM-dd") -> NSDate {
        var dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        return dateFmt.dateFromString(dateStr)
    }
    class func parseTime(dateStr:String, format:String="yyyy'-'MM'-'dd'T'HH':'mm':'ss") -> NSDate {
        var dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        return dateFmt.dateFromString(dateStr)
    }
}