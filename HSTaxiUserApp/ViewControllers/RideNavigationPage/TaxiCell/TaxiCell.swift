//
//  TaxiCell.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 02/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class TaxiCell: UICollectionViewCell {
    @IBOutlet var carImgView: UIImageView!
    @IBOutlet var timeDurationLbl: UILabel!
    @IBOutlet var carNameLbl: UILabel!
    @IBOutlet var circleView: UIView!
    var animationEnable = Bool()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code\
        self.carNameLbl.config(color:TEXT_TERTIARY_COLOR , size: 14, align: .center, text: EMPTY_STRING)
        self.timeDurationLbl.config(color:TEXT_TERTIARY_COLOR , size: 12, align: .center, text: EMPTY_STRING)
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.carNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeDurationLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.carNameLbl.transform = .identity
            self.timeDurationLbl.transform = .identity
        }
    }
    func configCell(taxiDict:NSDictionary)  {
            //setup design
            self.carImgView.frame = CGRect.init(x: 8, y: 8, width: 55, height: 55)
            self.circleView.frame = CGRect.init(x: 25, y: 6, width: 70, height: 70)
            self.circleView.cornerViewRadius()
            self.circleView.setViewBorder(color: SEPARTOR_COLOR)
            self.carImgView.makeItRound()
            self.circleView.backgroundColor = .white
            //set values
            self.carNameLbl.text = taxiDict.value(forKey: "category_name") as? String
            self.timeDurationLbl.text = taxiDict.value(forKey: "reach_pickup") as? String
            self.carImgView.sd_setImage(with: URL(string:taxiDict.value(forKey: "image") as! String), placeholderImage: #imageLiteral(resourceName: "default_car"))
        let availablilty = taxiDict.value(forKey: "available") as! NSString
      
        let image:UIImage = self.carImgView.image!

        if availablilty.isEqual(to: "0") {
            self.carImgView.image = image.withGrayscale
            self.carNameLbl.textColor = TEXT_TERTIARY_COLOR
            self.circleView.alpha = 0.7
        }else{
            self.carImgView.image = image
            self.carNameLbl.textColor = TEXT_SECONDARY_COLOR
            self.circleView.alpha = 1
        }
        
    }
    
    func configSelectedCell(taxiDict:NSDictionary)  {
        if animationEnable {
        self.carImgView.frame = CGRect.init(x: -20, y: 8, width: 65, height: 65)
        UIView.animate( withDuration: 1.5, delay: 0.0,usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0,options: UIViewAnimationOptions(),animations: {
            self.setDetails(taxiDict: taxiDict)
        },   completion: nil)
        }else{
            self.setDetails(taxiDict: taxiDict)
        }

    }
    
    func setDetails(taxiDict:NSDictionary)  {
        //setup design
        self.circleView.backgroundColor = PRIMARY_COLOR
        self.circleView.setViewBorder(color: PRIMARY_COLOR)
        self.carImgView.frame = CGRect.init(x: 8, y: 8, width: 65, height: 65)
        self.circleView.frame = CGRect.init(x: 21, y: 4, width: 80, height: 80)
        self.circleView.cornerViewRadius()
        self.carImgView.makeItRound()
        //set values
        self.carImgView.sd_setImage(with: URL(string:taxiDict.value(forKey: "image") as! String), placeholderImage: #imageLiteral(resourceName: "default_car"))
        self.carNameLbl.text = taxiDict.value(forKey: "category_name") as? String
        self.timeDurationLbl.text = taxiDict.value(forKey: "reach_pickup") as? String
        let availablilty = taxiDict.value(forKey: "available") as! NSString
        self.carNameLbl.textColor = TEXT_SECONDARY_COLOR
        
    }

}
