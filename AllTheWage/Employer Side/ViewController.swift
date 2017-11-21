//
//  ViewController.swift
//  AllTheWage
//
//  Description: This will main screen for the employer
//                  with the dashboard and all the requests
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//
import Foundation
import UIKit
import Firebase

class RequestCustomCell : UITableViewCell {
    
    @IBOutlet var cellEmployeeName: UILabel! = UILabel()
    @IBOutlet var cellRequestReason: UILabel! = UILabel()
    @IBOutlet var cellShift: UILabel!  = UILabel()
    @IBOutlet var cellDescription: UITextView!  = UITextView()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var requests = ["First Request", "Second Request", "Third Request"]
    
    
    var ref = Database.database().reference() // DATABASE REF TO ALLOW US TO ACCESS IT
    var numOfEmployees = 0  //to be displayed in Dashboard
    
    //CUSTOMIZED WELCOME MESSAGE LABEL
    @IBOutlet var WelcomeMessage: UILabel!
    
    @IBOutlet var NumberOfEmployeesTextField: UILabel!
    @IBOutlet var EmployerNameTextField: UILabel!
    @IBOutlet var Open: UIBarButtonItem!
    @IBOutlet var RequestsTableView: UITableView!
    
    override func viewDidLoad() {
        var name: String!
        
        super.viewDidLoad()
        
        RequestsTableView.register(RequestCustomCell.self, forCellReuseIdentifier: "CustomCell")
        self.RequestsTableView.delegate = self
        self.RequestsTableView.dataSource = self
        
        //HIDING BACK BUTTON SO THAT CUSTOM NAVIGATION BUTTON ISN'T COVERED
        navigationItem.hidesBackButton = true
        
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //GETTING NAME TO DISPLAY WELCOME MESSAGE
        ref.child("EMPLOYERS").child("Companies").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with:{ (snapshot) in
            
            //grabbing company name
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    name = child.key    //GRABBING THE NAME OF THE COMPANY
                }
            }
            
            //SETTING CUSTOM MESSEGE FOR EMPLOYER
            GlobalCompanyName = name
   
            print("Welcome, " + GlobalCompanyName)
            self.WelcomeMessage.text = "Welcome, " + GlobalCompanyName
           
            
        }) //END OF FUNCTION TO RETRIEVE COMPANY NAME

        ref.child("EMPLOYERS").child("Companies").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with:{ (snapshot) in
                let nextChild = snapshot.children.allObjects as! [DataSnapshot]
                //this allows us to get all the employees by counting how many branches the child has
                self.numOfEmployees = Int(nextChild[0].childrenCount)
                self.NumberOfEmployeesTextField.text = "Number Of Employees: " + String(self.numOfEmployees)
            
     
        })//END OF FUNCTION TO NUMBER OF EMPLOYEES
        
//        ref.child("REQUESTS").child("Companies").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with:{ (snapshot) in
//
//
//
//        })
        
        //adding rounded corners to the table view that handles all the requests in the main page
        RequestsTableView.layer.cornerRadius = 15
        RequestsTableView.layer.masksToBounds = true
        
        RequestsTableView.reloadData()
        
    }
    
  
    //NEED TO FIX THIS!!!!!
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = RequestCustomCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! RequestCustomCell
        cell.cellEmployeeName.text = "TEST"
        cell.cellShift.text = "9:00-5:00"
        cell.cellRequestReason.text = "Sick"
        cell.cellDescription.text = "Another Description"
        
        return cell
    }
    
    
}





