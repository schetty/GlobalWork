//
//  Profile.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit

struct Profile {
    
    
    let isHost:Bool
    var countriesVisiting:[String]
    var userDescription:String = String()
    var languagesSpoken:[String]
    let tagline:String = String()
    var userFeedbacks:[String]
    let profilePhotoURL:String = ""
    let age:int_fast64_t = int_fast64_t()
    var datesHelpNeeded:NSDateInterval
    let location:NSLocale
    let hostSitePhotoURL:String = String()
    
    
    
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
