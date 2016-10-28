//
//  TravelerDashboardViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase

class TravelerDashboardViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    var hosts:[Profile] = []
    let uid = FIRAuth.auth()?.currentUser?.uid
    var snapShotDictionary = [String : Any]()
    var hostImage: UIImage?
    
    
    //MARK : Properties
    
    var profile: Profile!
    
    //MARK : Outlets for TableView Stuff
    
    @IBOutlet var hostsAvailableTableView: UITableView!
    
    
    @IBOutlet var profileImageView: UIImageView!
    
    
    
    // MARK: UITableView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hosts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hostCell", for: indexPath) as! HostTableViewCell
        let host = hosts[indexPath.row]
        cell.taglineLabel.text = host.tagline
        cell.descriptionTextView.text = host.userDescription
        cell.hostProfilePhotoImageView.image = self.hostImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostsAvailableTableView.delegate = self
        hostsAvailableTableView.dataSource = self
        
        checkIfUserIsLoggedIn()
        fetchHosts()
        
    }
    
    
    private func checkIfUserIsLoggedIn () {
        
        if (uid == nil) {
            print("not logged in")
            return
        }
        
        FIRDatabase.database().reference().child("data/users/").child(uid!).observeSingleEvent(of: .value, with : { (Snapshot) in
            
            if let snapDict = Snapshot.value as? [String : AnyObject] {
                
                if let profile = snapDict["profile"] as? [String : AnyObject] {
                    
                    self.profile = Profile(isHost: snapDict["isHost"] as! Bool, displayName: profile["displayName"] as! String, countriesVisiting: "none", userDescription: profile["userDescription"] as! String, languagesSpoken: profile["langsSpoken"] as! String, tagline: profile["tagline"] as! String, dateOfBirth: profile["DOB"] as! String, profilePhotoURL: profile["profileImageUrl"] as! String, datesHelpNeeded: profile["monthsHelpNeeded"] as! String, location: profile["userLocation"] as! String)
                    
                    if (self.profile.profilePhotoURL != "" || self.profile.profilePhotoURL != nil) {
                        
                        self.loadUserDataFromDatabase(withURL: self.profile.profilePhotoURL!)
                        
                    }
                        
                    else {
                        return
                    }
                }
                
            }
        })
        
    }
    
    private func loadUserDataFromDatabase(withURL:String!) {
        if let profileImageURL = withURL {
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
    
    
    private func loadHostsPhotoFromDatabase(fromProfiles: [Profile]) {
        for aProfile in fromProfiles {
        if let profileImageURL = aProfile.profilePhotoURL {
            let url = NSURL(string: profileImageURL)
            URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                    self.hostImage = UIImage(data: data!)
                    self.hostsAvailableTableView.reloadData()
                
                }).resume()
            }
        }
        
    }
    
    private func fetchHosts () {
        
        FIRDatabase.database().reference().child("data/users/hosts/").observeSingleEvent(of: .value, with: {
            (snapshot) in
            //            if let snapShotDictionary = snapshot.value as? [String : AnyObject] {
            
            if (snapshot.value == nil) {
                print("nothing found")
            }
                
            else {
                guard let userProfile = snapshot.value else {
                    print("this user has no profile")
                    return
                }
                
                
                for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
                    if let value = child.value as? [String: Any] {
                        
                        let profile = Profile.init(isHost: true, displayName: value["displayName"] as! String, countriesVisiting: value["countriesVisiting"] as! String, userDescription: value["userDescription"] as! String, languagesSpoken: value["langsSpoken"] as! String, tagline: value["tagline"] as! String, dateOfBirth: value["DOB"] as! String, profilePhotoURL: value["profileImageUrl"] as! String, datesHelpNeeded: value["monthsHelpNeeded"] as! String, location: value["userLocation"] as! String)
                        
                        self.hosts.append(profile)
                        
                    }
                    
                    
                }
                
                self.loadHostsPhotoFromDatabase(fromProfiles: self.hosts)
                
                self.hostsAvailableTableView.reloadData()
                
            }
            
        })
        
        
    }
}
