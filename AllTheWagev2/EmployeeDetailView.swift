//
//  EmployeeDetailView.swift
//  AllTheWagev2
//
//  Created by Andres Ibarra on 6/8/18.
//  Copyright © 2018 andiba. All rights reserved.
//

import UIKit

class EmployeeDetailView: UIViewController {

    @IBOutlet var employeeCardView: UIView!
    var EmployeeName = ""

    @IBOutlet var employeeNameTextView: UILabel!
    @IBOutlet var employeeEmailTextView: UILabel!
    @IBOutlet var employeePhoneTextView: UILabel!
    @IBOutlet var employeeJobTextView: UILabel!
    @IBOutlet var employeeHoursLoggedTextView: UILabel!
    @IBOutlet var employeePayTextView: UILabel!
    @IBOutlet var changeHourButton: UIButton!
    @IBOutlet var changePayButton: UIButton!
    @IBOutlet var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualsSetup()
        employeeNameTextView.text = EmployeeName
        
    }

    func visualsSetup(){
        employeeCardView.layer.cornerRadius = 20
        employeeCardView.layer.masksToBounds = true
        
        changeHourButton.layer.cornerRadius = 20
        changeHourButton.layer.masksToBounds = true
       
        changePayButton.layer.cornerRadius = 20
        changePayButton.layer.masksToBounds = true
        
        
        returnButton.layer.cornerRadius = 10
        returnButton.layer.masksToBounds = true
        
    }
    
    
    
}
