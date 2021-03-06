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
    @IBOutlet var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualsSetup()

    }


    @IBAction func clickedLogin(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "tabView")
        self.present(vc!, animated: true, completion: nil)
       
    }
    
    
    @IBAction func unwindToLogin(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    
    func visualsSetup(){
        emailTextField.layer.cornerRadius = 20.0
        emailTextField.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5432093801, blue: 0.4196078431, alpha: 1)
        passwordTextField.layer.cornerRadius = 20.0
        passwordTextField.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5432093801, blue: 0.4196078431, alpha: 1)
        loginButton.layer.cornerRadius = 20.0
        loginButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5432093801, blue: 0.4196078431, alpha: 1)
        signUpButton.layer.cornerRadius = 20.0
        signUpButton.layer.backgroundColor = #colorLiteral(red: 0, green: 0.5432093801, blue: 0.4196078431, alpha: 1)
    }
    
}
