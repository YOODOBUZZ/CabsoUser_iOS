//
//  BookingCell.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 20/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class BookingCell: UITableViewCell {

    @IBOutlet var categoryImgView: UIImageView!
    @IBOutlet var idLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var statusLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.idLbl.config(color: TEXT_SECONDARY_COLOR, size: 14, align: .left, text: EMPTY_STRING)
        self.statusLbl.config(color: TEXT_SECONDARY_COLOR, size: 14, align: .left, text: EMPTY_STRING)
        self.timeLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: EMPTY_STRING)
        self.categoryImgView.makeItRound()
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.idLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.idLbl.textAlignment = .right
            self.statusLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.statusLbl.textAlignment = .right
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.textAlignment = .right
            self.categoryImgView.transform = CGAffineTransform(scaleX: -1, y: 1)

        }
        else {
            self.idLbl.transform = .identity
            self.idLbl.textAlignment = .left
            self.statusLbl.transform = .identity
            self.statusLbl.textAlignment = .left
            self.timeLbl.transform = .identity
            self.timeLbl.textAlignment = .left
            self.categoryImgView.transform = .identity

        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(bookingDict:NSDictionary)  {
        self.categoryImgView.sd_setImage(with: URL(string: bookingDict.value(forKey: "category_image") as! String), placeholderImage: #imageLiteral(resourceName: "default_car"))
        self.idLbl.text =  bookingDict.value(forKey: "vehicle_no") as? String
        let createdDate = (bookingDict.value(forKey: "pickup_time") as AnyObject).doubleValue//time stamp
        self.timeLbl.text = Utility.shared.timeStamp(stamp: createdDate!, format: "EEE, MMM d, yyyy, h:mm a")
        let status:String = (bookingDict.value(forKey: "ride_status") as? String)!
        if status == "accepted" {
            self.statusLbl.config(color: GREEN_COLOR, size: 13, align: .left, text: "accepted")
        }else if status == "onride" {
            self.statusLbl.config(color: GREEN_COLOR, size: 13, align: .left, text: "onride")
        }else if status == "scheduled"{
            self.idLbl.text =  bookingDict.value(forKey: "category_name") as? String
            self.statusLbl.config(color: GREEN_COLOR, size: 14, align: .left, text: "upcoming")
        }else if status == "ontheway"{
            self.statusLbl.config(color: GREEN_COLOR, size: 14, align: .left, text: "ontheway")
        }
        self.changeToRTL()
    }
    
    
}
