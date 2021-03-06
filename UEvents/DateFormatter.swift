//
//  DateFormatter.swift
//  UEvents
//
//  Created by Sameet Sapra on 8/13/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation

struct DateFormatter{
    /**
    * Formats string to date
    *
    * @param input Input date as string
    * @return Correctly formatted string
    */
    static func formatDate(#input: String) -> String{
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        var formattedDate: String = formatter.stringFromDate(Date.parseDate(input))
        return formattedDate
    }
    /**
    * Formats string to short date
    *
    * @param input Input date as string
    * @return Correctly formatted string
    */
    static func formatShortDate(#input: String) -> String{
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        var formattedDate: String = formatter.stringFromDate(Date.parseDate(input))
        return formattedDate
    }
    /**
    * Formats string to date with time
    *
    * @param input Input date as string
    * @return Correctly formatted string
    */
    static func formatTime(#input: String) -> String{
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a"
        var string = input.substringWithRange(Range<String.Index>(start: input.startIndex, end: input.rangeOfString(".000Z")!.startIndex))
        var formattedTime:NSString = formatter.stringFromDate(Date.parseTime(string))
        return formattedTime
    }
    /**
    * Converts input date to date object
    *
    * @return NSDate object with input date
    */
    static func returnDateObject(#input: String) -> NSDate?{
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var string = input.substringWithRange(Range<String.Index>(start: input.startIndex, end: input.rangeOfString(".000Z")!.startIndex))
        formatter.timeZone = NSTimeZone(name: "America/Chicago")
        return formatter.dateFromString(string)
    }
}