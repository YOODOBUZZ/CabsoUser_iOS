//
//  menuContainerPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 15/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import SidebarOverlay

class menuContainerPage: SOContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeObj = HomePage()
        let sideBar = SideMenuPage()
        self.menuSide = .left        
        self.topViewController = homeObj
        self.sideViewController = sideBar
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.menuSide = .right
        }
        else {
            self.menuSide = .left
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
