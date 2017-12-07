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

//array of dictionaries to hold all the infomation grabbed from database
//requestInformation[0] = employee name
//requestInformation[1] = reason
//requestInformation[2] = shift
//requestInformation[3] = extra information
var requestInfomation: [[String:String]] = [["Employee Name":" "], ["Reason":" "], ["Shift":" "],["Extra Infomation":" "]]


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    var requests = ["First Request"]
    var totalPaychecks = 0.00
    
    var ref = Database.database().reference() // DATABASE REF TO ALLOW US TO ACCESS IT
    var numOfEmployees = 0  //to be displayed in Dashboard
    
    //CUSTOMIZED WELCOME MESSAGE LABEL
    @IBOutlet var WelcomeMessage: UILabel!
    
    @IBOutlet var PaycheckTotalLabel: UILabel!
    @IBOutlet var NumberOfEmployeesTextField: UILabel!
    @IBOutlet var EmployerNameTextField: UILabel!
    @IBOutlet var Open: UIBarButtonItem!
    @IBOutlet var RequestsTableView: UITableView!
    
    override func viewDidLoad() {
        var name: String!
        
        super.viewDidLoad()

        RequestsTableView.delegate = self
        RequestsTableView.dataSource = self
        
        
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
            
            self.ref.child("REQUESTS").child(name).observeSingleEvent(of: .value, with:{ (snapshot) in
                let allrequests = snapshot.children.allObjects as! [DataSnapshot]
                var i = 0
                
                for request in allrequests{
                    let requestInfo = request.children.allObjects as! [DataSnapshot]
                    print(requestInfo[0].value as! String)
                    let name = requestInfo[0].value as! String
                    let extraInformation = requestInfo[1].value as! String
                    let reason = requestInfo[2].value as! String
                    let shift = requestInfo[3].value as! String
                    
                    //name
                    requestInfomation[i]["Employee Name"] = name
                    requestInfomation[i]["Reason"] = reason
                    requestInfomation[i]["Shift"] = shift
                    requestInfomation[i]["Extra Information"] = extraInformation
                    
                    self.requests.append(name)
                    i+=1
                }
                
                if self.requests[0] == "First Request"{
                    self.requests.removeFirst()
                }
                print(self.requests)
                self.RequestsTableView.reloadData()
                
            })
            
            self.ref.child("EMPLOYEES").child(GlobalCompanyName).observeSingleEvent(of: .value, with:{ (snapshot) in
                let allemployees = snapshot.children.allObjects as! [DataSnapshot]
                
                for employeeIDs in allemployees{
                    let employeeInfo = employeeIDs .children.allObjects as! [DataSnapshot]
                    self.ref.child("EMPLOYEES").child(GlobalCompanyName).child(employeeIDs.key).child("Paycheck Amount").setValue(((employeeInfo[1].value as! Double)*(employeeInfo[3].value as! Double)))// update paycheck
                    self.totalPaychecks += ((employeeInfo[1].value as! Double)*(employeeInfo[3].value as! Double)) // updated paycheck ofemployee
                }
                self.PaycheckTotalLabel.text = "Paycheck Total: $" + String(self.totalPaychecks)
            })//END OF FUNCTION TO GET PAYCHECK TOTALS
            
       
        }) //END OF FUNCTION TO RETRIEVE COMPANY NAME

        ref.child("EMPLOYERS").child("Companies").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with:{ (snapshot) in
                let nextChild = snapshot.children.allObjects as! [DataSnapshot]
                //this allows us to get all the employees by counting how many branches the child has
                self.numOfEmployees = Int(nextChild[0].childrenCount)
                self.NumberOfEmployeesTextField.text = "Number Of Employees: " + String(self.numOfEmployees)
            
     
        })//END OF FUNCTION TO NUMBER OF EMPLOYEES
        
        
        
        
        
        
        
   
        
        //adding rounded corners to the table view that handles all the requests in the main page
        RequestsTableView.layer.cornerRadius = 15
        RequestsTableView.layer.masksToBounds = true
        
        RequestsTableView.reloadData()
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = RequestCustomCell()
       let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! RequestCustomCell
        
        
        
        cell.cellEmployeeName.text = requestInfomation[indexPath.row]["Employee Name"]
        cell.cellShift.text = requestInfomation[indexPath.row]["Shift"]
        cell.cellRequestReason.text = requestInfomation[indexPath.row]["Reason"]
        cell.cellDescription.text = requestInfomation[indexPath.row]["Extra Information"]
        print(requestInfomation[indexPath.row])
        
        return cell
    }
    
   
}







