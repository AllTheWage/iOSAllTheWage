//
//  RequestsView.swift
//  AllTheWage
//
//  Description: Employee can see all of his created requests
//              and their progress
//  Created by Andres Ibarra on 11/8/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit

class RequestsView: UIViewController {

    @IBOutlet var RequestsTabOpenButton: UIBarButtonItem!
    // DESCRIPTION:
    // Called when the view loads up but before the view is displayed
    // We will do all of our set up here
    override func viewDidLoad() {
        super.viewDidLoad()

        
        RequestsTabOpenButton.target = self.revealViewController()
        RequestsTabOpenButton.action = #selector(SWRevealViewController.revealToggle(_:))
        // Do any additional setup after loading the view.
        
    }

   

    

}
