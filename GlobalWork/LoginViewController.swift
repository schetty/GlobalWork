//
//  LoginViewController.swift
//  GlobalWork
//
//  Created by naomi schettini on 2016-10-14.
//  Copyright © 2016 naomi schettini. All rights reserved.
//

import UIKit
import FBSDKLoginKit



class LoginViewController: UIViewController {
    
    let navBar = UINavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()

        if(FBSDKAccessToken.current() != nil) {
            
        }
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
    
    }


}
