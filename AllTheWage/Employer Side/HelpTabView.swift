//
//  HelpTabView.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit

class HelpTabView: UIViewController {

    @IBOutlet var HelpTabOpenButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        HelpTabOpenButton.target = self.revealViewController()
        HelpTabOpenButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
