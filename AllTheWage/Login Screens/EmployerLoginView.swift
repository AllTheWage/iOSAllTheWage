//
//  EmployerLoginView.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase


class EmployerLoginView: UIViewController, UITextFieldDelegate  {
    
    //DATABASE
    var ref = Database.database().reference()
    
    //ALERTS
    let alert = UIAlertController(title: "Error", message: "Could Not login, Email or Password could not be found", preferredStyle: UIAlertControllerStyle.alert)
    var clickedAlertMessege = false
    var loginIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    //TEXTFIELDS
    @IBOutlet var EmailTextFieldInformation: UITextField!
    @IBOutlet var PasswordTextFieldInformation: UITextField!
    
    //CHECKER VARIABLES
    var emailchecker: String!
    var passchecker: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PasswordTextFieldInformation.delegate = self;
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func ClickedLogin(_ sender: Any) {
        //show the loginindicator so that user doesn't think it froze
        loginIndicator.center = self.view.center
        loginIndicator.hidesWhenStopped = true
        loginIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(loginIndicator)
        
        loginIndicator.startAnimating()
        
        //Getting the information from the textfields that the user inputted
        emailchecker = EmailTextFieldInformation.text
        passchecker = PasswordTextFieldInformation.text
    
        Auth.auth().signIn(withEmail: emailchecker, password: passchecker){ (user, error) in
            if error == nil {
                    //preform segue
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
