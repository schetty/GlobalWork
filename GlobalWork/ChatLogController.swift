
//
//  ChatLogController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-31.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UINavigationBarDelegate {
    
    var profile: Profile? {
    didSet {
    navigationItem.title = profile!.displayName
        }
    }
    var toId:String!
    let currentUserId = FIRAuth.auth()?.currentUser?.uid
    
    let messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message ..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate? = self as! UITextFieldDelegate
        return textField
        
    }()
    
    let cellId = "cellId"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Chat"
        collectionView?.backgroundColor = UIColor.white

        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        setupInputComponents()

    }

    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.hummingBird()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.tintColor = UIColor.dullCyan()
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        
        containerView.addSubview(messageTextField)
        messageTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        messageTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        messageTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        messageTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.gray
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }

    func handleSend () {
        
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = self.toId
        let fromId = self.currentUserId
        let timestamp = (Date().timeIntervalSince1970) as NSNumber
        let values = ["text": messageTextField.text!, "toId": toId!, "fromId": fromId!, "timeStamp": timestamp] as [String : Any]
        //childRef.updateChildValues(values)
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId!)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId : 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId!)
            recipientUserMessagesRef.updateChildValues([messageId : 1])
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    // MARK : Table View
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = UIColor.blue
        return cell
    }
}
