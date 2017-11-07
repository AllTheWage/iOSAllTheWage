//
//  PaycheckTabView.swift
//  AllTheWage
//
//  Description: This will show the employer how much they need to pay
//                   in paychecks to which employee
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit

class PaycheckTabView: UIViewController {

    @IBOutlet var PaycheckTabOpenButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //we need to add these two statements to allow for the
        //implementation of the custom side menu button
        PaycheckTabOpenButton.target = self.revealViewController()
        PaycheckTabOpenButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //this function allows us to leave correctly
    @IBAction func cancelAddNewBank(unwindSegue: UIStoryboardSegue){
        
    }
   
}
