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
import WebKit

var haveABank = false
var bankInformation:[String:String] = ["Bank Name":" ","Bank Account Number": " ","Account Number": " ","Balance Available": " ","Account Name": " "]

class AddNewBankAccountView: UIViewController, WKNavigationDelegate {
 
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        haveABank = false
        
        let linkUrl = generateLinkInitializationURL()
        let url = URL(string: linkUrl)
        let request = URLRequest(url: url!)
        
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        
        webView.frame = view.frame
        webView.scrollView.bounces = false
        self.view.addSubview(webView)
        webView.load(request)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    func getUrlParams(url: URL) -> Dictionary<String, String> {
        var paramsDictionary = [String: String]()
        let queryItems = URLComponents(string: (url.absoluteString))?.queryItems
        queryItems?.forEach { paramsDictionary[$0.name] = $0.value }
        return paramsDictionary
    }
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
    }
    
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
                bankInformation["Bank Account Number"] = queryParams["account"]
                bankInformation["Account Name"] = queryParams["account_name"]
                
                for items in bankInformation {
                    print(items)
                }
                // Close the webview
                haveABank = true
                self.dismiss(animated: true, completion: nil)
                break
                
            case "exit"?:
                // Close the webview
                self.navigationController?.popViewController(animated: true)
                
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
    }
}
