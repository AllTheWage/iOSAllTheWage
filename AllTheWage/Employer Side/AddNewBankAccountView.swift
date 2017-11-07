//
//  AddNewBankAccountView.swift
//  AllTheWage
//
//  Description: This will allow the employer to add a new bank account
//                  for payroll
//
//  FOR NOW EVERYTHING IS COMMENTED OUT UNTIL WE GET AUTHORIZATION FROM PLAID TO IMPLEMENT
//  THEIR API FOR OUR PROJECT
//
//  Created by Andres Ibarra on 11/6/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import LinkKit

class AddNewBankAccountView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        //////////////////////////////////////////
        //
        //SETTING UP PLAID
        //
        //////////////////////////////////////////
        PLKPlaidLink.setup { (success, error) in
            if (success) {
                //THIS MEANS WE WERE ABLE TO SET UP PLAID LINK
                NSLog("Plaid Link setup was successful")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: self)
            }
            else if let error = error {
                NSLog("Unable to setup Plaid Link due to: \(error.localizedDescription)")
            }
            else {
                NSLog("Unable to setup Plaid Link")
            }
        }//END PLKPlaidLink.setup
        
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(delegate: linkViewDelegate as! PLKPlaidLinkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet;
        }
        present(linkViewController, animated: true)
*/
    }
 
    

}
   /*

extension ViewController : PLKPlaidLinkViewDelegate{
 
    //DID NOT MANAGE TO LOG IN SUCCESSFULLY
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        dismiss(animated: true) {
            if let error = error {
                NSLog("Failed to link account due to: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
            }
            else {
                NSLog("Plaid link exited with metadata: \(metadata ?? [:])")
                
            }
        }
    }
    
    
    //MANAGED TO LOG IN SUCCESSFULLY
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        dismiss(animated: true) {
            // Handle success, e.g. by storing publicToken with your service
            NSLog("Successfully linked account!\npublicToken: \(publicToken)\nmetadata: \(metadata ?? [:])")
           
        }
    }

    
}
  */
