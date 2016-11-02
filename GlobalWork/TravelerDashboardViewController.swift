//
//  TravelerDashboardViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase
import PKHUD


class TravelerDashboardViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    var hosts:[Profile] = []
    var hostUIDS:[String] = []
    var hostImages:[UIImage] = []
    let uid = FIRAuth.auth()?.currentUser?.uid
    var snapShotDictionary = [String : Any]()
    var selectedIndex:IndexPath?
    
    
    //MARK : Properties
    
    var profile: Profile!
    
    //MARK : Outlets for TableView Stuff
    
    @IBOutlet var hostsAvailableTableView: UITableView!
    
    @IBOutlet var profileImageView: UIImageView!
    
    
    // MARK: UITableView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hosts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hostCell", for: indexPath) as! HostTableViewCell
        
        //        cell.profile = self.hosts[indexPath.row]
        
        cell.configureWithHostProfile(profile: self.hosts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.performSegue(withIdentifier: "showSelectedHost", sender: self)

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "showSelectedHost" {
            let destinationVC = segue.destination as! PublicHostProfileViewController
            if let row = selectedIndex?.row {
                destinationVC.uid = hostUIDS[row]
                destinationVC.profile = self.hosts[row]
                
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostsAvailableTableView.delegate = self
        hostsAvailableTableView.dataSource = self
        
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
        
        FIRDatabase.database().reference().child("data/users/travelers/").child(uid!).observeSingleEvent(of: .value, with : { (Snapshot) in
            
            if let snapDict = Snapshot.value as? [String : AnyObject] {
                
                self.profile = Profile(isHost: false, displayName: snapDict["displayName"] as! String, countriesVisiting: snapDict["countriesVisiting"] as! String, userDescription: snapDict["userDescription"] as! String, languagesSpoken: snapDict["langsSpoken"] as! String, tagline: snapDict["tagline"] as! String, dateOfBirth: snapDict["DOB"] as! String, profilePhotoURL: snapDict["profileImageUrl"] as! String, datesHelpNeeded: snapDict["monthsHelpNeeded"] as! String, location: snapDict["userLocation"] as! String)
                
                if (self.profile.profilePhotoURL != "" || self.profile.profilePhotoURL != nil) {
                    
                    self.loadUserDataFromDatabase(withURL: self.profile.profilePhotoURL!)
                    
                }
                
                
            }
            self.fetchHosts()
            
        })
        
    }
    
    
    func fetchHosts() {
        
        FIRDatabase.database().reference().child("data/users/hosts/").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if (snapshot.value == nil) {
                print("nothing found")
                return
            }
            
            HUD.flash(.progress, delay: 1.0) { finished in
                for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
                    let hostUID = child.key
                    self.hostUIDS.append(hostUID)
                    if let value = child.value as? [String: Any] {
                        
                        let profile = Profile.init(isHost: true, displayName: value["displayName"] as! String,countriesVisiting: value["countriesVisiting"] as! String, userDescription: value["userDescription"] as! String, languagesSpoken: value["langsSpoken"] as! String, tagline: value["tagline"] as! String, dateOfBirth: value["DOB"] as! String, profilePhotoURL: value["profileImageUrl"] as! String, datesHelpNeeded: value["monthsHelpNeeded"] as! String, location: value["userLocation"] as! String)
                        
                        self.hosts.append(profile)
                        

                        
                    }
                    
                }
                
                
                
                self.hostsAvailableTableView.reloadData()
                
            }
            
            
        })
        
        
    }
    
    
}
