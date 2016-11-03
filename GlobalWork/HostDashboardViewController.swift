//
//  HostDashboardViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-14.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase
import PKHUD



class HostDashboardViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    var travelers:[Profile] = []
    var travelerUIDS:[String] = []
    var travelerImages:[UIImage] = []
    let uid = FIRAuth.auth()?.currentUser?.uid
    var snapShotDictionary = [String : Any]()
    var selectedIndex:IndexPath?
    
    
    //MARK : Properties
    
    var profile: Profile!
    
    //MARK : Outlets for TableView Stuff
    
    @IBOutlet var travelersAvailableTableView: UITableView!
    
    @IBOutlet var profileImageView: UIImageView!
    
    
    // MARK: UITableView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.travelers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "travelerCell", for: indexPath) as! TravelerTableViewCell
        
        //        cell.profile = self.travelers[indexPath.row]
        
        cell.configureWithTravelerProfile(profile: self.travelers[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.performSegue(withIdentifier: "showSelectedTraveler", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "showSelectedTraveler" {
            let destinationVC = segue.destination as! PublicTravelerProfileViewController
            if let row = selectedIndex?.row {
                destinationVC.uid = travelerUIDS[row]
                destinationVC.profile = self.travelers[row]
                
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        travelersAvailableTableView.delegate = self
        travelersAvailableTableView.dataSource = self
        
        self.profileImageView.layer.borderWidth = 1.0
        self.profileImageView.layer.masksToBounds = false
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.clipsToBounds = true
        
        
        checkIfUserIsLoggedIn()
        
        
    }
    
    
    private func loadUserDataFromDatabase(withURL:String!) {
        if let profileImageURL = withURL {
            let url = NSURL(string: profileImageURL)
            URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    
                    self.profileImageView.image = UIImage(data: data!)
                    
                }
                
                
            }).resume()
        }
        
    }
    
    
    
    
    private func checkIfUserIsLoggedIn () {
        
        if (uid == nil) {
            print("not logged in")
            return
        }
        
        FIRDatabase.database().reference().child("data/users/hosts/").child(uid!).observeSingleEvent(of: .value, with : { (Snapshot) in
            
            if let snapDict = Snapshot.value as? [String : AnyObject] {
                
                if snapDict["profileImageUrl"] != nil {
                    self.profile = Profile(isHost: false, displayName: snapDict["displayName"] as! String ?? "", countriesVisiting: snapDict["countriesVisiting"] as! String ?? "", userDescription: snapDict["userDescription"] as! String ?? "", languagesSpoken: snapDict["langsSpoken"] as! String ?? "", tagline: snapDict["tagline"] as! String ?? "", dateOfBirth: snapDict["DOB"] as! String ?? "", profilePhotoURL: snapDict["profileImageUrl"] as! String ?? "", datesHelpNeeded: snapDict["monthsHelpNeeded"] as! String ?? "", location: snapDict["userLocation"] as! String )
                    
                    if (self.profile?.profilePhotoURL == nil) {
                        return
                    }
                    else if (self.profile?.profilePhotoURL != "" || self.profile?.profilePhotoURL != nil) {
                        
                        self.loadUserDataFromDatabase(withURL: self.profile?.profilePhotoURL!)
                        
                    }
                    
                }
                
                
            }
            self.fetchTravelers()
            
        })
        
    }
    
    
    
    func fetchTravelers() {
        
        FIRDatabase.database().reference().child("data/users/travelers/").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if (snapshot.value == nil) {
                print("nothing found")
                return
            }
            
            HUD.flash(.progress, delay: 0.0) { finished in
                for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
                    let travelerUID = child.key
                    self.travelerUIDS.append(travelerUID)
                    if let value = child.value as? [String: Any] {
                        
                        let profile = Profile.init(isHost: false, displayName: value["displayName"] as? String ?? "", countriesVisiting: value["countriesVisiting"] as? String ?? "", userDescription: value["userDescription"] as? String ?? "", languagesSpoken: value["langsSpoken"] as? String ?? "", tagline: value["tagline"] as? String ?? "", dateOfBirth: value["DOB"] as? String ?? "", profilePhotoURL: value["profileImageUrl"] as? String ?? "", datesHelpNeeded: value["monthsHelpNeeded"] as? String ?? "", location: value["userLocation"] as? String ?? "")
                        
                        self.travelers.append(profile)
                        
                        
                    }
                    
                }
                
                
                
                self.travelersAvailableTableView.reloadData()
                
            }
            
            
        })
        
        
    }
    
    
}
