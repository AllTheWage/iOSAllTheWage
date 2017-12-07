//
//  MainPageContoller.swift
//  AllTheWage
//
//  Description: This will show the employee the main page
//                  with the dashboard
//
//  Created by Andres Ibarra on 10/30/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase

var GlobalEmployeeName = " "

class MainPageContoller: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet var welcomeMessageLabel: UILabel! // WELCOME MESSAGE TO BE CUSTOMIZED FOR EACH USER
    @IBOutlet var Open: UIBarButtonItem!        // BUTTON FOR SIDE MENU
   
    var ref = Database.database().reference()   // DATABASE REF TO ALLOW US TO ACCESS IT
    
    
    var AbsenceRequestReasons:[String] = ["Sick", "Out Of Town", "Emergency", "Other"]
    var AbsenceRequestShift:[String] = ["No Shifts Yet"]
    
    
    // DESCRIPTION:
    // PICKER VIEW VARIABLES
    // these are the picker views which allow us to submit a request
    var ReasonPickerView = UIPickerView()
    var ShiftPickerView = UIPickerView()
    var toolBarforReasons = UIToolbar()
    var toolBarforShift = UIToolbar()
    
    
    @IBOutlet var ReasonTextField: UITextField!
    @IBOutlet var ShiftTextField: UITextField!
    @IBOutlet var ExtraInformationTextView: UITextView!
    
    
    // DESCRIPTION:
    // Called when the view loads up but before the view is displayed
    // We will do all of our set up here
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ReasonTextField.delegate = self
        self.ShiftTextField.delegate = self
        
        self.ReasonPickerView.delegate = self
        self.ReasonPickerView.dataSource = self
        ReasonPickerView.tag = 1
        
        self.ExtraInformationTextView.delegate = self
        
        self.ShiftPickerView.delegate = self
        self.ShiftPickerView.dataSource = self
        ShiftPickerView.tag = 2
        
        ReasonTextField.inputView = ReasonPickerView
        ShiftTextField.inputView = ShiftPickerView
    
        
        Open.target = self.revealViewController()                           //NEEDED FOR CUSTOM SIDE MENU
        Open.action = #selector(SWRevealViewController.revealToggle(_:))    //NEEDED FOR CUSTOM SIDE MENU
        
        var indexer = 0
        var companynamesindexer = 0
        //GRABBING EMPLOYER NAME AND SETTING IT TO BE THE GLOBAL COMPANY NAME
        self.ref.child("EMPLOYEES").observeSingleEvent(of: .value, with:{ (snapshot) in
           
            let allCompanyNames = snapshot.children.allObjects as! [DataSnapshot]
            
            for cnames in allCompanyNames {
                
                for userIDs in cnames.children.allObjects as! [DataSnapshot] {
                    
                    if userIDs.key == Auth.auth().currentUser!.uid {
                        GlobalCompanyName = allCompanyNames[indexer].key
                        break
                    }
                    companynamesindexer+=1
                    
                }
                indexer+=1
                
            }//END OF FOR LOOP
            
                //GRABBING EMPLOYEE NAME TO DISPLAY CUSTOM WELCOME MESSAGE
            self.ref.child("EMPLOYEES").child(String(GlobalCompanyName)).child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with:{ (snapshot) in
                let allinformation = snapshot.children.allObjects as! [DataSnapshot]
                let name = allinformation[2].value as! String
                GlobalEmployeeName = name
                self.welcomeMessageLabel.text = "Welcome, " + String(name)
                }) // END OF GRABBING EMPLOYEE NAME
 
        })// END OF GRABBING EMPLOYER NAME
        
        
    }// END OF VIEWDIDLOAD

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1{
            //REASONS TEXTFIELD
              moveTextField(textField: textField, distance: 120, up: false)
        
        }
        else if textField.tag == 2{
            //SHIFT TEXTFIELD
            moveTextField(textField: textField, distance: 130, up: false)
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
         return AbsenceRequestReasons.count
        }
        else if pickerView.tag == 2{
        return AbsenceRequestShift.count
        }
        else{
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1{
            return AbsenceRequestReasons[row]
        }
        else if pickerView.tag == 2{
            return AbsenceRequestShift[row]
        }
        else{
            return "No Information Yet"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{
            ReasonTextField.text = AbsenceRequestReasons[row]
        }
        else if pickerView.tag == 2{
            ShiftTextField.text = AbsenceRequestShift[row]
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1{
            moveTextField(textField: textField, distance: 120, up: true)
            //REASONS TEXTFIELD
        }
        else if textField.tag == 2{
            //SHIFT TEXTFIELD
              moveTextField(textField: textField, distance: 130, up: true)
        }
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
    
    
    @IBAction func clickedSubmitRequest(_ sender: Any) {
        let reasonwhy = ReasonTextField.text
        let shift = ShiftTextField.text
        let description = ExtraInformationTextView.text
        
        if reasonwhy != "" {
            if shift != "" {
                if description != "" {
                ref.child("REQUESTS").child(GlobalCompanyName).child(Auth.auth().currentUser!.uid).child("Reason").setValue(reasonwhy)
                ref.child("REQUESTS").child(GlobalCompanyName).child(Auth.auth().currentUser!.uid).child("Shift").setValue(shift)
                ref.child("REQUESTS").child(GlobalCompanyName).child(Auth.auth().currentUser!.uid).child("Extra Information").setValue(description)
                ref.child("REQUESTS").child(GlobalCompanyName).child(Auth.auth().currentUser!.uid).child("Employee Name").setValue(GlobalEmployeeName)
                    
                    let alert = UIAlertController(title: "Success", message: "Request has been added", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
                    present(alert, animated: true, completion: nil)
                    
                    ReasonTextField.text = ""
                    ShiftTextField.text = ""
                    ExtraInformationTextView.text = ""
                }
                else{
                ref.child("REQUESTS").child(GlobalCompanyName).child(Auth.auth().currentUser!.uid).child("Reason").setValue(reasonwhy)
                ref.child("REQUESTS").child(GlobalCompanyName).child(Auth.auth().currentUser!.uid).child("Employee Name").setValue(GlobalEmployeeName)
                ref.child("REQUESTS").child(GlobalCompanyName).child(Auth.auth().currentUser!.uid).child("Shift").setValue(shift)
                ref.child("REQUESTS").child(GlobalCompanyName).child(Auth.auth().currentUser!.uid).child("Extra Information").setValue(" ")
                    
                    let alert = UIAlertController(title: "Success", message: "Request has been added", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
                    present(alert, animated: true, completion: nil)
                }
                
            }
        }else{
            //none of the information is inputted so display a warning messege
            let alert = UIAlertController(title: "Error", message: "Information Fields are empty.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default))
                present(alert, animated: true, completion: nil)
            
        }
        
        
        
    
    
    
    }
    
    
}
