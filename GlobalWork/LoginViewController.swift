//
//  LoginViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-14.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase



class LoginViewController: UIViewController {
    
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBAction func didPressLogin(_ sender: UIButton) {
        
        if self.usernameTextField.text == "" || self.passwordTextField.text == "" {
            
            let alert = UIAlertController(title: "Oops!",
                                          message: "You left something blank",
                                          preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
            
        }
            
        else {
            
            FIRAuth.auth()?.signIn(withEmail: self.usernameTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                FIRAuth.auth()?.addStateDidChangeListener { auth, user in
                    if user != nil {
                        print(Thread.isMainThread)
                        
                        self.performSegue(withIdentifier: "showDashboard", sender: self)
                        
                        print("LOGGED IN YAY!")
                        
                    }
                    
                    if (error != nil) {
                        
                        print(error)
                        
                    } 
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if(FBSDKAccessToken.current() != nil) {
//            
//        }
//        let loginButton = FBSDKLoginButton()
//        loginButton.center = view.center
//        view.addSubview(loginButton)
    
    }


}
