//
//  TravelerDashboardViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase

class TravelerDashboardViewController: UIViewController,  UITableViewDelegate {

    let hosts:[User] = []
    let uid = FIRAuth.auth()?.currentUser?.uid
    var snapShotDictionary = [String : Any]()
    var labelText = String()
    var descText = String()

    
    
    //MARK : Properties
    
    var profile: Profile!
    
    //MARK : Outlets for TableView Stuff
    
    @IBOutlet var hostsAvailableTableView: UITableView!
    
    
    @IBOutlet var profileImageView: UIImageView!
    
    
    
    // MARK: UITableView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hosts.count
    }
    
    @nonobjc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hostCell", for: indexPath) as! HostTableViewCell
        cell.taglineLabel.text = self.labelText
        cell.descriptionTextView.text = self.descText
        cell.hostProfilePhotoImageView.image = nil
        return cell
        
    }
    
    @objc(tableView:canFocusRowAtIndexPath:) func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //        if editingStyle == .delete {
        //            items.remove(at: indexPath.row)
        //            tableView.reloadData()
        //        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        //        var groceryItem = items[indexPath.row]
        //        let toggledCompletion = !groceryItem.completed
        //
        //        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        //        groceryItem.completed = toggledCompletion
        //        tableView.reloadData()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                }
          
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
    
    private func fetchHosts () {
        
        let hostsArray = [Profile]()
        
        FIRDatabase.database().reference().child("data/users/").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapShotDictionary = snapshot.value as? [String : AnyObject] {
            
            if (snapshot.value is NSNull) {
                print("nothing found")
            }
            else {
                for (myKey, myObject) in snapShotDictionary {
                    let myKeys = myObject.allKeys
                    let myProfile = myObject["profile"] as! [String : Any]
                    
                    self.labelText = myProfile["tagline"] as! String
                    
                    self.descText = myProfile["userDescription"] as! String
           
                }
            
//            }
           
        }

    }
        })
        
//                
//                    if let profile = snapAllUsers["profile"] as? [String : AnyObject] {
        //
        //                        var aHost:  = Profile(isHost: snapDict["isHost"] as! Bool, displayName: profile["displayName"] as! String, countriesVisiting: "none", userDescription: profile["userDescription"] as! String, languagesSpoken: profile["langsSpoken"] as! String, tagline: profile["tagline"] as! String, dateOfBirth: profile["DOB"] as! String, profilePhotoURL: profile["profileImageUrl"] as! String, datesHelpNeeded: profile["monthsHelpNeeded"] as! String, location: profile["userLocation"] as! String)
        //                }
        //
        //            }
        //        })
        
        
            
        
    }
}
