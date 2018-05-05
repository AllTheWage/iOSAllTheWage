//
//  LoginScreen.swift
//  AllTheWagev2
//
//  Created by Andres Ibarra on 5/5/18.
//  Copyright © 2018 andiba. All rights reserved.
//

import UIKit

class LoginScreen: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var accountSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      emailTextField.layer.cornerRadius = 30.0
        passwordTextField.layer.cornerRadius = 30.0
        loginButton.layer.cornerRadius = 30.0
        
        accountSelector.layer.cornerRadius = 25.0
    }
}
