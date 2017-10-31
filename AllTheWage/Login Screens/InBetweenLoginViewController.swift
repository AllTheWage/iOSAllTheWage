//
//  InBetweenLoginViewController.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/17/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit

class InBetweenLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.performSegue(withIdentifier: "InBetween", sender: Any?.self)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
