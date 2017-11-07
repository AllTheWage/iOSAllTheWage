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

class HoursTabView: UIViewController {
    
    @IBOutlet var HoursTabOpenButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //we need to add these two statements to allow for the
        //implementation of the custom side menu button
        HoursTabOpenButton.target = self.revealViewController()
        HoursTabOpenButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    

}
