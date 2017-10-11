//
//  HoursTabView.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit

class HoursTabView: UIViewController {

    
    @IBOutlet var HoursTabOpenButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HoursTabOpenButton.target = self.revealViewController()
        HoursTabOpenButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
