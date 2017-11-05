//
//  EmployeeTabView.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase

var importedNames:Bool = false
var employeeNames:[String] = [""]

class EmployeeTabView: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    var clickedToClose = false
    var ref = Database.database().reference()
    //login activity view so user doesn't think the program chrashed
    var loadingIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var employeeInformationTextView: UITextView!
    
    @IBOutlet var employeeNameTable: UITableView!
    
    
    @IBAction func AddEmployeeClicked(_ sender: Any) {
        performSegue(withIdentifier: "createNewEmployee", sender: nil)
    }
    
    @IBOutlet var EmployeesTabOpenButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(loadingIndicator)
        
        loadingIndicator.startAnimating()
        importedNames = false
        super.viewDidLoad()
        
        employeeNameTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        ref.child("EMPLOYERS").child("Companies").child(Auth.auth().currentUser!.uid).child(String(GlobalCompanyName)).observeSingleEvent(of: .value, with:{ (snapshot) in
            let nextChild = snapshot.children.allObjects as! [DataSnapshot]
            for eID in nextChild{
                var employeeInformation = eID.children.allObjects as! [DataSnapshot]
                if !importedNames {
                    //employeeInformation[2] holds the name of the employees
                    //need to check to see if the array already contains the name
                    if !employeeNames.contains(employeeInformation[2].value as! String) {
                        employeeNames.append(employeeInformation[2].value as! String)
                    }
                    
                }
            }
            importedNames = true
        })
        //making the text look view nice
        employeeInformationTextView.layer.cornerRadius = 15
        employeeInformationTextView.layer.masksToBounds = true
        employeeInformationTextView.layer.isHidden = true
        
        //making the table look view nice
        employeeNameTable.layer.cornerRadius = 15
        employeeNameTable.layer.masksToBounds = true
        employeeNameTable.layer.isHidden = true
        
        EmployeesTabOpenButton.target = self.revealViewController()
        EmployeesTabOpenButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //stoping the loginIndicator
        loadingIndicator.stopAnimating()
        
    }
    

    
    @IBAction func clickedShowEmployee(_ sender: Any) {
        if !clickedToClose {
            employeeNameTable.layer.isHidden = false
            clickedToClose = true
        } else {
             employeeNameTable.layer.isHidden = true
            employeeInformationTextView.layer.isHidden = true
             clickedToClose = false
        }
  
        for item in employeeNames  {
            if item == "" {
                employeeNames.removeFirst()
            }
        }
        employeeNameTable.reloadData()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //employeeInformation[0] = Age
    //employeeInformation[1] = email
    //employeeInformation[2] = Name
    //employeeInformation[3] = Phone Number
    //employeeInformation[4] = Social Security
    func showEmployeeInformation(name: String, arrayLocation: Int){
        employeeInformationTextView.layer.isHidden = false

        
    ref.child("EMPLOYERS").child("Companies").child(Auth.auth().currentUser!.uid).child(String(GlobalCompanyName)).observeSingleEvent(of: .value, with:{ (snapshot) in
            let nextChild = snapshot.children.allObjects as! [DataSnapshot]
            var requestedInformation = nextChild[arrayLocation].children.allObjects as! [DataSnapshot]
        
            let e_age = requestedInformation[0].value as! Int
            let e_email = requestedInformation[1].value as! String
            let e_phoneNumber = requestedInformation[3].value as! String
        
           //INSERT INFORMATION NOW INTO TEXT VIEW
        self.employeeInformationTextView.text = "Employee Information: \n\nName: " + name + "\nAge: " + String(e_age) + "\nEmail: " + String(e_email) + "\nPhone Number: " + String(e_phoneNumber)

        })
        employeeNameTable.reloadData()
   
    }
    
    //UITABLEVIEW FUNCTIONS TO ALLOW POPULATION OF DATA
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = employeeNames[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEmployee = employeeNames[indexPath.row]
        showEmployeeInformation(name: selectedEmployee, arrayLocation: indexPath.row)
    }

    
    @IBAction func cancelAddNewEmployee(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    
    
}

