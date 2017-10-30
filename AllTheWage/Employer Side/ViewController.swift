//
//  ViewController.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//
import Foundation
import UIKit
import Firebase

class ViewController: UIViewController {
    
    //DATABASE REFERENCE
    var ref = Database.database().reference()
    var numOfEmployees = 0
    
    
    @IBOutlet var WelcomeMessege: UILabel!
    
    @IBOutlet var NumberOfEmployeesTextField: UILabel!
    @IBOutlet var EmployerNameTextField: UILabel!
    @IBOutlet var Open: UIBarButtonItem!
    @IBOutlet var RequestsTableView: UITableView!
    
    override func viewDidLoad() {
        var name: String!
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.hidesBackButton = true
        
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //GETTING NAME TO DISPLAY WELCOME MESSAGE
        ref.child("EMPLOYERS").child("Companies").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with:{ (snapshot) in
            //grabbing company name
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    name = child.key
                }
            }
            GlobalCompanyName = name
            print("Welcome, " + GlobalCompanyName)
            self.WelcomeMessege.text = "Welcome, " + GlobalCompanyName
            
        })

        ref.child("EMPLOYERS").child("Companies").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with:{ (snapshot) in
                let nextChild = snapshot.children.allObjects as! [DataSnapshot]

                self.numOfEmployees = Int(nextChild[0].childrenCount)
                self.NumberOfEmployeesTextField.text = "Number Of Employees: " + String(self.numOfEmployees)
            
     
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

