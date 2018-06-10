//
//  SignUpView.swift
//  AllTheWagev2
//
//  Created by Andres Ibarra on 6/8/18.
//  Copyright © 2018 andiba. All rights reserved.
//

import UIKit

class SignUpView: UIViewController {

    @IBOutlet var companyNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualsSetup()
    }


    func visualsSetup(){
        companyNameTextField.layer.cornerRadius = 25.0
        companyNameTextField.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5432093801, blue: 0.4196078431, alpha: 1)
        emailTextField.layer.cornerRadius = 25.0
        emailTextField.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5432093801, blue: 0.4196078431, alpha: 1)
        passwordTextField.layer.cornerRadius = 25.0
        passwordTextField.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5432093801, blue: 0.4196078431, alpha: 1)
        confirmPasswordTextField.layer.cornerRadius = 25.0
        confirmPasswordTextField.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5432093801, blue: 0.4196078431, alpha: 1)
        signUpButton.layer.cornerRadius = 20.0
        signUpButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5432093801, blue: 0.4196078431, alpha: 1)
    }
    


}



