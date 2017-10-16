//
//  ViewController.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var EmployerNameTextField: UILabel!
    
    @IBOutlet var Open: UIBarButtonItem!
    
    @IBOutlet var RequestsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //adding rounded corners to the table view that handles all the requests in the main page
        RequestsTableView.layer.cornerRadius = 15
        RequestsTableView.layer.masksToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

