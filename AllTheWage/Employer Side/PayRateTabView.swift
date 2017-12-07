//
//  PayRateTabView.swift
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


class PayRateTabView: UIViewController {
    var firsttime = true
    var clickedToClose = false
    var currentEmployeeName = " "
    var ref = Database.database().reference()

    @IBOutlet var PayRateOpenTabButton: UIBarButtonItem!
    @IBOutlet var employeeNameTableView: UITableView!
    @IBOutlet var changePayRateLabel: UITextField!
    @IBOutlet var changePayRateButton: UIButton!
    @IBOutlet var informationDisplayTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if employeeInfomation.count != 0{
            firsttime = false
        }
       
    
        //we need to add these two statements to allow for the
        //implementation of the custom side menu button
        PayRateOpenTabButton.target = self.revealViewController()
        PayRateOpenTabButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        employeeNameTableView.delegate = self
        employeeNameTableView.dataSource = self
        informationDisplayTextView.delegate = self
        changePayRateLabel.delegate = self

        changePayRateLabel.layer.isHidden = true
        changePayRateButton.layer.isHidden = true
       
        employeeNameTableView.layer.isHidden = true
        employeeNameTableView.layer.cornerRadius = 15
        employeeNameTableView.layer.masksToBounds = true
        
        informationDisplayTextView.layer.isHidden = true
        informationDisplayTextView.layer.cornerRadius = 15
        informationDisplayTextView.layer.masksToBounds = true
        
        updateInfomation()
   
    }

    
    @IBAction func clickedShowEmployees(_ sender: Any) {
        if !clickedToClose {
            employeeNameTableView.layer.isHidden = false
            clickedToClose = true
        } else {
            employeeNameTableView.layer.isHidden = true
            informationDisplayTextView.layer.isHidden = true
            changePayRateLabel.layer.isHidden = true
            changePayRateButton.layer.isHidden = true
            
            clickedToClose = false
        }
        
    }
    
    @IBAction func clickedChangePayRate(_ sender: Any) {
        self.view.endEditing(true)
        ref.child("EMPLOYEES").child(GlobalCompanyName).observeSingleEvent(of: .value, with: {(snapshot) in
            let newPayRate = Double(self.changePayRateLabel.text!)
            let allemployees = snapshot.children.allObjects as! [DataSnapshot]
            
            for employeeID in allemployees{
                let allinfo = employeeID.children.allObjects as! [DataSnapshot]
                let name = allinfo[2].value as! String
                
                if name == self.currentEmployeeName{
                    self.ref.child("EMPLOYEES").child(GlobalCompanyName).child(employeeID.key).child("Pay Rate").setValue(newPayRate)
                    
                    self.updateInfomation()
                
                    self.informationDisplayTextView.text = name + "\n\nCurrent Pay Rate: $" + String(newPayRate!) + "/hour\n\nYou can Change Pay Rate Below"
                    
                    let alert = UIAlertController(title: "Success", message: "Pay Rate has been changed", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
                    self.present(alert, animated: true, completion: nil)
                    self.view.endEditing(true)
                    
                }
            }
        })
    }
    
    //
    //updates the infomation and reloads the table view
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
                if self.firsttime{
                    employeeInfomation.append(dictionary)
                }else{
                    if !employeeInfomation.contains(where: {$0 == dictionary}) && !self.firsttime {
                        var i = 0
                        for employees in employeeInfomation{
                            if employees["Employee Name"] == dictionary["Employee Name"]
                            {
                                employeeInfomation[i]["Pay Rate"] = dictionary["Pay Rate"]
                                break
                            }
                            i+=1
                        }
                    }
                }
            }
            self.firsttime = false
            self.employeeNameTableView.reloadData()
        })
        
    }
    
    
}

extension PayRateTabView: UITableViewDelegate,UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate {
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return employeeInfomation.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = employeeInfomation[indexPath.row]["Employee Name"]
    return cell
}
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.updateInfomation()
        let selectedEmployee = employeeInfomation[indexPath.row]["Employee Name"]!
        showEmployeeRate(name: selectedEmployee, arrayLocation: indexPath.row)
    }
    
func showEmployeeRate(name: String, arrayLocation: Int){
        informationDisplayTextView.layer.isHidden = false
        changePayRateLabel.layer.isHidden = false
        changePayRateButton.layer.isHidden = false
    
        print(employeeInfomation[arrayLocation]["Pay Rate"]!)
        informationDisplayTextView.text = name + "\n\nCurrent Pay Rate: $" + employeeInfomation[arrayLocation]["Pay Rate"]! + "/hour\n\nYou can Change Pay Rate Below"
        currentEmployeeName = employeeInfomation[arrayLocation]["Employee Name"]!
    }
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            moveTextField(textField: textField, distance: 150, up: false)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            moveTextField(textField: textField, distance: 150, up: true)
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
    

}

