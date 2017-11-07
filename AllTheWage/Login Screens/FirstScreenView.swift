//
//  FirstScreenView.swift
//  AllTheWage
//
//  Description: First view which will allow the user to
//  select between Employer or Employee Account
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase


class FirstScreenView: UIViewController {

    // DESCRIPTION:
    // Called when the view loads up but before the view is displayed
    // We will do all of our set up here
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DESCRIPTION:
        // do try catch block to catch any errors in case we are not able to sign out a user
        do{
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            print("COULD NOT SIGN OUT")
            print(error.localizedDescription)
        }
        
        // DESCRIPTION:
        // clearing the employee names arrat to make sure that we don't have an
        // overlap in employee if different companies login to the same devicce
        employeeNames.removeAll(keepingCapacity: true)
        
        
       
    }

    @IBAction func ClickedEmployer(_ sender: Any) {
        // DESCRIPTION:
        // segue to Employer Login Screen
        self.performSegue(withIdentifier: "EmployerToLogin", sender: Any?.self)
        
    }
    
    
    // DESCRIPTION:
    // This function is here simply to allow us to properly exit
    // child views without messing up the navigation of the application
    @IBAction func cancelOption(unwindSegue: UIStoryboardSegue) {
        //supposed to be a null function, unless we want to do something custom but for now we are fine
    }

    

}
