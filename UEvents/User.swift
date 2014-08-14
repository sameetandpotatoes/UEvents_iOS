//
//  User.swift
//  UEvents
//
//  Created by Sameet Sapra on 8/12/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation

class User:NSObject{
    var name:String = ""
    var id:String = ""
    var email:String = ""
    var authToken:String = ""
    var firstName:String = ""
    var lastName:String = ""
    var pictureURL:String = ""
    var accessToken:String = ""
    var schoolId:NSString = ""
    var schoolName:NSString = ""
    init(user: FBGraphUser){
        name = user.name
        firstName = user.first_name
        lastName = user.last_name
        id = user.objectID
        email = user.objectForKey("email") as String
        pictureURL = "http://graph.facebook.com/"+id+"/picture?type=square"
        accessToken = FBSession.activeSession().accessTokenData.accessToken
    }
    func setAuthToken(at: String){
        authToken = at
    }
    func getSchoolId() -> NSString{
        return schoolId
    }
}