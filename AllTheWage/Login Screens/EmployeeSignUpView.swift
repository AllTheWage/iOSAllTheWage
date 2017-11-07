//
//  EmployeeSignUpView.swift
//  AllTheWage
//
//  Description: Sign Up Screen for Employee
//
//  Created by Andres Ibarra on 10/30/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase


class EmployeeSignUpView: UIViewController ,UITextFieldDelegate {

    
    var ref = Database.database().reference() // DATABASE REF TO ALLOW US TO ACCESS IT
   
    // DESCRIPTION:
    // login activity view so user doesn't think the program chrashed
    var loadingIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
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
    // TEXTFIELDS VARIABLES
    // these are the textfields that appear and this is where we can grab the information
    @IBOutlet var NameTextField: UITextField!
    @IBOutlet var AgeTextField: UITextField!
    @IBOutlet var PhoneNumberTextField: UITextField!
    @IBOutlet var EmployerNameTextField: UITextField!
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    @IBOutlet var ConfirmPasswordTextField: UITextField!
    
    // DESCRIPTION:
    // CHECKER VARIABLES
    // these are the variables that will contain the read in information from the textfields
    var name: String!
    var age: String!
    var phoneNumber: String!
    var employerName: String!
    var Email: String!
    var employerID: String!
    var password: String!
    var ConfirmedPassword: String!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // DESCRIPTION
        // delegating the textfields to allow the
        // implementation of func textFieldShouldReturn()
        self.ConfirmPasswordTextField.delegate = self
        self.PasswordTextField.delegate = self
        self.EmailTextField.delegate = self
        self.EmployerNameTextField.delegate = self
        self.PhoneNumberTextField.delegate = self
        self.AgeTextField.delegate = self
        self.NameTextField.delegate = self
        
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
    @IBAction func clickedSignUp(_ sender: Any) {
        
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        
        // DESCRIPTION:
        // assigning each variable with the information passed
        name = NameTextField.text
        age = AgeTextField.text
        phoneNumber = PhoneNumberTextField.text
        employerName = EmployerNameTextField.text
        Email = EmailTextField.text
        password = PasswordTextField.text
        ConfirmedPassword = ConfirmPasswordTextField.text
        
        
        // DESCRIPTION:
        // MAKING SURE PASSWORDS MATCH
        if password == ConfirmedPassword {
            
           //Create a new user
            Auth.auth().createUser(withEmail: Email, password: password){(user, error) in
                if error == nil
                {
                    //SignUp Sucessful
                    self.loadingIndicator.stopAnimating()
                    
                    //making sure we havent already diplayed this message before so that we don't add extra buttons we don't need
                    if !self.sucessfulLoginbool
                    {
                        self.loginSuccessful.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
                    }
                    self.present(self.loginSuccessful, animated: true, completion: nil)
                    self.sucessfulLoginbool = true //we were able to sign up
                    
                    // DESCRIPTION:
                    // We will now sign in the user after a sucessful set up and
                    // set up their database section
                    // SIGNING IN USER AND ADDING INFORMATION TO DATABASE
                    Auth.auth().signIn(withEmail: self.Email, password: self.password, completion: { (user, error) in
                        if error == nil {
                            // Successful Login
                            // setting all the needed fields for the application to start up correctly after a sign up
                            // these values will be modified later on
                            
                            //SETTING UP EMPLOYEE SIDE
                            self.ref.child("EMPLOYEES").child(String(self.employerName)).child(user!.uid).child("Paycheck Amount").setValue(2000)
                            self.ref.child("EMPLOYEES").child(String(self.employerName)).child(user!.uid).child("Name").setValue(self.name)
                            self.ref.child("EMPLOYEES").child(String(self.employerName)).child(user!.uid).child("Hours Worked").setValue(0)
                            self.ref.child("EMPLOYEES").child(String(self.employerName)).child(user!.uid).child("Pay Rate").setValue("H10")
                            
                            //ADDING EMPLOYEE TO EMPLOYER SIDE
                            self.ref.child("EMPLOYERS").child("Companies").observeSingleEvent(of: .value, with: {(snapshot) in
                                let employerIDs = snapshot.children.allObjects as! [DataSnapshot]
                                var indexer = 0
                                    for child in employerIDs {
                                        let childCompanyName = child.children.allObjects as! [DataSnapshot]
                                        if childCompanyName[0].key == self.employerName{
                                            self.employerID = employerIDs[indexer].key
                                            break
                                        }
                                        indexer+=1
                                    }
                               self.ref.child("EMPLOYEES").child(String(self.employerName)).child(user!.uid).child("EmployerID").setValue(self.employerID)
                                
                           
                               
                                 //INSERTING NAME, PHONE NUMBER, AGE, EMAIL, FAKE SOCIAL SECURITY FOR NOW
                                 //NAME
                                 self.ref.child("EMPLOYERS").child("Companies").child(self.employerID).child(self.employerName).child(user!.uid).child("Name").setValue(self.name)
                                 
                                 //AGE
                                 self.ref.child("EMPLOYERS").child("Companies").child(self.employerID).child(self.employerName).child(user!.uid).child("Age").setValue(Int(self.age))
                                 //EMAIL
                                 self.ref.child("EMPLOYERS").child("Companies").child(self.employerID).child(self.employerName).child(user!.uid).child("Email").setValue(self.Email)
                                 //Phone Number
                                 self.ref.child("EMPLOYERS").child("Companies").child(self.employerID).child(self.employerName).child(user!.uid).child("Phone Number").setValue(self.phoneNumber)
                                 //AGE
                                 self.ref.child("EMPLOYERS").child("Companies").child(self.employerID).child(self.employerName).child(user!.uid).child("Social Secuiry").setValue("***-**-1111")
                      
                                
                            })//end of observeSingleEvent
                            
                            
                            self.ableToLoginAfterSignup = true
                        }
                        else{
                            print("could not sign in user")
                        }
                    })//end of login In Method
                    
                } //end of if error == nil
                else{
                    self.loadingIndicator.stopAnimating()
                    //show alert because something went wrong
                    if !self.clickedCouldNotSignUpAlert {
                        self.couldNotSignUp.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default))
                    }
                    self.present(self.couldNotSignUp, animated: true, completion: nil)
                    self.clickedCouldNotSignUpAlert = true
                    return
                }//end of if error != null
            }   //end of signup method
        } else {
            //show alert because passwords don't match
            loadingIndicator.stopAnimating()
            if !clickedAlertMessege {
                passwordsDontMatch.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default))
            }
            self.present(passwordsDontMatch, animated: true, completion: nil)
            clickedAlertMessege = true
            
        } //END OF ELSE IF PASSWORDS DON'T MATCH
        if ableToLoginAfterSignup{
            loadingIndicator.stopAnimating()
            
        }
    }
    

    
    
    
    
    
    
}
