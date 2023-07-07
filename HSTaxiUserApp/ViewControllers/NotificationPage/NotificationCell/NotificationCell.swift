//
//  NotificationCell.swift
//  HSLiveStream
//
//  Created by APPLE on 18/02/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var notification_contentLbl: UILabel!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 18, align: .left, text: EMPTY_STRING)
        notification_contentLbl.config(color: TEXT_SECONDARY_COLOR, size: 13, align: .left, text: EMPTY_STRING)
        timeLbl.config(color: TEXT_TERTIARY_COLOR, size: 13, align: .left, text: EMPTY_STRING)
        self.changeToRTL()
    }

    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.notification_contentLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.notification_contentLbl.textAlignment = .right
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.iconImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.textAlignment = .right
        }
        else {
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.notification_contentLbl.transform = .identity
            self.notification_contentLbl.textAlignment = .left
            self.timeLbl.transform = .identity
            self.timeLbl.textAlignment = .left
            self.iconImgView.transform = .identity

        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCellWithDetails(notificationDict:NSDictionary)  {
        //set notification msg

        notification_contentLbl.text = notificationDict.value(forKey: "message") as? String
        titleLbl.text = notificationDict.value(forKey: "title") as? String
        let createdDate = (notificationDict.value(forKey: "notified_at") as AnyObject).doubleValue//time stamp
        self.timeLbl.text = Utility.shared.timeStamp(stamp: createdDate!, format: "EEE, MMM d, yyyy, h:mm a")
        if titleLbl.text == "Wallet Credited"{
            let walletcreditMsg = Utility().getLanguage()?.value(forKey: "wallet_credit_with_amount") as? String
            let msg  = self.notification_contentLbl.text?.replacingOccurrences(of: "Your wallet has been credited & wallet balance is", with: "\(walletcreditMsg ?? "")")
            notification_contentLbl.text = msg
        }
        
        if  titleLbl.text == "Ride Completed"  || titleLbl.text == "Wallet Credited" {
            self.iconImgView.image = #imageLiteral(resourceName: "ride_completed_icon")
        }else if titleLbl.text == "Ride Accepted" || titleLbl.text == "Payment Completed"{
            self.iconImgView.image = #imageLiteral(resourceName: "ride_completed_icon")
            if titleLbl.text == "Payment Completed" {
                notification_contentLbl.text = Utility.shared.getLanguage()?.value(forKey: notification_contentLbl.text!) as? String

            }
        }else if titleLbl.text == "Ride Cancelled"{
            self.iconImgView.image = #imageLiteral(resourceName: "ride_cancelled_icon")
        }else if titleLbl.text == "Admin"{
            self.iconImgView.image = #imageLiteral(resourceName: "admin_icon")
        }
        titleLbl.text = Utility.shared.getLanguage()?.value(forKey: titleLbl.text!) as? String

    }
    
}
