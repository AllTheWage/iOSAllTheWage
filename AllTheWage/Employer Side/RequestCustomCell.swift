//
//  RequestCustomCell.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 12/4/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import UIKit

class RequestCustomCell: UITableViewCell {
        
        @IBOutlet var cellEmployeeName: UILabel! = UILabel()
        @IBOutlet var cellRequestReason: UILabel! = UILabel()
        @IBOutlet var cellShift: UILabel!  = UILabel()
        @IBOutlet var cellDescription: UITextView!  = UITextView()
  
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        



}
