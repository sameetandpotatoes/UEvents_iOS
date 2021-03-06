//
//  EventCell.swift
//  UEvents
//
//  Created by Sameet Sapra on 7/6/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class EventCell:UITableViewCell{
    var eventTitle:UILabel = UILabel()
    var eventWhere:UILabel = UILabel()
    var eventWhen:UILabel = UILabel()
    var eventImage:UIImage = UIImage(named: "Default Image")
    var clock:UIImageView = UIImageView(image: UIImage(named: "Clock"))
    var location:UIImageView = UIImageView(image: UIImage(named: "Location"))
    var appearanceController: AppearanceController = AppearanceController()
    override init(style: UITableViewCellStyle, reuseIdentifier: String!){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var eventTextPadding:CGFloat = CGFloat(10.0)
        var iPadAdditive:CGFloat = appearanceController.isIPAD() ? 140 : 0

        eventTitle.frame = CGRectMake(eventTextPadding, 75+iPadAdditive, UIScreen.mainScreen().bounds.size.width - eventTextPadding, 40)
        eventTitle.textColor = UIColor.whiteColor()
        eventTitle.font = UIFont(name: "HelveticaNeue", size: 20.0)
        eventTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        eventTitle.numberOfLines = 0
        
        clock.frame = CGRectMake(eventTextPadding, 120+iPadAdditive, clock.image.size.width/1.5, clock.image.size.height/1.5)
        
        eventWhen.textColor = UIColor.whiteColor()
        eventWhen.frame = CGRectMake(clock.frame.width+eventTextPadding, clock.frame.origin.y - 5, UIScreen.mainScreen().bounds.size.width/4, 20)
        eventWhen.font = UIFont(name: "HelveticaNeue", size: 15.0)
        
        location.frame = CGRectMake(5+eventWhen.frame.width+eventTextPadding, clock.frame.origin.y, location.image.size.width/1.5, location.image.size.height/1.5)
        
        eventWhere.textColor = UIColor.whiteColor()
        eventWhere.frame = CGRectMake(eventWhen.frame.width+location.frame.width+(eventTextPadding * 2), clock.frame.origin.y - 5, UIScreen.mainScreen().bounds.size.width - (eventWhere.frame.origin.x * 2), 20)
        eventWhere.font = UIFont(name: "HelveticaNeue", size: 15.0)
        eventWhere.lineBreakMode = NSLineBreakMode.ByWordWrapping
        eventWhere.numberOfLines = 0
        
        self.imageView.image = eventImage
        self.contentView.addSubview(eventTitle)
        self.contentView.addSubview(location)
        self.contentView.addSubview(eventWhere)
        self.contentView.addSubview(clock)
        self.contentView.addSubview(eventWhen)
    }
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        self.imageView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, self.contentView.frame.height - 8)
    }
}
