//
//  User.swift
//  UEvents
//
//  Created by Sameet Sapra on 8/12/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation

class User:NSObject{
    var name:String         = ""
    var userId:String       = ""
    var email:String        = ""
    var authToken:String    = ""
    var firstName:String    = ""
    var lastName:String     = ""
    var pictureURL:String   = ""
    var accessToken:String  = ""
    var schoolId:NSString   = ""
    var schoolName:NSString = ""
    override init(){
        
    }
    init(user: NSDictionary){
        //Parse NSDictionary
        name = user.valueForKey("name") as String
        firstName = user.valueForKey("first_name") as String
        lastName = user.valueForKey("last_name") as String
        userId = user.valueForKey("id") as String
        email = user.valueForKey("email") as String
        pictureURL = "http://graph.facebook.com/"+userId+"/picture?width=200&height=200"
    }
    func setAuthToken(at: String){
        authToken = at
    }
}