//
//  Message.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId:String?
    var text:String?
    var timeStamp:NSNumber?
    var toId:String?
    func chatPartnerId() -> String? {
        
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
    
}
