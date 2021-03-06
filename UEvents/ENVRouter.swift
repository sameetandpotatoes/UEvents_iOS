//
//  ENVRouter.swift
//  UEvents
//
//  Created by Sameet Sapra on 8/14/14.
//  Copyright (c) 2014 Sameet Sapra. All rights reserved.
//

import Foundation

class ENVRouter: NSObject{
//    var localENV:String = "http://uevents.192.168.1.75.xip.io:20559/"
    var localENV:String = "http://localhost:3000/"
    var prodENV:String = "http://uevents-staging.herokuapp.com/"
    var eventsURL:String = "api/v2/events.json"
    var userEventsURL:String = "api/v2/events/user.json"
    var postUserURL:String = "api/v2/users"
    var updateUserURL:String = "api/v2/users/"
    var singleEventURL:String = "api/v2/events/"
    var schoolsURL:String = "api/v2/schools.json"
    var user:User = User()
    init(curUser: User){
        user = curUser
    }
    /**
    * Determines if user is in local environment or production environment
    * @return url depending on user environment
    */
    func getENV() -> String{
        if UIDevice.currentDevice().model == "iPhone Simulator" {
            return localENV
        } else{
            return prodENV
        }
//        return localENV
    }
    func getSingleEventURL(eventId: String, eventStatus: String) -> String{
        return getENV() + singleEventURL + "\(eventId)/\(eventStatus)" + getAuthToken()
    }
    func getPostUserURL() -> String{
        return getENV() + postUserURL
    }
    func getUpdateUserURL() -> String{
        return getENV() + updateUserURL + user.userId + getAuthToken()
    }
    func getSchoolsURL() -> String{
        return getENV() + schoolsURL
    }
    func getEventsURL() -> String{
        return getENV() + eventsURL + getAuthToken()
    }
    func getUserEventsURL() -> String{
        return getENV() + userEventsURL + getAuthToken()
    }
    func getFilterURL(filter: String) -> String{
        return getEventsURL() + "&filter=\(filter)"
    }
    func getFacebookAppID() -> String{
        if getENV() == localENV{
            return "467774006627402"
        } else{
            return "511481675563436"
        }
    }
    func getAuthToken() -> String{
        return "?authentication_token=\(user.authToken)"
    }
}