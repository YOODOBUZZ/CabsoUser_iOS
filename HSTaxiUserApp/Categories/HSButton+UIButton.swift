//
//  HSButton+UIButton.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 10/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    public func config(color:UIColor,size:CGFloat,align:UIControlContentHorizontalAlignment,title:String){
        self.setTitleColor(color, for: .normal)
        self.setTitle(Utility.shared.getLanguage()?.value(forKey: title) as? String, for: .normal)
        self.contentHorizontalAlignment = align
        self.titleLabel?.font = UIFont.init(name:APP_FONT_REGULAR, size: size+2)
    }
    func cornerRoundRadius() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }
    func cornerMiniumRadius() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    func setBorder(color:UIColor) {
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
    
    //MARK: shadow effect
    func floatingEffect() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.5;
    }
  
   func newEffect() {
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 2)
        self.layer.shadowRadius = 1.0;
        self.layer.shadowOpacity = 1;
        
    }
}
