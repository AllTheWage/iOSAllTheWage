//
//  FirstScreenView.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase


class FirstScreenView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            print("COULD NOT SIGN OUT")
            print(error.localizedDescription)
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func ClickedEmployer(_ sender: Any) {
        self.performSegue(withIdentifier: "EmployerToLogin", sender: Any?.self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
