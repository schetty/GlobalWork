//
//  PublicTravelerProfileViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.

import UIKit
import Firebase

class PublicTravelerProfileViewController: UIViewController {
    
    var profile: Profile?
    private var monthsNeedHelpString:String?
    private var monthsNeedHelp:NSArray?
    
    // MARK: - OUTLETS & PROPERTIES for UI
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var taglineLabel: UILabel!
    @IBOutlet var languagesLabel: UILabel!
    @IBOutlet var countriesUserWillVisitLabel: UILabel!
    
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
        
        
        
        
    }
    
    
    func checkIfUserIsLoggedIn () {
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        if (uid == nil) {
            print("not logged in")
            return
        }
        
        FIRDatabase.database().reference().child("data/users/travelers/").child(uid!).observeSingleEvent(of: .value, with : { (Snapshot) in
            
            if let profile = Snapshot.value as? [String : AnyObject] {

                    
                    self.profile = Profile(isHost: true, displayName: profile["displayName"] as! String, countriesVisiting: profile["countriesVisiting"] as! String, userDescription: profile["userDescription"] as! String, languagesSpoken: profile["langsSpoken"] as! String, tagline: profile["tagline"] as! String, dateOfBirth: profile["DOB"] as! String, profilePhotoURL: profile["profileImageUrl"] as! String, datesHelpNeeded: profile["monthsHelpNeeded"] as! String, location: profile["userLocation"] as! String)
                    
                    self.displayNameLabel.text = self.profile?.displayName
                    self.locationLabel.text = self.profile?.location
                    self.countriesUserWillVisitLabel.text = "Countries I'll be visiting: " + (self.profile?.countriesVisiting ?? "")
                    self.taglineLabel.text = "'" + (self.profile?.tagline)! + "'"
                    self.languagesLabel.text = "Languages I speak:  " + (self.profile?.languagesSpoken)!
                    self.descriptionTextView.text = self.profile?.userDescription
                    self.monthsNeedHelpString = self.profile?.datesHelpNeeded
                    let dobStr = self.profile?.dateOfBirth
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    if let dob = dateFormatter.date(from: dobStr!) {
                        let calendar = Calendar.current
                        let ageComponents = calendar.dateComponents([.year], from: dob, to: Date()).year!
                        
                        self.ageLabel.text = "Age: \(ageComponents)"
                        
                        
                    }
                    
                    
                    self.loadUserDataFromDatabase()
                    
                    self.fillInMonthsNeedHelp()
                    
                }
            
            self.monthsNeedHelpString = self.profile?.datesHelpNeeded
            
            
        })
        
        
        
        
    }
    
    
    
    private func loadUserDataFromDatabase() {
        if let profileImageURL = profile?.profilePhotoURL {
            let url = NSURL(string: profileImageURL)
            URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async{
                    
                    self.profileImageView.image = UIImage(data: data!)
                    
                }
                
                
            }).resume()
        }
        
    }
    
    
    private func fillInMonthsNeedHelp() {
        let monthsNeedHelpArray = self.monthsNeedHelpString?.components(separatedBy: " ")
        
        print(monthsNeedHelpArray ?? "no months here")
        
        _ = try? monthsNeedHelpArray?.map({ (monthString) in
            if let month = Months(rawValue: monthString){
                let monthNumber = month.toInt()
                if let button = self.view.viewWithTag(monthNumber) as? SSRadioButton {
                    button.isSelected = true
                }
            }
        })
        
        
        
    }
    
}
