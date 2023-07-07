//
//  HSImgView+UIImageView.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 15/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import Foundation
extension UIImageView{
    func makeItRound() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    func setBorder(color:UIColor) {
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
    }
}
