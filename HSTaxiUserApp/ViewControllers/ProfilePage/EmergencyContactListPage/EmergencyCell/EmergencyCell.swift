//
//  EmergencyCell.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 26/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class EmergencyCell: UITableViewCell {
    @IBOutlet var contactNameLbl: UILabel!
    
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var contactNoLbl: UILabel!
    @IBOutlet var menuBtn: UIButton!
    
    @IBOutlet var menuView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.menuView.isHidden = true
        self.menuView.cornerViewMiniumRadius()
        self.menuView.elevationEffect()
        contactNameLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: EMPTY_STRING)
        contactNoLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, text: EMPTY_STRING)
        self.menuView.frame = CGRect.init(x: menuBtn.frame.origin.x, y: 30, width:0 , height: 0)
        self.editBtn.config(color: .white, size: 15, align: .left, title: "edit")
        self.deleteBtn.config(color: .white, size: 15, align: .left, title: "delete")
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.contactNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.contactNameLbl.textAlignment = .right
            self.contactNoLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.contactNoLbl.textAlignment = .right

            self.editBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.editBtn.contentHorizontalAlignment = .right
            self.deleteBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.deleteBtn.contentHorizontalAlignment = .right
            self.menuBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.menuBtn.contentHorizontalAlignment = .right
        }
        else {
            self.contactNameLbl.transform = .identity
            self.contactNameLbl.textAlignment = .left
            self.contactNoLbl.transform = .identity
            self.contactNoLbl.textAlignment = .left

            self.editBtn.transform = .identity
            self.editBtn.contentHorizontalAlignment = .left
            self.deleteBtn.transform = .identity
            self.deleteBtn.contentHorizontalAlignment = .left
            self.menuBtn.transform = .identity
            self.menuBtn.contentHorizontalAlignment = .left
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(contactDict:NSDictionary)  {
        contactNameLbl.text = contactDict.value(forKey: "name") as? String
        contactNoLbl.text = contactDict.value(forKey: "phone_no") as? String
        let menuShow = contactDict.value(forKey: "menuShow") as? String
        if menuShow == "1"{
            self.menuView.isHidden = false
            self.menuView.frame = CGRect.init(x: self.menuBtn.frame.origin.x-60, y: 0, width:70 , height: 60)
        }else if menuShow == "0"{
            self.menuView.isHidden = true
            self.menuView.frame = CGRect.init(x: menuBtn.frame.origin.x, y: 30, width:0 , height: 0)
        }
    }
}
