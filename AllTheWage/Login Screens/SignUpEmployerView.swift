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
    
    //DATABASE
    var ref = Database.database().reference()
    
    //ALERT VARIABLE FOR WHEN LOGIN IS SUCCESSFUL
    let loginSuccessful = UIAlertController(title: "Signed Up", message: "Sign Up Successful, Now Login with Your New Account!", preferredStyle: UIAlertControllerStyle.alert)
    var sucessfulLoginbool = false
    
    //ALERT VARIABLE FOR WHEN SIGNUP WAS NOT POSSIBLE
    let couldNotSignUp = UIAlertController(title: "Error", message: "Could Not Signup, Make sure password is at least 6 characters and Email is Valid!", preferredStyle: UIAlertControllerStyle.alert)
    var clickedCouldNotSignUpAlert = false
    
    
    //ALERT VARIABLE FOR WHEN LOGIN IS NOT VALID
    let passwordsDontMatch = UIAlertController(title: "Error", message: "Could Not Signup, Passwords Must match", preferredStyle: UIAlertControllerStyle.alert)
    var clickedAlertMessege = false
    var ableToLoginAfterSignup = false
    
    
    
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
            //creating a new user
            Auth.auth().createUser(withEmail: signupemail, password: signuppassword){(user, error) in
                if error == nil{
                    //SignUp Sucessful
                    if !self.sucessfulLoginbool {
                        self.loginSuccessful.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
                    }
                    self.present(self.loginSuccessful, animated: true, completion: nil)
                    self.sucessfulLoginbool = true
                    
                    //SIGNING IN USER AND ADDING COMPANY NAME TO DATABASE
                    Auth.auth().signIn(withEmail: self.signupemail, password: self.signuppassword, completion: { (user, error) in
                        if error == nil {
                            //success
                            //setting all the needed fields for the application to start up correctly after a sign up
                            self.ref.child("EMPLOYERS").child("Companies").child(user!.uid).child(self.companyname).child("eID").child("Name").setValue("")
                            self.ref.child("EMPLOYERS").child("Companies").child(user!.uid).child(self.companyname).child("eID").child("Email").setValue("")
                            self.ref.child("EMPLOYERS").child("Companies").child(user!.uid).child(self.companyname).child("eID").child("Phone Number").setValue("")
                            self.ref.child("EMPLOYERS").child("Companies").child(user!.uid).child(self.companyname).child("eID").child("Age").setValue(0)
                            self.ref.child("EMPLOYERS").child("Companies").child(user!.uid).child(self.companyname).child("eID").child("Social Security").setValue("")
                            
                            
                            self.ableToLoginAfterSignup = true
                        }
                        else{
                            print("could not sign in user")
                        }
                    })
                   

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
            }//end of create user func
        }//end of if passwords don't match
        else{
            //show alert because passwords don't match
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
