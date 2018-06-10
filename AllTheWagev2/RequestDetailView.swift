//
//  RequestDetailView.swift
//  AllTheWagev2
//
//  Created by Andres Ibarra on 6/10/18.
//  Copyright © 2018 andiba. All rights reserved.
//

import UIKit

class RequestDetailView: UIViewController {

    var EmployeeNamePassed = ""
    
    @IBOutlet var detailCardView: UIView!
    @IBOutlet var employeeNameTextView: UILabel!
    @IBOutlet var employeePositionTextView: UILabel!
    @IBOutlet var employeeReasonTextView: UILabel!
    @IBOutlet var employeeTimeRequestedTextView: UILabel!
    
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var declineButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeNameTextView.text = EmployeeNamePassed
      
    }
    
    
    func visualsSetup(){
        acceptButton.layer.cornerRadius = 20.0
        declineButton.layer.cornerRadius = 20.0
        detailCardView.layer.cornerRadius = 20.0
    }

}
