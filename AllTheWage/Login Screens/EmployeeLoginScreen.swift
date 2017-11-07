//
//  EmployeeLoginScreen.swift
//  AllTheWage
//
//  Description: Login Screen for Employee
//
//  Created by Andres Ibarra on 10/30/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase


class EmployeeLoginScreen: UIViewController, UITextFieldDelegate  {
    
    
    var ref = Database.database().reference() // DATABASE REF TO ALLOW US TO ACCESS IT
    
    // DESCRIPTION:
    // ALERT VARIABLES
    // this will allow us to display an alert when something goes wrong and can't log in
    let alert = UIAlertController(title: "Error", message: "Could Not login, Email or Password could not be found", preferredStyle: UIAlertControllerStyle.alert)
    var clickedAlertMessege = false
    var loginIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    // DESCRIPTION:
    // TEXTFIELDS VARIABLES
    // these are the textfields that appear and this is where we can grab the information
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    
    // DESCRIPTION:
    // CHECKER VARIABLES
    // these are the variables that will contain the read in information from the textfields
    var emailchecker: String!
    var passchecker: String!

    // DESCRIPTION:
    // Called when the view loads up but before the view is displayed
    // We will do all of our set up here
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PasswordTextField.delegate = self //delegating the textfields to allow the
                                               //implementation of func textFieldShouldReturn()
    }
    
    // DESCRIPTION:
    // Called when the editing is done on a textfield
    // and the return button is clicked to remove the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    // DESCRIPTION:
    // User has entered in his/her information and we will now
    // attempt to login user
    @IBAction func pressedLogin(_ sender: Any) {
        
        // DESCRIPTION:
        // show the loginindicator so that user doesn't think the application froze
        loginIndicator.center = self.view.center
        loginIndicator.hidesWhenStopped = true
        loginIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(loginIndicator)
        loginIndicator.startAnimating()
        
        //Getting the information from the textfields that the user inputted
        emailchecker = EmailTextField.text
        passchecker = PasswordTextField.text
        
        // DESCRIPTION:
        // Called to sign in the user to Firebase Auth
        // will also handle in case user cannot be logged in
        Auth.auth().signIn(withEmail: emailchecker, password: passchecker){ (user, error) in
            if error == nil {
                //perform segue
                self.loginIndicator.stopAnimating() //stopping it to move into the next view
                self.performSegue(withIdentifier: "logedIn", sender: nil)
            } else{
                print("cannot sign in user")
                if !self.clickedAlertMessege {
                    self.alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default))
                }
                self.present(self.alert, animated: true, completion: nil)
                self.clickedAlertMessege = true
                
                self.loginIndicator.stopAnimating() //stopping it show user we are no longer loading
            }
            
        }
        
        
    }
    
    // DESCRIPTION:
    // This function is here simply to allow us to properly segue to another view
    @IBAction func clickedSignUp(_ sender: Any) {
        performSegue(withIdentifier: "employeeSignUp", sender: nil)
        
    }
    
    
    
    // DESCRIPTION:
    // This function is here simply to allow us to properly exit
    // child views without messing up the navigation of the application
    @IBAction func cancelSignup(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    
    
    
}
