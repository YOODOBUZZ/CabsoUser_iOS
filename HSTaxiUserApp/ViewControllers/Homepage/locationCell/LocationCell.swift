//
//  LocationCell.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 19/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet var locationSecondaryLbl: UILabel!
    @IBOutlet var locationPrimaryLbl: UILabel!
    @IBOutlet weak var like_btn: UIButton!
    
    @IBOutlet weak var myLocationIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationSecondaryLbl.config(color: TEXT_TERTIARY_COLOR, size: 13, align: .left, text: "")
        locationPrimaryLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, text: "")
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.locationSecondaryLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationSecondaryLbl.textAlignment = .right
            self.locationPrimaryLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.locationPrimaryLbl.textAlignment = .right
        }
        else {
            self.locationSecondaryLbl.transform = .identity
            self.locationSecondaryLbl.textAlignment = .left
            self.locationPrimaryLbl.textAlignment = .left
            self.locationPrimaryLbl.transform = .identity
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func configCell(locationDict:NSDictionary) {
        locationPrimaryLbl.frame = CGRect.init(x: 20, y: 7, width: FULL_WIDTH-80, height: 25)
        locationSecondaryLbl.frame = CGRect.init(x: 20, y: 28, width: FULL_WIDTH-80, height: 25)

        let locType = locationDict.value(forKey: "type") as! NSString
        let first_add = locationDict.value(forKey: "address_first") as! String
        var second_add = String()

        if locationDict.value(forKey: "address_second") == nil {
            second_add = locationDict.value(forKey: "address_full") as! String
        }else{
            second_add = locationDict.value(forKey: "address_second") as! String
        }
        if  locType.isEqual(to: "new"){
            locationPrimaryLbl.text = first_add
            locationSecondaryLbl.text = second_add
        }else{
            locationPrimaryLbl.text = locType as String
            locationSecondaryLbl.text = "\(first_add), \(second_add)"

        }
        myLocationIcon.isHidden = true
        like_btn.isHidden = false
        locationSecondaryLbl.isHidden = false
        self.changeToRTL()
    }
    func configMyLocationCell(){
        locationPrimaryLbl.frame = CGRect.init(x: 50 , y: 0, width: FULL_WIDTH-50, height: 60)
        myLocationIcon.frame = CGRect.init(x: 20, y: 20, width: 20, height: 20)
        locationPrimaryLbl.text = Utility.shared.getLanguage()?.value(forKey: "find_my_loc") as? String
        locationSecondaryLbl.isHidden = true
        like_btn.isHidden = true
        myLocationIcon.isHidden = false
        self.changeToRTL()
    }
    
}
