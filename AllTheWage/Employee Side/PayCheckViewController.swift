//
//  PayCheckViewController.swift
//  AllTheWage
//
//  Description: This will show the employee
//              how much they have earned
//
//  Created by Andres Ibarra on 10/30/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit

class PayCheckViewController: UIViewController {

    @IBOutlet var Open: UIBarButtonItem!
    
    // DESCRIPTION:
    // Called when the view loads up but before the view is displayed
    // We will do all of our set up here
    override func viewDidLoad() {
        super.viewDidLoad()

        //we need to add these two statements to allow for the
        //implementation of the custom side menu button
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
    }//END OF VIEWDIDLOAD

    
}
