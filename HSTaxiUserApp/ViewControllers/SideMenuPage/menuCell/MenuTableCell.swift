//
//  MenuTableCell.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 15/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class MenuTableCell: UITableViewCell {

    @IBOutlet var menuWalletLbl: UILabel!
    @IBOutlet var menuNameLbl: UILabel!
    @IBOutlet var menuImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        menuWalletLbl.config(color: GREEN_COLOR, size: 14, align: .right, text: EMPTY_STRING)
        self.changeToRTL()
    }
 func changeToRTL() {
     if UserModel.shared.getAppLanguage() == "Arabic" {
         self.menuWalletLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
         self.menuWalletLbl.textAlignment = .left
         self.menuNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
         self.menuNameLbl.textAlignment = .right
         self.menuImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
     }
     else {
         self.menuWalletLbl.transform = .identity
         self.menuWalletLbl.textAlignment = .right
         self.menuNameLbl.transform = .identity
         self.menuNameLbl.textAlignment = .left
         self.menuImgView.transform = .identity
     }
 }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configCell(menuDict:NSDictionary) {
        menuWalletLbl.text = menuDict.value(forKey: "menu_wallet") as? String
        let menuName:String = menuDict.value(forKey: "menu_name")as! String
        menuNameLbl.config(color: TEXT_PRIMARY_COLOR, size: 16, align: .left, text:menuName)
        menuImgView.image = UIImage.init(named: menuDict.value(forKey: "menu_icon") as! String)
        let leftPadding  =  self.menuWalletLbl.intrinsicContentSize.width+20
        self.menuWalletLbl.frame = CGRect.init(x:self.contentView.frame.size.width-leftPadding , y: 17, width: self.menuWalletLbl.intrinsicContentSize.width, height: 35)
        changeToRTL()
    }
    
}
