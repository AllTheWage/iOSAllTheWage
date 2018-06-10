//
//  SecondViewController.swift
//  AllTheWagev2
//
//  Created by Andres Ibarra on 5/5/18.
//  Copyright © 2018 andiba. All rights reserved.
//

import UIKit

class EmployeeView: UIViewController {

    var testData = ["John Smith", "John Appleseed", "Steve Jobs", "Bill Gates", "Andres Ibarra"]
    var filtered:[String] = []
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var employeeCollectionView: UICollectionView!
    
    var searchActive = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeCollectionView.delegate = self
        searchBar.delegate = self
        employeeCollectionView.dataSource = self
        searchBar.tintColor = UIColor.white
    
        
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(EmployeeView.cancelClick))
        cancelButton.tintColor = UIColor.black
        toolBar.setItems([cancelButton, spaceButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        searchBar.inputAccessoryView = toolBar
        
        
    }
    
    
    @objc func cancelClick(){
        searchActive = false;
        self.employeeCollectionView.reloadData()
        self.view.endEditing(true)
        searchBar.resignFirstResponder()
        print("Hello")
    }
    
    
    @IBAction func unwindToEmployees(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }


}


/*
 
 COLLECTION VIEW HANDLERS
 
 */
extension EmployeeView: UICollectionViewDelegate, UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return testData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "employeeCell", for: indexPath) as! employeeCell
        
        
        if(searchActive){
            cell.employeeName.text = filtered[indexPath.row]
        } else {
            cell.employeeName.text = testData[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "empDetail") as! EmployeeDetailView
        
        if searchActive{
            vc.EmployeeName = filtered[indexPath.row]
        }else{
        vc.EmployeeName = testData[indexPath.row]
        }
        
        self.present(vc, animated: true, completion: nil)
    
        
        
        
    }
    
    
}

/*
 
 Search Bar handlers
 
 */

extension EmployeeView: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        if filtered.count == 0{
            self.employeeCollectionView.reloadData()
        }
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        filtered = [];
        self.employeeCollectionView.reloadData()
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = []
        for name in testData{
            if name.capitalized.contains(searchText.capitalized){
                filtered.append(name)
            }
        }
        
        if filtered.count == 0{
            searchActive = false;
        }
        else{
            searchActive = true;
        }
        
        self.employeeCollectionView.reloadData()
    }
    
    
    
}


/*CUSTOM CLASS FOR EMPLOYEE CELL*/
class employeeCell: UICollectionViewCell{
    
    @IBOutlet var employeePicture: UIImageView!
    @IBOutlet var employeeName: UILabel!
    
    
}
