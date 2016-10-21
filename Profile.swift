//
//  Profile.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit

struct Profile {
    
    
    let isHost:Bool?
    var displayName: String?
    var countriesVisiting:[String]
//    var userDescription:String?
    var languagesSpoken:String?
    let tagline:String?
    let dateOfBirth:String!
    var userFeedbacks:[String]
    let profilePhotoURL:String = ""
    var datesHelpNeeded:Array<String>
    let location: String?
//    let hostSitePhotoURL:String?
    
    
    
}
//
//if let user = FIRAuth.auth()?.currentUser {
//    for profile in user.providerData {
//        let providerID = profile.providerID
//        let uid = profile.uid;  // Provider-specific UID
//        let name = profile.displayName
//        let email = profile.email
//        let photoURL = profile.photoURL
//    }
//} else {
//    // No user is signed in.
//}
