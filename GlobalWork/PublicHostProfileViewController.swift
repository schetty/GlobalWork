//
//  PublicHostProfileViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase

class PublicHostProfileViewController: UIViewController {
    
    // MARK: - OUTLETS & PROPERTIES for UI
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var taglineLabel: UILabel!
    @IBOutlet var languagesLabel: UILabel!
    @IBOutlet var monthsHelpNeededLabel: UILabel!
    
        // MARK - MONTH BUTTONS
    @IBOutlet var januraryButton: SSRadioButton!
    @IBOutlet var februaryButton: SSRadioButton!
    @IBOutlet var marchButton: SSRadioButton!
    @IBOutlet var aprilButton: SSRadioButton!
    @IBOutlet var mayButton: SSRadioButton!
    @IBOutlet var juneButton: SSRadioButton!
    @IBOutlet var julyButton: SSRadioButton!
    @IBOutlet var augustButton: SSRadioButton!
    @IBOutlet var septemberButton: SSRadioButton!
    @IBOutlet var octoberButton: SSRadioButton!
    @IBOutlet var novemberButton: SSRadioButton!
    @IBOutlet var decemberButton: SSRadioButton!
    
    @IBOutlet var descriptionTextView: UITextView!
    
    var ref: FIRDatabaseReference!


    override func viewDidLoad() {
        super.viewDidLoad()

//        ref = FIRDatabase.database().reference(withPath: "users")
//        ref.observe(.value, with: { snapshot in
//            
//            var newUserInfo: [Info] = []
//            
//            for info in snapshot.children {
//                let infoPiece = Info(snapshot: item as! FIRDataSnapshot)
//                newItems.append(planesItem)
//            }
//
//            print(snapshot.value)
//        })
//    }


}

}
