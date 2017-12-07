//
//  EmployeeTabView.swift
//  AllTheWage
//
//  Description: This will allow the employer to see all the employees
//                  in their company
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase

var importedNames:Bool = false
var employeeNames:[String] = [""]

class EmployeeTabView: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    var clickedToClose = false  //this will help to allow the description to dissapear or appear according to the value of this variable
    
    var ref = Database.database().reference() // DATABASE REF TO ALLOW US TO ACCESS IT
    
    // DESCRIPTION:
    // ACTIVITY INDICATOR
    // loading circle that won't let the user think that the application crashed while it loads
    var loadingIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    // DESCRIPTION:
    // TEXTVIEW VARIABLES
    // This is the textview which will display all the information
    // of the selected employee
    @IBOutlet var employeeInformationTextView: UITextView!
    
    // DESCRIPTION:
    // TABLEVIEW VARIABLES
    // This is the tableview which will display all the employees
    // which can be selected to display more information
    @IBOutlet var employeeNameTable: UITableView!
    
    // DESCRIPTION:
    // AddEmployeeClicked()
    // This will simply be a segue
    @IBAction func AddEmployeeClicked(_ sender: Any) {
        performSegue(withIdentifier: "createNewEmployee", sender: nil)
    }
    
    
    @IBOutlet var EmployeesTabOpenButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // DESCRIPTION:
        // show the loginindicator so that user doesn't think the application froze
 
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(loadingIndicator)
        
        loadingIndicator.startAnimating()
        importedNames = false
        
        // DESCRIPTION:
        // this part is only needed to allow the view to manipulate
        // cells and the tableview
        employeeNameTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // DESCRIPTION:
        // this database query is to retrieve all the employees names
        // and put them into the string array to be able to display later
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
        })//END OF DATABASE QUERY
        
        //making the text view look nice
        employeeInformationTextView.layer.cornerRadius = 15
        employeeInformationTextView.layer.masksToBounds = true
        employeeInformationTextView.layer.isHidden = true
        
        //making the table view look nice
        employeeNameTable.layer.cornerRadius = 15
        employeeNameTable.layer.masksToBounds = true
        employeeNameTable.layer.isHidden = true
        
        //we need to add these two statements to allow for the
        //implementation of the custom side menu button
        EmployeesTabOpenButton.target = self.revealViewController()
        EmployeesTabOpenButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //stoping the loadingIndicator
        loadingIndicator.stopAnimating()
        
    }
    

    // DESCRIPTION:
    // clickedShowEmployee()
    // This will show all the employees or hide all the employees
    // as well as all the information
    @IBAction func clickedShowEmployee(_ sender: Any) {
        
        // checking if the table is already being displayed
        // if not display it, else hide it
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
    
    
   
    // DESCRIPTION:
    // showEmployeeInformation()
    // This will show all the employee information
    // This is the key to retrieve that information
    // requestedInformation[0] = Age
    // requestedInformation[1] = email
    // requestedInformation[2] = Name
    // requestedInformation[3] = Phone Number
    // requestedInformation[4] = Social Security
    func showEmployeeInformation(name: String, arrayLocation: Int){
        employeeInformationTextView.layer.isHidden = false

        
    ref.child("EMPLOYERS").child("Companies").child(Auth.auth().currentUser!.uid).child(String(GlobalCompanyName)).observeSingleEvent(of: .value, with:{ (snapshot) in
            let nextChild = snapshot.children.allObjects as! [DataSnapshot]
            var requestedInformation = nextChild[arrayLocation].children.allObjects as! [DataSnapshot]
        
            let e_age = requestedInformation[0].value as! String
            let e_email = requestedInformation[1].value as! String
            let e_phoneNumber = requestedInformation[3].value as! String
        
           //INSERT INFORMATION NOW INTO TEXT VIEW
        self.employeeInformationTextView.text = "Employee Information: \n\nName: " + name + "\nAge: " + String(e_age) + "\nEmail: " + String(e_email) + "\nPhone Number: " + String(e_phoneNumber)

        })
        employeeNameTable.reloadData()
   
    }
    
    ///////////////////////////////////////////////////////////////////////
    //
    // THE FOLLOWING FUNCTIONS ARE NEEDED TO PROPERLY IMPLEMENT THE TABLE
    // VIEW AND POPULATE THE DATA CORRECTLY
    //
    ///////////////////////////////////////////////////////////////////////
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
    ///////////////////////////////////////////////////////////////////////
    // END OF TABLEVIEW FUNCTIONS
    ///////////////////////////////////////////////////////////////////////

    // DESCRIPTION:
    // This function is here simply to allow us to properly exit
    // child views without messing up the navigation of the application
    @IBAction func cancelAddNewEmployee(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    
    
}

