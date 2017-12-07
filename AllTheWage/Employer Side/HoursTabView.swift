//
//  HoursTabView.swift
//  AllTheWage
//
//  Description: This will allow the employer to set the payrate
//                  for their employees
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase

var employeeInfomation: [[String:String]] = []

class HoursTabView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate {
    
    var clickedToClose = false
    
    var currentEmployeeName = " "
    
    @IBOutlet var addHoursLabel: UITextField!
    
    @IBOutlet var addHoursButton: UIButton!
    @IBOutlet var hourSchedulerTextView: UITextView!
    @IBOutlet var HoursTabOpenButton: UIBarButtonItem!
    
    @IBOutlet var employeeSelectorTableView: UITableView!
    
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //we need to add these two statements to allow for the
        //implementation of the custom side menu button
        HoursTabOpenButton.target = self.revealViewController()
        HoursTabOpenButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        employeeSelectorTableView.delegate = self
        employeeSelectorTableView.dataSource = self
        
        hourSchedulerTextView.delegate = self
        addHoursLabel.delegate = self
        
        addHoursLabel.layer.isHidden = true
        addHoursButton.layer.isHidden = true
        
        
        employeeSelectorTableView.layer.isHidden = true
        employeeSelectorTableView.layer.cornerRadius = 15
        employeeSelectorTableView.layer.masksToBounds = true
        
        hourSchedulerTextView.layer.isHidden = true
        hourSchedulerTextView.layer.cornerRadius = 15
        hourSchedulerTextView.layer.masksToBounds = true
        
        ref.child("EMPLOYEES").child(GlobalCompanyName).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let allemployees = snapshot.children.allObjects as! [DataSnapshot]
            
            for employeeID in allemployees{
                let allinfo = employeeID.children.allObjects as! [DataSnapshot]
                let hoursworked = allinfo[1].value as! Double
                let e_name = allinfo[2].value as! String
                let payRate = allinfo[3].value as! Double
                let payCheck = allinfo[4].value as! Double
                let dictionary = ["Employee Name":String(e_name), "Hours Worked":String(hoursworked), "Pay Rate":String(payRate),"Paycheck Amount":String(payCheck)]
                if !employeeInfomation.contains(where: {$0 == dictionary}){
                    employeeInfomation.append(dictionary)
                }
            }
           
            self.employeeSelectorTableView.reloadData()
        })
        
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeInfomation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = employeeInfomation[indexPath.row]["Employee Name"]
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEmployee = employeeInfomation[indexPath.row]["Employee Name"]!
        showEmployeeHours(name: selectedEmployee, arrayLocation: indexPath.row)
    }
    
    @IBAction func clickedShowEmployees(_ sender: Any) {
        if !clickedToClose {
            employeeSelectorTableView.layer.isHidden = false
            clickedToClose = true
        } else {
            employeeSelectorTableView.layer.isHidden = true
            hourSchedulerTextView.layer.isHidden = true
            addHoursLabel.layer.isHidden = true
            addHoursButton.layer.isHidden = true
            
            clickedToClose = false
        }
    }
    
    func showEmployeeHours(name: String, arrayLocation: Int){
        hourSchedulerTextView.layer.isHidden = false
        addHoursLabel.layer.isHidden = false
        addHoursButton.layer.isHidden = false
        
        hourSchedulerTextView.text = name + "\n\nHours Worked: " + employeeInfomation[arrayLocation]["Hours Worked"]! + "\n\nYou can Add Hours Below"
        currentEmployeeName = employeeInfomation[arrayLocation]["Employee Name"]!
    }
    
    // DESCRIPTION:
    // Called when the editing is done on a textfield
    // and the return button is clicked to remove the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func clickedAddHours(_ sender: Any){
        self.view.endEditing(true)
        ref.child("EMPLOYEES").child(GlobalCompanyName).observeSingleEvent(of: .value, with: {(snapshot) in
            let addedHours = Double(self.addHoursLabel.text!)
            let allemployees = snapshot.children.allObjects as! [DataSnapshot]
            
            for employeeID in allemployees{
                let allinfo = employeeID.children.allObjects as! [DataSnapshot]
                let name = allinfo[2].value as! String
                let hours = allinfo[1].value as! Double
                
                if name == self.currentEmployeeName{
                    self.ref.child("EMPLOYEES").child(GlobalCompanyName).child(employeeID.key).child("Hours Worked").setValue(hours+addedHours!)
                    
                    self.updateInfomation()
                    
                    self.hourSchedulerTextView.text = name + "\n\nHours Worked: " + String(hours+addedHours!) + "\n\nYou can Add Hours Below"
                    let alert = UIAlertController(title: "Success", message: "Hours have been Added", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
                    self.present(alert, animated: true, completion: nil)
                    self.view.endEditing(true)
        
                }
            }
        })
        
     
       
    }

    func moveTextField(textField: UITextField, distance: Int, up: Bool){
        let duration = 0.3
        let movement: CGFloat = CGFloat(up ? -distance : distance)
        UIView.beginAnimations("animateKeyboard", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration)
        self.view.frame = (self.view.frame).offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1{
            
            moveTextField(textField: textField, distance: 150, up: false)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1{
            moveTextField(textField: textField, distance: 150, up: true)
            
        }
    }
    
    
    func updateInfomation(){
        ref.child("EMPLOYEES").child(GlobalCompanyName).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let allemployees = snapshot.children.allObjects as! [DataSnapshot]
            
            for employeeID in allemployees{
                let allinfo = employeeID.children.allObjects as! [DataSnapshot]
                let hoursworked = allinfo[1].value as! Double
                let e_name = allinfo[2].value as! String
                let payRate = allinfo[3].value as! Double
                let payCheck = allinfo[4].value as! Double
                let dictionary = ["Employee Name":String(e_name), "Hours Worked":String(hoursworked), "Pay Rate":String(payRate),"Paycheck Amount":String(payCheck)]
                
                if !employeeInfomation.contains(where: {$0 == dictionary}) {
                    var i = 0
                    for employees in employeeInfomation {
                        if employees["Employee Name"] == dictionary["Employee Name"] {
                            employeeInfomation[i]["Hours Worked"] = dictionary["Hours Worked"]
                            break
                        }
                        i+=1
                    }
                    
                  
                }
            }
            
            self.employeeSelectorTableView.reloadData()
        })
        
    }
    

}
