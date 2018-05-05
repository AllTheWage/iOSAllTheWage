//
//  CustomTabBar.swift
//  templateEvent
//
//  Created by Andres Ibarra on 3/3/18.
//  Copyright © 2018 andiba. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBarController {

    //
    //CUSTOMIZE TAB BAR HERE
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the following line to true to make it a translucent tab bar
        self.tabBar.isTranslucent = false

        //This is to automatically fix colors
        //You can, of course, select any color you want
        //by going in the extension an manually changing
        //the code
        setTabBarColor(color: 0xFFFFFF)
        //setColorOfTabBarIcons()
        
       
        
    }

}


extension CustomTabBar{
    
    //sets the background color of the tabBar view
    //color must be passed in as a Hexidecimal
    func setTabBarColor(color: Int){
        self.tabBar.barTintColor = hexToColor(color: color,alpha: 1.0)
    }
    
    
    func setColorOfTabBarIcons(){
            setColorOfUnselectedItem(color: 0xFFFFFF, alpha: 0.5)
            setColorOfSelectedItem(color: 0xFFFFFF, alpha: 1.0)
    }
    
    
    func setColorOfUnselectedItem(color:Int, alpha: Double){
        self.tabBar.unselectedItemTintColor = hexToColor(color: color, alpha: alpha)
    }
    
    func setColorOfSelectedItem(color:Int, alpha: Double){
        self.tabBar.tintColor = hexToColor(color: color, alpha: alpha)
    }
    
    
    //helper function to convert hex code to color
    func hexToColor(color: Int, alpha: Double)->UIColor{
        let red = CGFloat((color & 0xFF0000) >> 16)/256.0
        let green = CGFloat((color & 0xFF00) >> 8)/256.0
        let blue = CGFloat(color & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha: CGFloat(alpha))
    }
    
    
}
