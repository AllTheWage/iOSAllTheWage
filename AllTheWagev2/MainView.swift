//
//  FirstViewController.swift
//  AllTheWagev2
//
//  Created by Andres Ibarra on 5/5/18.
//  Copyright © 2018 andiba. All rights reserved.
//

import UIKit

class MainView: UIViewController {
    @IBOutlet var requestsTableView: UITableView!
    var allRequests = Array< Dictionary<String, String> >()
    var testData = ["John Smith", "John Appleseed", "Steve Jobs", "Bill Gates", "Andres Ibarra"]
    
    override func viewDidLoad() {
        requestsTableView.delegate = self
        requestsTableView.dataSource = self
        
    }
    
    @IBAction func unwindToRequests(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    
    
}

extension MainView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(90)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "request") as! requestsCell
        cell.employeeName.text = testData[indexPath.row]
        cell.reasonForRequest.text = "Sick"
        cell.dateStamp.text = "1d"
        cell.profilePicture.layer.masksToBounds = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "requestDetailView") as! RequestDetailView
        
       
            vc.EmployeeNamePassed = testData[indexPath.row]
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
}


class requestsCell: UITableViewCell{
    @IBOutlet var employeeName: UILabel!
    @IBOutlet var reasonForRequest: UILabel!
    @IBOutlet var dateStamp: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    
    
}





