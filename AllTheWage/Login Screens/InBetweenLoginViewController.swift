//
//  InBetweenLoginViewController.swift
//  AllTheWage
//
//  Description: View controller used to fix a small bug that will not
//              allow main view controller to set up correctly
//
//  Created by Andres Ibarra on 10/17/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit

class InBetweenLoginViewController: UIViewController {

    // DESCRIPTION:
    // Called when the view loads up but before the view is displayed
    // We will do all of our set up here
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true //hiding default navigation bar
        self.performSegue(withIdentifier: "InBetween", sender: Any?.self)
       
    }

   

}
