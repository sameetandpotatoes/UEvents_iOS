//
//  DateFormatter.swift
//  UEvents
//
//  Created by Sameet Sapra on 8/13/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation

struct DateFormatter{
    
    static func formatDate(#input: String) -> String{
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd"
        var formattedDate: String = formatter.stringFromDate(Date.parseDate(input))
        return formattedDate
    }
    static func formatTime(#input: String) -> String{
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a"
        var string = input.substringWithRange(Range<String.Index>(start: input.startIndex, end: input.rangeOfString(".000Z")!.startIndex))
        var formattedTime:NSString = formatter.stringFromDate(Date.parseTime(string))
        return formattedTime
    }
}