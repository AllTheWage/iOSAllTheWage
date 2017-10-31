//
//  MainPageContoller.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/30/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase

class MainPageContoller: UIViewController {

    @IBOutlet var welcomeMessageLabel: UILabel!
    @IBOutlet var Open: UIBarButtonItem!
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Open.target = self.revealViewController()
        Open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        var indexer = 0
        //GRABBING EMPLOYER NAME AND SETTING IT TO BE THE GLOBAL COMPANY NAME
        
        self.ref.child("EMPLOYEES").observeSingleEvent(of: .value, with:{ (snapshot) in
           
            let allCompanyNames = snapshot.children.allObjects as! [DataSnapshot]
            
            for cnames in allCompanyNames {
                let userIDs = cnames.children.allObjects as! [DataSnapshot]
           
                if userIDs[0].key == Auth.auth().currentUser!.uid {
                    GlobalCompanyName = allCompanyNames[indexer].key
                    break
                }
                indexer+=1
               
                
            }
            self.ref.child("EMPLOYEES").child(String(GlobalCompanyName)).child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with:{ (snapshot) in
                let allinformation = snapshot.children.allObjects as! [DataSnapshot]
                let name = allinformation[2].value as! String
                
                
                self.welcomeMessageLabel.text = "Welcome, " + String(name)
                })
            
            
            
            
            
        })
        
        
    }

    

}
