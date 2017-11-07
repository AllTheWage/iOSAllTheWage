//
//  ForumTabView.swift
//  AllTheWage
//
//  Description: This will allow the employer to see the Employer/Employee
//                  forum and send messages to customers
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit

class ForumTabView: UIViewController {
    
    @IBOutlet var ForumTabOpenButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ForumTabOpenButton.target = self.revealViewController()
        ForumTabOpenButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
