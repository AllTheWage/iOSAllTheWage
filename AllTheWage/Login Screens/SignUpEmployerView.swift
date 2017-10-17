//
//  SignUpEmployerView.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/16/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase

class SignUpEmployerView: UIViewController, UITextFieldDelegate {
    
    //ALERT VARIABLE FOR WHEN LOGIN IS NOT VALID
    let passwordsDontMatch = UIAlertController(title: "Error", message: "Could Not Signup, Passwords Must match", preferredStyle: UIAlertControllerStyle.alert)
    var clickedAlertMessege = false
    
    //VARIABLES FOR WHEN GRABBING USER DATA
    var signupemail: String!
    var signuppassword: String!
    var passwordconfirm: String!
    var companyname: String!
 
    //CONNECTIONS TO THE UI TO HELP IN GETTING USER DATA
    @IBOutlet var CompanyName: UITextField!
    @IBOutlet var SignUpEmailTextField: UITextField!
    @IBOutlet var SignUpPasswordTextField: UITextField!
    @IBOutlet var ConfirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //allowing so we can hide keyboard after we finish filling in the last field
         self.ConfirmPasswordTextField.delegate = self
        self.SignUpPasswordTextField.delegate = self
        self.SignUpEmailTextField.delegate = self
        self.CompanyName.delegate = self
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //USER SHOULD HAVE ENTERED ALL INFORMATION AND HAS NOW TRIED TO SIGN UP
    @IBAction func SignUpButtonPressed(_ sender: Any){

        //assigning each variable with the information passed
        companyname = CompanyName.text
        signupemail = SignUpEmailTextField.text
        signuppassword = SignUpPasswordTextField.text
        passwordconfirm = ConfirmPasswordTextField.text

        if signuppassword == passwordconfirm {
            //still need to check in case account is already made
            
            //creating a new user
            Auth.auth().createUser(withEmail: signupemail, password: signuppassword, completion: nil)
        } else{
            //show alert
            if !clickedAlertMessege {
                passwordsDontMatch.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default))
            }
            self.present(passwordsDontMatch, animated: true, completion: nil)
            clickedAlertMessege = true

        }

    }




    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
