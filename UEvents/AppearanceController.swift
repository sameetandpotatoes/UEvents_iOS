//
//  AppearanceController.swift
//  UEvents
//
//  Created by Sameet Sapra on 7/1/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//
import QuartzCore
import UIKit
class AppearanceController: NSObject{
    var colorsHash = Dictionary<String, Dictionary<String, String>>()
    var width = UIScreen.mainScreen().bounds.size.width
    var height = UIScreen.mainScreen().bounds.size.height
    override init(){
        super.init()
    }
    func getColors() -> Dictionary<String, Dictionary<String, String>>{
        colorsHash["Solid"] = ["Black" : "#00000", "White" : "#FFFFFF", "Gray" : "#D3D3D3"]
        colorsHash["Normal"] = ["P" : "#8f3931", "S" : "#8a9045"]
        return colorsHash
    }
    /**
    * Converts hex to UIColor
    *
    * @param hex Color as a hex string
    * @return color as a UIColor
    */
    func hexToUI (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex,1))
        }
        if (countElements(cString) != 6) {
            return UIColor.grayColor()
        }
        var rString = cString.substringToIndex(advance(cString.startIndex, 2))
        var gString = cString.substringFromIndex(advance(cString.startIndex, 2)).substringToIndex(advance(cString.startIndex,2))
        var bString = cString.substringFromIndex(advance(cString.startIndex, 4)).substringToIndex(advance(cString.startIndex,2))
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner.scannerWithString(rString).scanHexInt(&r)
        NSScanner.scannerWithString(gString).scanHexInt(&g)
        NSScanner.scannerWithString(bString).scanHexInt(&b)
        var red:CGFloat = CGFloat(Double(r) / 255.0)
        var green:CGFloat = CGFloat(Double(g) / 255.0)
        var blue:CGFloat = CGFloat(Double(b) / 255.0)
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(1))
    }
    /**
    * Bolds first word of text with specific size
    *
    * @return Properly formatted text as NSMutableAttributedString
    */
    func boldText(#textToBold: String, fullText: String, size: CGFloat) -> NSMutableAttributedString{
        var mutableString:NSMutableAttributedString = NSMutableAttributedString(string: "\(textToBold) \(fullText)")
        var customHelvetica = UIFont(name: "HelveticaNeue", size: size)
        mutableString.addAttribute(NSFontAttributeName, value: customHelvetica, range: NSMakeRange(0,countElements(textToBold)))
        
        //Multi line
        var paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        mutableString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, mutableString.length))
        return mutableString
    }
    /**
    * Bolds first word of text with specific size and specific color
    *
    * @return Properly formatted text as NSMutableAttributedString
    */
    func boldTextWithColor(#textToBold: String, fullText: String, size: CGFloat, color: UIColor) -> NSMutableAttributedString{
        let mutableString = boldText(textToBold: textToBold, fullText: fullText, size: size)
        mutableString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, countElements(textToBold)))
        return mutableString
    }
    /**
    * Darkens image so text can be clearly visible
    *
    * @param level Alpha level of image
    * @return Darkened Image
    */
    func darkenImage(#image: UIImage, level: CGFloat) -> UIImage{
        var frame:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
        var tempView:UIView = UIView(frame: frame)
        tempView.backgroundColor = UIColor.blackColor()
        tempView.alpha = level
        
        UIGraphicsBeginImageContext(frame.size)
        var context:CGContextRef = UIGraphicsGetCurrentContext()
        image.drawInRect(frame)
        
        CGContextTranslateCTM(context, 0, frame.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextClipToMask(context, frame, image.CGImage)
        tempView.layer.renderInContext(context)
        var imageRef:CGImageRef = CGBitmapContextCreateImage(context)
        var toReturn:UIImage = UIImage(CGImage: imageRef)
        
        UIGraphicsEndImageContext()
        return toReturn
    }
    func isIPAD() -> Bool{
        return UIDevice.currentDevice().userInterfaceIdiom == .Pad
    }
    /**
    * Adds gray border to top and bottom of a UILabel
    *
    * @return CALayer with border
    */
    func addTopBottomBorder(label: UILabel) -> CALayer{
        var top:CALayer = CALayer()
        top.borderColor = hexToUI("#d3d3d3").CGColor
        top.borderWidth = 1
        top.frame = CGRectMake(0,0, CGRectGetWidth(label.frame),
            CGRectGetHeight(label.frame) + 2)
        return top
    }
    /**
    * Adds gray border bottom of a UILabel
    *
    * @return CALayer with border
    */
    func addBottomBorder(label: UIView) -> CALayer{
        var top:CALayer = CALayer()
        top.borderColor = hexToUI("#d3d3d3").CGColor
        top.borderWidth = 1
        top.masksToBounds = true
        top.frame = CGRectMake(-1,-1, CGRectGetWidth(label.frame),
            CGRectGetHeight(label.frame) + 2)
        return top
    }
}