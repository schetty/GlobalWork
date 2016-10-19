//
//  SignUpViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-17.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController, SSRadioButtonControllerDelegate {
    
    //MARK: properties
    
    var radioButtonController: SSRadioButtonsController?
    
    var ref: FIRDatabaseReference!
    
    
    
    @IBOutlet var hostRadioButton: SSRadioButton!
    
    @IBOutlet var travelerRadioButton: SSRadioButton!
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    //MARK: SIGN UP AUTHORIZATION
    
    @IBAction func didPressSignUp(sender: UIButton) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            let alert = UIAlertController(title: "Oops!",
                                          message: "You left something blank",
                                          preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
            
        }
            
        else {
            
            if let email = emailTextField.text, let pass = passwordTextField.text {
                FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
                    if let error = error {
                        
                        print(error.localizedDescription)
                        
                    }
                        
                    else {
                        print("User signed in")
                        let currentButton = self.radioButtonController?.selectedButton()

                        self.didSelectButton(aButton: currentButton)
                        self.ref.child("data/users").updateChildValues(["\(FIRAuth.auth()!.currentUser!.uid)":["Username":self.usernameTextField.text!]])
                        
                    }
                })
                
            }
            
            self.performSegue(withIdentifier: "dashboard", sender: self)
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radioButtonController = SSRadioButtonsController(buttons: travelerRadioButton, hostRadioButton)
        
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        
        
        //MARK : DO THIS LATER set a logout button alpha to 1 if already logged in
        //if let user = FIRAuth.auth()?.currentUser
        
        
        ref = FIRDatabase.database().reference()
        
    }
    
     public func didSelectButton(aButton: UIButton?) {
        
        if (aButton == travelerRadioButton) {
            self.ref.child("data/users").setValue(["\(FIRAuth.auth()!.currentUser!.uid)":["isHost":false]])
        }
        
        else if (aButton == hostRadioButton) {
            self.ref.child("data/users").setValue(["\(FIRAuth.auth()!.currentUser!.uid)":["isHost":true]])
        }
            
        else {
            
            let alert = UIAlertController(title: "Oops!",
                                          message: "Please specify whether you're a traveler or a host",
                                          preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    
}
