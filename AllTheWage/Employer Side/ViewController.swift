//
//  ViewController.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    //DATABASE REFERENCE
    var ref = Database.database().reference()
    
    @IBOutlet var WelcomeMessege: UILabel!
    
    @IBOutlet var EmployerNameTextField: UILabel!
    @IBOutlet var Open: UIBarButtonItem!
    @IBOutlet var RequestsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.hidesBackButton = true
        
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //GETTING NAME TO DISPLAY WELCOME MESSAGE
        ref.child("EMPLOYERS").child("Company Name").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with:{ (snapshot) in
            let name = snapshot.value as? String
            print("Welcome, " + name!)
            self.WelcomeMessege.text = "Welcome, " + name!
            
        })
       
        
        //adding rounded corners to the table view that handles all the requests in the main page
        RequestsTableView.layer.cornerRadius = 15
        RequestsTableView.layer.masksToBounds = true
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

