//
//  HSLabel+UILabel.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 10/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
 
    //MARK: configure label
    public func config(color:UIColor,size:CGFloat, align:NSTextAlignment, text:String){
        self.textColor = color
        self.textAlignment = align
        self.text = Utility.shared.getLanguage()?.value(forKey: text) as? String
        self.font = UIFont.init(name:APP_FONT_REGULAR, size: size+2)
    }
    
    func cornerRadius() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    func lblMinimumCornerRadius() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}
