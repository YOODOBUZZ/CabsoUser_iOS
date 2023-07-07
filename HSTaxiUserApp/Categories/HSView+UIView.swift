//
//  HSView+UIView.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 14/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import Foundation
extension UIView{
    //MARK: shadow effect
    func elevationEffect() {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.5;
    }
    //:MARK round corner radius
    func cornerViewRadius() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    //MARK: minimum corner radius
    func cornerViewMiniumRadius() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    //MARK: remove corner radius
    func removeCornerRadius() {
        self.layer.cornerRadius = 0.0
        self.layer.masksToBounds = false
    }
    
    //MARK:Specific corner radius
    func specificCornerRadius()  {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft , .topRight , .topLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        self.layer.backgroundColor = UIColor.green.cgColor
        //Here I'm masking the textView's layer with rectShape layer
        self.layer.mask = rectShape
    }
    
    //MARK: Set border
    func setViewBorder(color:UIColor) {
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
    }
    
}


