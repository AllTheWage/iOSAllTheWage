//
//  AddNewEmployeeView.swift
//  AllTheWage
//
//  Description: This will allow the employer
//                  to add an employee by sending an email
//
//  Created by Andres Ibarra on 10/19/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase

class AddNewEmployeeView: UIViewController {

    
    var ref = Database.database().reference() // DATABASE REF TO ALLOW US TO ACCESS IT
    
    
    // DESCRIPTION:
    // Email text field to know the employee email address that you
    // need to send the email too
    @IBOutlet var EmailTextField: UITextField!
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    

}
