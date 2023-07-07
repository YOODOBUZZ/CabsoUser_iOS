//
//  WalletCell.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 20/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class WalletCell: UITableViewCell {
    @IBOutlet var detailsLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var typeImgView: UIImageView!
    @IBOutlet var amountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.timeLbl.config(color: TEXT_SECONDARY_COLOR, size: 12, align: .left, text: EMPTY_STRING)
        self.amountLbl.config(color: GREEN_COLOR, size: 15, align: .right, text: EMPTY_STRING)

    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.textAlignment = .right
            self.detailsLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.detailsLbl.textAlignment = .right
            self.typeImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.amountLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.amountLbl.textAlignment = .left
        }
        else {
            self.timeLbl.transform = .identity
            self.timeLbl.textAlignment = .right
            self.amountLbl.transform = .identity
            self.amountLbl.textAlignment = .left
            self.detailsLbl.transform = .identity
            self.detailsLbl.textAlignment = .left
            self.typeImgView.transform = .identity

        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func config(walletDict:NSDictionary)  {
        let amount:NSNumber = walletDict.value(forKey: "amount") as! NSNumber
        let transaction:String = walletDict.value(forKey: "transaction") as! String
        if transaction == "payride" {
            self.detailsLbl.config(color: TEXT_PRIMARY_COLOR, size: 18, align: .left, text: "ride_amt")
        }else if transaction == "addmoney"{
            self.detailsLbl.config(color: TEXT_PRIMARY_COLOR, size: 18, align: .left, text: "cash_load")
        }
        
        let type:String = walletDict.value(forKey: "type") as! String
        let roundedAmt = Double(round(Double(1000*Int(truncating: amount)))/1000)
        
        if type == "debit" {
            self.amountLbl.text = "\(Utility().currency()!) \(roundedAmt)"
            self.amountLbl.textColor = RED_COLOR
            self.typeImgView.image = #imageLiteral(resourceName: "debit_arrow")
        }else if type == "credit"{
            self.amountLbl.text = "\(Utility().currency()!) \(roundedAmt)"
            self.amountLbl.textColor = GREEN_COLOR
            self.typeImgView.image = #imageLiteral(resourceName: "credit_arrow")
        }
        
        let createdDate = (walletDict.value(forKey: "updated_at") as AnyObject).doubleValue//time stamp
        self.timeLbl.text = Utility.shared.timeStamp(stamp: createdDate!, format: "EEE, MMM d, YYYY, h:mm a")
        let leftPadding  =  self.amountLbl.intrinsicContentSize.width+20
        self.amountLbl.frame = CGRect.init(x:FULL_WIDTH-leftPadding , y: 24, width: self.amountLbl.intrinsicContentSize.width, height: 21)
        self.changeToRTL()

    }
    
}
