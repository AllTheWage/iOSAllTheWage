//
//  EmployeeLoginScreen.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/30/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase


class EmployeeLoginScreen: UIViewController, UITextFieldDelegate  {
    
    //DATABASE
    var ref = Database.database().reference()
    
    //ALERTS
    let alert = UIAlertController(title: "Error", message: "Could Not login, Email or Password could not be found", preferredStyle: UIAlertControllerStyle.alert)
    var clickedAlertMessege = false
    var loginIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    //TEXT FIELDS TO GET INFORMATION
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    
    //VARIABLES USED TO STORE LOG IN INFORMATION
    var emailchecker: String!
    var passchecker: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.PasswordTextField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    
    @IBAction func pressedLogin(_ sender: Any) {
        //show the loginindicator so that user doesn't think it froze
        loginIndicator.center = self.view.center
        loginIndicator.hidesWhenStopped = true
        loginIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(loginIndicator)
        
        loginIndicator.startAnimating()
        
        //Getting the information from the textfields that the user inputted
        emailchecker = EmailTextField.text
        passchecker = PasswordTextField.text
        
        Auth.auth().signIn(withEmail: emailchecker, password: passchecker){ (user, error) in
            if error == nil {
                self.loginIndicator.stopAnimating() //stopping it to move into the next view
                self.performSegue(withIdentifier: "logedIn", sender: nil)
            } else{
                print("cannot sign in user")
                if !self.clickedAlertMessege {
                    self.alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default))
                }
                self.present(self.alert, animated: true, completion: nil)
                self.clickedAlertMessege = true
                
                self.loginIndicator.stopAnimating() //stopping it to move into the next view
            }
            
        }
        
        
    }
    
}
