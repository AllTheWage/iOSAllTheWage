//
//  HelpTabView.swift
//  AllTheWage
//
//  Description: This will allow the employer to get help

//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit

class HelpTabView: UIViewController {

   
    @IBOutlet var HelpTabOpenButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //we need to add these two statements to allow for the
        //implementation of the custom side menu button
        HelpTabOpenButton.target = self.revealViewController()
        HelpTabOpenButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
