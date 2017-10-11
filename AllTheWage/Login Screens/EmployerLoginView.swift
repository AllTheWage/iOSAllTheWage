//
//  EmployerLoginView.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit




class EmployerLoginView: UIViewController, UITextFieldDelegate  {
    
    let alert = UIAlertController(title: "Error", message: "Could Not login, Email or Password could not be found", preferredStyle: UIAlertControllerStyle.alert)
    var clickedAlertMessege = false
    var loginIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet var EmailTextFieldInformation: UITextField!
    @IBOutlet var PasswordTextFieldInformation: UITextField!
    var sampleEmail = "andibarram@gmail.com"
    var samplePassword = "andres1996"
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
        
        if sampleEmail == emailchecker {
            if samplePassword == passchecker{
                 loginIndicator.stopAnimating() //stopping it to move into the next view
                performSegue(withIdentifier: "logedIn", sender: UIButton())
                
                
            }
            else{
                loginIndicator.stopAnimating()
                if !clickedAlertMessege{
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default))
                }
                
                self.present(alert, animated: true, completion: nil)
                clickedAlertMessege = true
            }
        } else{
            loginIndicator.stopAnimating()
            
            if !clickedAlertMessege {
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default))
            }
            self.present(alert, animated: true, completion: nil)
             clickedAlertMessege = true
        }
        
        
    }
  

}
