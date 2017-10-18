//
//  companyInfoDS.swift
//  AllTheWage
//
//  Created by Andres Ibarra on 10/17/17.
//  Copyright © 2017 Andres Ibarra. All rights reserved.
//

import Foundation

class companyInfoDS {
    
    var hashtable = [[Int]]()
    var companyHashTable = [[String]]()
    var NumToModulo = 20
    
    func initHashtable(){
        for _ in 0..<NumToModulo{
            hashtable.append([])
        }
        for _ in 0..<NumToModulo{
            companyHashTable.append([])
        }
        
    }
    //this will check if the userID is already in the file
    func exists(_ number: Int) -> Bool {
        let modC = number % NumToModulo
        for num in hashtable[modC] {
            if  number == num {
                return true
            }
        }
        return false
    }
    
    func addCompanyName(companyName: String, userID: String){
        let userIDConverted = Int(userID)!/4
        print(userIDConverted)
        
        if exists(userIDConverted) == true{
            return
        }
        let modC = userIDConverted % NumToModulo
        hashtable[modC].append(userIDConverted)
        companyHashTable[modC].append(companyName)
        
    }
    
    //8QmqYM2sjOOHf3AGKU40XNpDJBE3
}
