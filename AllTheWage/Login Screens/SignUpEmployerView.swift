//
//  SignUpEmployerView.swift
//  AllTheWage
//
//  Description: Sign Up Screen for Employer
//
//  Created by Andres Ibarra on 10/16/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase

class SignUpEmployerView: UIViewController, UITextFieldDelegate {
    
    
    var ref = Database.database().reference() // DATABASE REF TO ALLOW US TO ACCESS IT
    
    
    // DESCRIPTION:
    // ALERT VARIABLE FOR WHEN LOGIN IS SUCCESSFUL
    let loginSuccessful = UIAlertController(title: "Signed Up", message: "Sign Up Successful, Now Login with Your New Account!", preferredStyle: UIAlertControllerStyle.alert)
    var sucessfulLoginbool = false
    
    // DESCRIPTION:
    // ALERT VARIABLE FOR WHEN SIGNUP WAS NOT POSSIBLE
    let couldNotSignUp = UIAlertController(title: "Error", message: "Could Not Signup, Make sure password is at least 6 characters and Email is Valid!", preferredStyle: UIAlertControllerStyle.alert)
    var clickedCouldNotSignUpAlert = false
    
    // DESCRIPTION:
    // ALERT VARIABLE FOR WHEN LOGIN IS NOT VALID
    let passwordsDontMatch = UIAlertController(title: "Error", message: "Could Not Signup, Passwords Must match", preferredStyle: UIAlertControllerStyle.alert)
    var clickedAlertMessege = false
    var ableToLoginAfterSignup = false
    
    
    // DESCRIPTION:
    // CHECKER VARIABLES
    // these are the variables that will contain the read in information from the textfields
    var signupemail: String!
    var signuppassword: String!
    var passwordconfirm: String!
    var companyname: String!
 
    // DESCRIPTION:
    // TEXTFIELDS VARIABLES
    // these are the textfields that appear and this is where we can grab the information
    @IBOutlet var CompanyName: UITextField!
    @IBOutlet var SignUpEmailTextField: UITextField!
    @IBOutlet var SignUpPasswordTextField: UITextField!
    @IBOutlet var ConfirmPasswordTextField: UITextField!
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // DESCRIPTION
        // delegating the textfields to allow the
        // implementation of func textFieldShouldReturn()
        self.ConfirmPasswordTextField.delegate = self
        self.SignUpPasswordTextField.delegate = self
        self.SignUpEmailTextField.delegate = self
        self.CompanyName.delegate = self
        
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
    // attempt to sign up user and set up their section in the database
    @IBAction func SignUpButtonPressed(_ sender: Any){
        // DESCRIPTION:
        // assigning each variable with the information passed
        companyname = CompanyName.text
        signupemail = SignUpEmailTextField.text
        signuppassword = SignUpPasswordTextField.text
        passwordconfirm = ConfirmPasswordTextField.text

        // DESCRIPTION:
        // MAKING SURE PASSWORDS MATCH
        if signuppassword == passwordconfirm {
            
            //Create a new user
            Auth.auth().createUser(withEmail: signupemail, password: signuppassword){(user, error) in
                if error == nil{
                    //SignUp Sucessful
                    if !self.sucessfulLoginbool {
                        self.loginSuccessful.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
                    }
                    self.present(self.loginSuccessful, animated: true, completion: nil)
                    self.sucessfulLoginbool = true  //we were able to sign up
                    
                    // DESCRIPTION:
                    // We will now sign in the user after a sucessful set up and
                    // set up their database section
                    // SIGNING IN USER AND ADDING INFORMATION TO DATABASE
                    Auth.auth().signIn(withEmail: self.signupemail, password: self.signuppassword, completion: { (user, error) in
                        if error == nil {
                            // Successful Login
                            // setting all the needed fields for the application to start up correctly after a sign up
                            // these values will be modified later on
                            self.ref.child("EMPLOYERS").child("Companies").child(user!.uid).child(self.companyname).child("eID").child("Name").setValue("")
                            self.ref.child("EMPLOYERS").child("Companies").child(user!.uid).child(self.companyname).child("eID").child("Email").setValue("")
                            self.ref.child("EMPLOYERS").child("Companies").child(user!.uid).child(self.companyname).child("eID").child("Phone Number").setValue("")
                            self.ref.child("EMPLOYERS").child("Companies").child(user!.uid).child(self.companyname).child("eID").child("Age").setValue("0")
                            self.ref.child("EMPLOYERS").child("Companies").child(user!.uid).child(self.companyname).child("eID").child("Social Security").setValue("")
                                self.ref.child("BANKS").child(user!.uid).child(self.companyname).child("Has Bank").setValue(0)
                            
                            self.ableToLoginAfterSignup = true
                        }
                        else{
                            print("could not sign in user")
                        }
                    })//end of login In Method
                    

                }//end of if error == nil
                else{
                    //show alert because something went wrong
                    if !self.clickedCouldNotSignUpAlert {
                        self.couldNotSignUp.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default))
                    }
                    self.present(self.couldNotSignUp, animated: true, completion: nil)
                    self.clickedCouldNotSignUpAlert = true
                    return
                }
                if self.ableToLoginAfterSignup{
                    self.performSegue(withIdentifier: "signedUP", sender: Any?.self)
                }
            }//END OF create user func
            
        }//END OF if passwords don't match
        else{
            //show alert because passwords don't match
            if !clickedAlertMessege {
                passwordsDontMatch.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default))
            }
            self.present(passwordsDontMatch, animated: true, completion: nil)
            clickedAlertMessege = true

        }   //END OF ELSE IF PASSWORDS DON'T MATCH
    }
    
    

}
