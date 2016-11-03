//
//  HostsTableViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase

class HostsTableViewController: UITableViewController {
    
    var selectedHostUID:String?
    var selectedHostProfile:Profile?
    var searchCountryString:String?
    var hosts:[Profile] = []
    var hostUIDS:[String] = []
    var hostImages:[UIImage] = []
    var selectedIndex:IndexPath?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getHostsFromCountry(country: searchCountryString)

    }
    
    func getHostsFromCountry(country:String?) {
        let country = searchCountryString
        let ref = FIRDatabase.database().reference().child("data/users/hosts/")
        ref.queryOrdered(byChild: "userLocation").queryEqual(toValue: country).observe(.value, with: { (snapshot) in
            
            if (snapshot.value is NSNull) {
                let alert = UIAlertController(title: "oh No! :(",
                                              message: "There are no hosts in that country yet!",
                                              preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(defaultAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            else {
                for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
                    let hostUID = child.key
                    self.hostUIDS.append(hostUID)
                    if let value = child.value as? [String: Any] {
                        if (value["profileImageUrl"] != nil) {
                            let profile = Profile.init(isHost: true, displayName: value["displayName"] as! String,countriesVisiting: value["countriesVisiting"] as! String, userDescription: value["userDescription"] as! String, languagesSpoken: value["langsSpoken"] as! String, tagline: value["tagline"] as! String, dateOfBirth: value["DOB"] as! String, profilePhotoURL: value["profileImageUrl"] as! String, datesHelpNeeded: value["monthsHelpNeeded"] as! String, location: value["userLocation"] as! String)
                            
                            self.hosts.append(profile)
                        }
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
            
        }, withCancel: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.hosts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: hostTableViewCellIdentifier, for: indexPath) as! HostTableViewCell
        
        cell.configureWithHostProfile(profile: self.hosts[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.performSegue(withIdentifier: segueShowProfileForeSelectedHost, sender: self)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == segueShowProfileForeSelectedHost {
            let destinationVC = segue.destination as! PublicHostProfileViewController
            if let row = selectedIndex?.row {
                destinationVC.uid = hostUIDS[row]
                destinationVC.profile = self.hosts[row]
            }
            
        }

    }
    

}
