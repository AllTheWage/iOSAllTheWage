//
//  PaycheckTabView.swift
//  AllTheWage
//
//  Description: This will show the employer how much they need to pay
//                   in paychecks to which employee
//
//  Created by Andres Ibarra on 10/10/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit
import WebKit
import Firebase
import Stripe
import Alamofire

var haveABank = false
var bankInformation:[String:String] = ["Bank Name":" ","Bank Account Number": " ","Account Number": " ","Balance Available": " ","Account Name": " "]

class PaycheckTabView: UIViewController, UITextViewDelegate, WKNavigationDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let webView = WKWebView()
    //let paymentCardTextField = STPPaymentCardTextField()
    var clickedToClose = false
    var ref = Database.database().reference()

    @IBOutlet var employeeNameTableView: UITableView!
    @IBOutlet var PaycheckTabOpenButton: UIBarButtonItem!
    
    @IBOutlet var EmployeePaycheckInfoTextView: UITextView!
    @IBOutlet var bankInformationDisplay: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //paymentCardTextField.delegate = self
        //self.view.addSubview(paymentCardTextField)
        
        bankInformationDisplay.delegate = self
        //we need to add these two statements to allow for the
        //implementation of the custom side menu button
        PaycheckTabOpenButton.target = self.revealViewController()
        PaycheckTabOpenButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        EmployeePaycheckInfoTextView.delegate = self
       
        
        employeeNameTableView.delegate = self
        employeeNameTableView.dataSource = self
        employeeNameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        self.ref.child("BANKS").child(Auth.auth().currentUser!.uid).child(String(GlobalCompanyName)).observeSingleEvent(of: .value, with:{ (snapshot) in
            
            let allinfo = snapshot.children.allObjects as! [DataSnapshot]
            
            if allinfo.count > 1 {
                haveABank = true
                let bankname = allinfo[1].value as! String
                let accountName = allinfo[0].value as! String
                self.bankInformationDisplay.text = "Bank Name: " + bankname + "\n\nAccount Name: " + accountName
                self.bankInformationDisplay.layer.isHidden = false

                
            }
        })//END OF DATABASE QUERY
        
        // DESCRIPTION:
        // this database query is to retrieve all the employees names
        // and put them into the string array to be able to display later
        ref.child("EMPLOYERS").child("Companies").child(Auth.auth().currentUser!.uid).child(String(GlobalCompanyName)).observeSingleEvent(of: .value, with:{ (snapshot) in
            let nextChild = snapshot.children.allObjects as! [DataSnapshot]
            for eID in nextChild{
                var employeeInformation = eID.children.allObjects as! [DataSnapshot]
                if !importedNames {
                    //employeeInformation[2] holds the name of the employees
                    //need to check to see if the array already contains the name
                    if !employeeNames.contains(employeeInformation[2].value as! String) {
                        employeeNames.append(employeeInformation[2].value as! String)
                    }
                    
                }
            }
            importedNames = true
            
        })//END OF DATABASE QUERY
        employeeNameTableView.layer.cornerRadius = 15
        employeeNameTableView.layer.masksToBounds = true
        employeeNameTableView.layer.isHidden = true
        
        EmployeePaycheckInfoTextView.layer.cornerRadius = 15
        EmployeePaycheckInfoTextView.layer.masksToBounds = true
       
        
        
        
    }//END OF VIEWDIDLOAD
    
    
    //
    //
    //
    //BEGINNING PLAID API INITIALIZATION AND HANDLING FUNCTIONS
    //
    //
    //
    func getUrlParams(url: URL) -> Dictionary<String, String> {
        var paramsDictionary = [String: String]()
        let queryItems = URLComponents(string: (url.absoluteString))?.queryItems
        queryItems?.forEach { paramsDictionary[$0.name] = $0.value }
        return paramsDictionary
    }// END OF GETURLPARAMS
    
    func generateLinkInitializationURL() -> String {
        let config = [
            "key": "0a8665a68e9bc1e02edf51aea606fe",
            "env": "development",
            "apiVersion": "v2", // set this to "v1" if using the legacy Plaid API
            "product": "auth",
            "selectAccount": "true",
            "clientName": String(GlobalCompanyName),
            "isMobile": "true",
            "isWebview": "true",
            "webhook": "https://requestb.in",
            ]
        // Build a dictionary with the Link configuration options
        // See the Link docs (https://plaid.com/docs/quickstart) for full documentation.
        var components = URLComponents()
        components.scheme = "https"
        components.host = "cdn.plaid.com"
        components.path = "/link/v2/stable/link.html"
        components.queryItems = config.map { URLQueryItem(name: $0, value: $1) }
        return components.string!
    }// END OF generateLinkInitializationURL

    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {
        
        let linkScheme = "plaidlink";
        let actionScheme = navigationAction.request.url?.scheme;
        let actionType = navigationAction.request.url?.host;
        let queryParams = getUrlParams(url: navigationAction.request.url!)
        
        if (actionScheme == linkScheme) {
            switch actionType {
                
            case "connected"?:
                
                // Parse data passed from Link into a dictionary
                // This includes the public_token as well as account and institution metadata
                print("Public Token: \(queryParams["public_token"] ?? " ")");
                print("Institution type: \(queryParams["institution_type"] ?? " ")");
                print("Institution name: \(queryParams["institution_name"] ?? " ")");
                bankInformation["Bank Name"] = queryParams["institution_name"]
 
                bankInformation["Account Name"] = queryParams["account_name"]
                
                for items in bankInformation {
                    print(items)
                }
                // Close the webview
                haveABank = true
                self.webView.removeFromSuperview()
                displayInformation();
                //showDropIn(clientTokenOrTokenizationKey: queryParams["public_token"]!)
                self.navigationController?.isNavigationBarHidden = false
                break
                
            case "exit"?:
                // Close the webview
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.isNavigationBarHidden = false
                // Parse data passed from Link into a dictionary
                // This includes information about where the user was in the Link flow
                // any errors that occurred, and request IDs
                print("URL: \(String(describing: navigationAction.request.url?.absoluteString))")
                // Output data from Link
                print("User status in flow: \(String(describing: queryParams["status"]))");
                // The requet ID keys may or may not exist depending on when the user exited
                // the Link flow.
                print("Link request ID: \(String(describing: queryParams["link_request_id"]))");
                print("Plaid API request ID: \(String(describing: queryParams["link_request_id"]))");
                
                self.webView.removeFromSuperview()
                self.navigationController?.isNavigationBarHidden = false
                break
                
            default:
                print("Link action detected: \(String(describing: actionType))")
                break
            }
            
            decisionHandler(.cancel)
        } else if (navigationAction.navigationType == WKNavigationType.linkActivated &&
            (actionScheme == "http" || actionScheme == "https")) {
            // Handle http:// and https:// links inside of Plaid Link,
            // and open them in a new Safari page. This is necessary for links
            // such as "forgot-password" and "locked-account"
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            print("Unrecognized URL scheme detected that is neither HTTP, HTTPS, or related to Plaid Link: \(String(describing: navigationAction.request.url?.absoluteString))");
            decisionHandler(.allow)
        }
    }//END OF webView FUNC
    //
    //
    //
    //END OF PLAID API INITIALIZATION AND HANDLING FUNCTIONS
    //
    //
    //
    
    
    @IBAction func clickedAddNewBank(_ sender: Any){

        self.navigationController?.isNavigationBarHidden = true;
        let linkUrl = generateLinkInitializationURL()
        let url = URL(string: linkUrl)
        let request = URLRequest(url: url!)

        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false

        webView.frame = view.frame
        webView.scrollView.bounces = false
        self.view.addSubview(webView)

        webView.load(request)

       //handleAddPaymentMethodButtonTapped()
       
        
    }
    //display bank information
    func displayInformation(){
        
        if haveABank {
            let accountName = bankInformation["Account Name"]!
            let bankName = bankInformation["Bank Name"]!
            bankInformationDisplay.text = "Bank Name: " + bankName + "\nAccount Name: " + accountName
            bankInformationDisplay.layer.isHidden = false
            ref.child("BANKS").child(Auth.auth().currentUser!.uid).child(String(GlobalCompanyName)).child("Has Bank").setValue(1)
            ref.child("BANKS").child(Auth.auth().currentUser!.uid).child(String(GlobalCompanyName)).child("Bank Name").setValue(bankName)
            ref.child("BANKS").child(Auth.auth().currentUser!.uid).child(String(GlobalCompanyName)).child("Account Name").setValue(accountName)
        }
    }//END OF DISPLAYINFORMATION
    
    
    
    
    @IBAction func clickedShowEmployee(_ sender: Any) {
        // checking if the table is already being displayed
        // if not display it, else hide it
        if !clickedToClose {
            employeeNameTableView.layer.isHidden = false
            clickedToClose = true
        } else {
            employeeNameTableView.layer.isHidden = true
            EmployeePaycheckInfoTextView.layer.isHidden = true
            clickedToClose = false
        }
        
        for item in employeeNames{
          //  print(item)
            if item == "" {
                employeeNames.removeFirst()
            }
        }
        employeeNameTableView.reloadData()
  
    }//END OF CLICKEDSHOWEMPLOYEE
    
    
    // DESCRIPTION:
    // showEmployeePaycheck()
    // This will show the selected employee paycheck
    func showEmployeePaycheck(name: String, arrayLocation: Int){
        EmployeePaycheckInfoTextView.layer.isHidden = false
        ref.child("EMPLOYEES").child(String(GlobalCompanyName)).observeSingleEvent(of: .value, with:{ (snapshot) in
            let employeeIDs = snapshot.children.allObjects as! [DataSnapshot]
       
            for id in employeeIDs {
                let employeeInfo = id.children.allObjects as! [DataSnapshot]
               
                if employeeInfo[2].value as! String == name {
                    let e_payrate = employeeInfo[3].value as! Double
                    let e_hours = employeeInfo[1].value as! Double
                    self.EmployeePaycheckInfoTextView.text = "Paycheck Amount: " + String(e_hours*e_payrate) + "\n\nPay Rate: " + String(e_payrate) + "\n\nHours Worked: " + String(e_hours)
                    
                }
            }
            
        })
        employeeNameTableView.reloadData()
        
    }//END OF SHOWEMPLOYEEPAYCHECK
    
    
    ///////////////////////////////////////////////////////////////////////
    //
    // THE FOLLOWING FUNCTIONS ARE NEEDED TO PROPERLY IMPLEMENT THE TABLE
    // VIEW AND POPULATE THE DATA CORRECTLY
    //
    ///////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = employeeNames[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEmployee = employeeNames[indexPath.row]
        showEmployeePaycheck(name: selectedEmployee, arrayLocation: indexPath.row)
    }
    ///////////////////////////////////////////////////////////////////////
    // END OF TABLEVIEW FUNCTIONS
    ///////////////////////////////////////////////////////////////////////
 
    
}

//
//  STRIPE IMPLEMENTATION
//
/*
extension PaycheckTabView: STPPaymentContextDelegate, STPPaymentCardTextFieldDelegate, STPAddCardViewControllerDelegate, STPPaymentMethodsViewControllerDelegate{
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        return
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        return
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        return
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        return
    }
    
    
    
    func handleAddPaymentMethodButtonTapped() {
        // Setup add card view controller
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        Alamofire(token, completion: { (error: Error?) in
            if let error = error {
                // Show error in add card view controller
                completion(error)
            }
            else {
                // Notify add card view controller that token creation was handled successfully
                completion(nil)

                // Dismiss add card view controller
                dismiss(animated: true)
            }
        })
    }
    
    func handlePaymentMethodsButtonTapped() {
        // Setup customer context
        let customerContext = STPCustomerContext(keyProvider: MyApiClient.sharedClient)
        
        // Setup payment methods view controller
        let paymentMethodsViewController = STPPaymentMethodsViewController(configuration: STPPaymentConfiguration.shared(), theme: STPTheme.default(), customerContext: customerContext, delegate: self )
        
        // Present payment methods view controller
        let navigationController = UINavigationController(rootViewController: paymentMethodsViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: STPPaymentMethodsViewControllerDelegate
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        // Dismiss payment methods view controller
        dismiss(animated: true)
        
        // Present error to user...
    }
    
    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        // Dismiss payment methods view controller
        dismiss(animated: true)
    }
    
    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        // Dismiss payment methods view controller
        dismiss(animated: true)
    }
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didSelect paymentMethod: STPPaymentMethod) {
        // Save selected payment method
        
    }
    
    
    
    
}
*/
