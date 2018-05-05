//
//  FirstViewController.swift
//  AllTheWagev2
//
//  Created by Andres Ibarra on 5/5/18.
//  Copyright © 2018 andiba. All rights reserved.
//

import UIKit

class MainView: UIViewController {

    @IBOutlet var requestTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTableView.delegate = self
        requestTableView.dataSource = self
        
    }


}

extension MainView: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let Hcell = tableView.dequeueReusableCell(withIdentifier: "SectionHeader") as! sectionheader
    
        return Hcell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(65)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestsCell") as! requestCells
        
        
        cell.EmployeeName.text = "Some Name"
        cell.desciptionText.text = "Some Text"
        
        
        return cell
    }
    
    
    
    
    
}

class sectionheader: UITableViewCell {

    @IBOutlet var requests: UILabel!
    
}

class requestCells: UITableViewCell{
    @IBOutlet var EmployeeName: UILabel!
    
    @IBOutlet var desciptionText: UILabel!
}
