//
//  AddNewEmployeeView.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/19/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase

class AddNewEmployeeView: UIViewController {

    
    var ref = Database.database().reference()
    @IBOutlet var EmailTextField: UITextField!
   
    
    @IBAction func ClickedAddEmployee(_ sender: UIButton) {
        //send email to employee to set up email
        performSegue(withIdentifier: "AddedEmployee", sender: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
