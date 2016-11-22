//
//  BillTab.swift
//  HW9.01
//
//  Created by apple on 11/21/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import Foundation
import UIKit

class Billtab: UITabBarController {
    
    @IBOutlet var menu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
