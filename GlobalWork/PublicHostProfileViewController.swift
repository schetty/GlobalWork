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
    
    var profile: Profile?
    var arrayMonthsHelpNeeded:[String]?
    private var monthsNeedHelp:[String]?
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        loadUserDataFromDatabase()
        
        
    }
    
    
    func checkIfUserIsLoggedIn () {
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        if (uid == nil) {
            print("not logged in")
            return
        }
        
        FIRDatabase.database().reference().child("data/users/").child(uid!).observeSingleEvent(of: .value, with : { (Snapshot) in
            
            if let snapDict = Snapshot.value as? [String : AnyObject] {
                    print(snapDict)
                self.monthsNeedHelp = snapDict["monthsHelpNeeded"] as! [String]?
                }
            })
            
        }
    
    
    
   private func loadUserDataFromDatabase() {
        if let profileImageURL = profile?.profilePhotoURL {
            let url = NSURL(string: profileImageURL)
            URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async{
                    
                    self.profileImageView.image = UIImage(data: data!)

                    }
                
                
            }).resume()
    }
    
    }
    
    
    private func fillInMonthsNeedHelp() {
        let monthButtons = [januraryButton,
                            februaryButton,
                            marchButton,
                            aprilButton,
                            mayButton,
                            juneButton,
                            julyButton,
                            augustButton,
                            septemberButton,
                            octoberButton,
                            novemberButton,
                            decemberButton,
                            ]
//        if self.arrayMonthsHelpNeeded != nil {
////            for month in monthsNeedHelp?.count {
////                
////            }
//            
//            
//            
//        }
        
    }
}
