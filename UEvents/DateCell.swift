//
//  DateCell.swift
//  UEvents
//
//  Created by Sameet Sapra on 7/6/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation
import UIKit
class DateCell:UITableViewCell{
    var date:UILabel = UILabel()
    var appearanceController: AppearanceController = AppearanceController()
    var colors:Dictionary<String, Dictionary<String, String>> = AppearanceController().getColors()
    override init(style: UITableViewCellStyle, reuseIdentifier: String!){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var frame:CGRect = CGRectMake(10, 5, UIScreen.mainScreen().bounds.size.width, 25)
        date.frame = frame
        date.textColor = appearanceController.colorWithHexString(colors["UChicago"]!["Primary"]!)
        date.font = UIFont(name: "HelveticaNeue", size: 16.0)
        self.contentView.backgroundColor = appearanceController.colorWithHexString("#FFFFFF")
        self.contentView.addSubview(date)
    }
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    override func setSelected(selected: Bool, animated: Bool) {// animate between regular and selected state
        
    }
    override func setHighlighted(highlighted: Bool, animated: Bool) {// animate between regular and highlighted state
    }
}