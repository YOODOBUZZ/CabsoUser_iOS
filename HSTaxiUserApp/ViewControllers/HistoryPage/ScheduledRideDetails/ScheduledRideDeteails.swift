//
//  ScheduledRideDeteails.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 26/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import CoreLocation

class ScheduledRideDeteails: UIViewController {
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var mapImgView: UIImageView!
    @IBOutlet var cancelledView: UIView!
    @IBOutlet var cancelLbl: UILabel!
    
    @IBOutlet var categoryImgView: UIImageView!
    @IBOutlet var categoryNameLbl: UILabel!
    @IBOutlet var dropTF: FloatLabelTextField!
    @IBOutlet var pickupTF: FloatLabelTextField!
    @IBOutlet var pickupTimeLbl: UILabel!
    @IBOutlet var dropTimeLbl: UILabel!
    @IBOutlet var greenDot: UIView!
    @IBOutlet var redDot: UIView!
    @IBOutlet var dotLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var approxAmtLbl: UILabel!
    @IBOutlet var approxLbl: UILabel!
    @IBOutlet var billDetails: UILabel!
    var dropCoordination = CLLocationCoordinate2D()
    var pickCoordination = CLLocationCoordinate2D()
    
    var type = String()
    var onride_id = String()
    var rideDetails = NSDictionary()
    var historyDict = NSDictionary()
    var cancelEnable = Bool()
    var rideStatus = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.textAlignment = .right
            self.mapImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.cancelLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoryImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoryNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoryNameLbl.textAlignment = .right
            self.dropTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dropTF.textAlignment = .right
            self.pickupTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.pickupTF.textAlignment = .right
            self.pickupTimeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.pickupTimeLbl.textAlignment = .right
            self.dropTimeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dropTimeLbl.textAlignment = .right
            self.cancelBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.approxAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.approxAmtLbl.textAlignment = .left
            self.approxLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.approxLbl.textAlignment = .right
            self.billDetails.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.billDetails.textAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.timeLbl.transform = .identity
            self.timeLbl.textAlignment = .left
            self.mapImgView.transform = .identity
            self.cancelLbl.transform = .identity
            self.categoryImgView.transform = .identity
            self.categoryNameLbl.transform = .identity
            self.categoryNameLbl.textAlignment = .left
            self.dropTF.transform = .identity
            self.dropTF.textAlignment = .left
            self.pickupTF.transform = .identity
            self.pickupTF.textAlignment = .left
            self.pickupTimeLbl.transform = .identity
            self.pickupTimeLbl.textAlignment = .left
            self.dropTimeLbl.transform = .identity
            self.dropTimeLbl.textAlignment = .left
            self.cancelBtn.transform = .identity
            self.approxAmtLbl.transform = .identity
            self.approxAmtLbl.textAlignment = .right
            self.approxLbl.transform = .identity
            self.approxLbl.textAlignment = .left
            self.billDetails.transform = .identity
            self.billDetails.textAlignment = .left
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:initial setup
    func setupInitialDetails()   {
        rideStatus = self.historyDict.value(forKey: "ride_status") as! String
        HPLActivityHUD.showActivity(with: .withMask)
        self.getRideDetailsFromServer()
        self.navigationView.elevationEffect()
        self.cancelEnable = false
        self.timeLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: EMPTY_STRING)
        self.categoryImgView.makeItRound()
        self.categoryNameLbl.config(color: TEXT_PRIMARY_COLOR, size: 16, align: .left, text: EMPTY_STRING)
        self.pickupTF.config(color: TEXT_PRIMARY_COLOR, size: 13, align: .left, placeHolder: "pickup")
        self.dropTF.config(color: TEXT_PRIMARY_COLOR, size: 13, align: .left, placeHolder: "drop")
        self.pickupTimeLbl.config(color: TEXT_PRIMARY_COLOR, size: 10, align: .left, text: EMPTY_STRING)
        self.dropTimeLbl.config(color: TEXT_PRIMARY_COLOR, size: 10, align: .left, text: EMPTY_STRING)
        self.redDot.cornerViewRadius()
        self.greenDot.cornerViewRadius()
        self.redDot.backgroundColor = RED_COLOR
        self.greenDot.backgroundColor = GREEN_COLOR
        Utility.shared.drawDottedLine(start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: self.dotLbl.frame.size.height), label: self.dotLbl)
        
        self.cancelLbl.config(color: RED_COLOR, size: 10, align: .center, text: "cancelled")
        self.cancelBtn.backgroundColor = PRIMARY_COLOR
        self.cancelBtn.cornerMiniumRadius()
        self.cancelBtn.config(color: .white, size: 17, align: .center, title: "cancel_ride")
        self.billDetails.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "bill_details")
        self.approxLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: "approx_ride_fare")
        self.approxAmtLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)

    }
    
    func setRideDetails(rideDict:NSDictionary)  {
        let drop_lat:Double =  Utility.shared.convertToDouble(string: rideDict.value(forKey: "drop_lat")as! String)
        let drop_lng:Double = Utility.shared.convertToDouble(string: rideDict.value(forKey: "drop_lng")as! String)
        let pick_lat:Double = Utility.shared.convertToDouble(string: rideDict.value(forKey: "pickup_lat")as! String)
        let pick_lng:Double = Utility.shared.convertToDouble(string: rideDict.value(forKey: "pickup_lng")as! String)
        
        self.pickCoordination = CLLocationCoordinate2D.init(latitude: pick_lat, longitude: pick_lng)
        self.dropCoordination = CLLocationCoordinate2D.init(latitude: drop_lat, longitude: drop_lng)
        
        mapImgView.sd_setImage(with: URL(string:"https://maps.googleapis.com/maps/api/staticmap?center=\(pick_lat),\(pick_lng)&zoom=16&key=\(GOOGLE_API_KEY)&size=400x200&sensor=false&maptype=roadmap&markers=color:red%7Clabel:S%7C\(pick_lat),\(pick_lng)"), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
        
        categoryImgView.sd_setImage(with: URL(string:rideDict.value(forKey: "category_image") as! String), placeholderImage:#imageLiteral(resourceName: "default_car"))
        
        let pickup_time = (historyDict.value(forKey: "pickup_time") as AnyObject).doubleValue//time stamp
        self.timeLbl.text = Utility.shared.timeStamp(stamp: pickup_time!, format: "EEE, MMM d, yyyy, h:mm a")
        
        self.categoryNameLbl.text = historyDict.value(forKey: "category_name") as? String
        if rideDict.value(forKey: "approx_price") != nil {
            let approxAmt:NSNumber = rideDict.value(forKey: "approx_price") as! NSNumber
            self.approxAmtLbl.text = "\(Utility().currency()!) \(approxAmt)"
        }

        self.pickupTimeLbl.text = Utility.shared.timeStamp(stamp: pickup_time!, format: "h:mm a")
        self.dropTimeLbl.text  = EMPTY_STRING
        self.pickupTF.text = rideDict.value(forKey: "pickup_location") as? String
        self.dropTF.text = rideDict.value(forKey: "drop_location") as? String
        
        if  rideStatus == "cancelled" || rideStatus == "scheduleridenotaccepted" {
            self.cancelledView.isHidden = false
            self.bottomView.isHidden = true
        }else {
            self.cancelledView.isHidden = true
            self.bottomView.isHidden = false
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getRideDetailsFromServer()  {
        let rideObj =  RideServices()
        rideObj.getRideDetails(onride_id: self.onride_id, type: self.rideStatus, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
            self.setRideDetails(rideDict: response)
            }
        })
    }
  
    @IBAction func cancelBtnTapped(_ sender: Any) {
        AJAlertController.initialization().showAlert(aStrMessage: "cancel_ride_alert", aCancelBtnTitle: "cancel", aOtherBtnTitle: "okay", status: "", completion: { (index, title) in
            print(index,title)
            if index == 1{
                //logout action
                HPLActivityHUD.showActivity(with: .withMask)
                let rideObj = RideServices()
                rideObj.cancelRide(onride_id: self.onride_id, onSuccess: {response in
                    HPLActivityHUD.dismiss()
                    let status:NSString = response.value(forKey: "status") as! NSString
                    if status.isEqual(to: STATUS_TRUE){
                        self.cancelledView.isHidden = false
                        self.bottomView.isHidden = true
                    }
                })
            }
        })
    }
    
}
