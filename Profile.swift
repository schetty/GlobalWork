//
//  Profile.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase

struct Profile {
    
    
    let isHost:Bool?
    var displayName: String!
    var countriesVisiting:String?
    let userDescription:String?
    var languagesSpoken:String?
    let tagline:String?
    let dateOfBirth:String!
    //    var userFeedbacks:[Dictionary]
    var profilePhotoURL:String?
    var datesHelpNeeded:String
    let location: String?
//    let hostSitePhotoURL:String?
    let ref: FIRDatabaseReference?
    
    
    
    init(isHost: Bool, displayName: String, countriesVisiting:String, userDescription:String, languagesSpoken:String, tagline: String, dateOfBirth:String, /*userFeedbacks:[Dictionary],*/ profilePhotoURL:String, datesHelpNeeded:String, location: String) {
        self.isHost = isHost
        self.displayName = displayName
        self.countriesVisiting = countriesVisiting
        self.languagesSpoken = languagesSpoken
        self.tagline = tagline
        self.userDescription = userDescription
        self.dateOfBirth = dateOfBirth
        self.profilePhotoURL = profilePhotoURL
        self.datesHelpNeeded = datesHelpNeeded
        self.location = location
        self.ref = nil
    }
    
    var firbaseFormatted:NSDictionary{
             return [
                "isHost" : NSNumber(booleanLiteral: isHost!),
                "displayName" : NSString(string:displayName),
                "countriesVisiting" : NSString(string:countriesVisiting ?? ""),
                "langsSpoken" :  NSString(string:languagesSpoken ?? ""),
                "tagline" : NSString(string:tagline ?? ""),
                "userDescription" : NSString(string:userDescription ?? ""),
                "DOB" :  NSString(string: dateOfBirth!),
                "profileImageUrl" :  NSString(string:profilePhotoURL ?? ""),
                "monthsHelpNeeded" : NSString(string:datesHelpNeeded),
                "userLocation" :  NSString(string:location ?? "")
            ]
    }

}



