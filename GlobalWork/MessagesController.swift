//
//  MessagesController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-11-01.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    

    var profile: Profile?
    
    var messagesArray = [Message]()
    var messagesDicitonary = [String : Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
       // observeMessages()
        
        observeUserMessages()
        
    }

    private func observeUserMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        messagesArray.removeAll()
        messagesDicitonary.removeAll()
        
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesReference = FIRDatabase.database().reference().child("messages").child(messageId)
            
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                
                if let dictionaryOfMessages = snapshot.value as? [String : AnyObject] {
                    let message = Message()
                    message.setValuesForKeys(dictionaryOfMessages)
                    
                    //self.messagesArray.append(message)
                    if let chatPartnerId = message.chatPartnerId() {
                        self.messagesDicitonary[chatPartnerId] = message
                        self.messagesArray = Array(self.messagesDicitonary.values)
                        self.messagesArray.sort(by: { (m1, m2) -> Bool in
                            
                            
                            
                            return (m1.timeStamp?.intValue)! > (m2.timeStamp?.intValue)!
                            
                        })
                    }
                    
                    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                   
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
    func handleReloadTable() {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.messagesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        let message = messagesArray[indexPath.row]
        cell.message = message
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messagesArray[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("data/users/").child("hosts/").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String : AnyObject] else {
                return
            }
            let profile = Profile(isHost: true, displayName: dictionary["displayName"] as! String, countriesVisiting: "none", userDescription: dictionary["userDescription"] as! String, languagesSpoken: dictionary["langsSpoken"] as! String, tagline: dictionary["tagline"] as! String, dateOfBirth: dictionary["DOB"] as! String, profilePhotoURL: dictionary["profileImageUrl"] as! String, datesHelpNeeded: dictionary["monthsHelpNeeded"] as! String, location: dictionary["userLocation"] as! String)
            self.showChatControllerWithUser(user: profile, andUserId: chatPartnerId)
            
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func showChatControllerWithUser(user: Profile, andUserId:String) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        self.present(chatLogController, animated: true, completion: nil)
        chatLogController.profile = user
        chatLogController.toId = andUserId
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    
}
