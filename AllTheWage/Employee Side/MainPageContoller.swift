//
//  MainPageContoller.swift
//  AllTheWage
//
//  Description: This will show the employee the main page
//                  with the dashboard
//
//  Created by Andres Ibarra on 10/30/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import Firebase

class MainPageContoller: UIViewController {

    @IBOutlet var welcomeMessageLabel: UILabel! // WELCOME MESSAGE TO BE CUSTOMIZED FOR EACH USER
    @IBOutlet var Open: UIBarButtonItem!        // BUTTON FOR SIDE MENU
    var ref = Database.database().reference()   // DATABASE REF TO ALLOW US TO ACCESS IT
    
    
    // DESCRIPTION:
    // Called when the view loads up but before the view is displayed
    // We will do all of our set up here
    override func viewDidLoad() {
        super.viewDidLoad()
        Open.target = self.revealViewController()                           //NEEDED FOR CUSTOM SIDE MENU
        Open.action = #selector(SWRevealViewController.revealToggle(_:))    //NEEDED FOR CUSTOM SIDE MENU
        
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
               
                
            }//END OF FOR LOOP
            
                //GRABBING EMPLOYEE NAME TO DISPLAY CUSTOM WELCOME MESSAGE
            self.ref.child("EMPLOYEES").child(String(GlobalCompanyName)).child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with:{ (snapshot) in
                let allinformation = snapshot.children.allObjects as! [DataSnapshot]
                let name = allinformation[2].value as! String
                
                
                self.welcomeMessageLabel.text = "Welcome, " + String(name)
                }) // END OF GRABBING EMPLOYEE NAME
 
        })// END OF GRABBING EMPLOYER NAME
  
    }// END OF VIEWDIDLOAD

}
