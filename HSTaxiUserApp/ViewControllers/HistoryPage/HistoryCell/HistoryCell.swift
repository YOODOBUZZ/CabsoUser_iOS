//
//  HistoryCell.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 20/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet var idLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var statusIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.idLbl.config(color: TEXT_SECONDARY_COLOR, size: 14, align: .left, text: EMPTY_STRING)
        self.priceLabel.config(color: TEXT_SECONDARY_COLOR, size: 12, align: .left, text: EMPTY_STRING)
        self.timeLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: EMPTY_STRING)
        self.changeTORTL()
    }
    func changeTORTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.idLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.idLbl.textAlignment = .right
            self.priceLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.priceLabel.textAlignment = .right
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.textAlignment = .right
            self.statusIcon.transform = CGAffineTransform(scaleX: -1, y: 1)

        }
        else {
            self.idLbl.transform = .identity
            self.idLbl.textAlignment = .left
            self.priceLabel.transform = .identity
            self.priceLabel.textAlignment = .left
            self.timeLbl.transform = .identity
            self.timeLbl.textAlignment = .left
            self.statusIcon.transform = .identity

        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
       
    func config(historyDict:NSDictionary)  {
        //Set time
        let createdDate = (historyDict.value(forKey: "pickup_time") as AnyObject).doubleValue//time stamp
        self.timeLbl.text = Utility.shared.timeStamp(stamp: createdDate!, format: "EEE, MMM d, yyyy, h:mm a")
        let status:String = (historyDict.value(forKey: "ride_status") as? String)!
        
     
        if status == "cancelled" {
            self.priceLabel.isHidden = true
            let category_name = historyDict.value(forKey: "category_name") as! String
            let vehicle_no = historyDict.value(forKey: "vehicle_no") as! String
            self.idLbl.text =  "\(category_name) \(vehicle_no)"
            statusIcon.image = UIImage.init(named: "ride_cancelled_icon.png")
        }else if status == "completed"{
            self.priceLabel.isHidden = false
            let basePrice:NSNumber = historyDict.value(forKey: "total_price") as! NSNumber
            self.priceLabel.config(color: TEXT_PRIMARY_COLOR, size: 12, align: .center, text: EMPTY_STRING)
            self.priceLabel.text = "\(Utility().currency()!) \(Double(truncating: basePrice).clean)"
            let category_name = historyDict.value(forKey: "category_name") as! String
            let vehicle_no = historyDict.value(forKey: "vehicle_no") as! String
            self.idLbl.text =  "\(category_name) \(vehicle_no)"
            statusIcon.image = UIImage.init(named: "ride_completed_icon.png")
        }else if status == "scheduleridenotaccepted"{
            self.priceLabel.isHidden = true
            self.idLbl.text =  historyDict.value(forKey: "category_name") as? String
            statusIcon.image = UIImage.init(named: "ride_cancelled_icon.png")
        }
        self.changeTORTL()
    }
}
