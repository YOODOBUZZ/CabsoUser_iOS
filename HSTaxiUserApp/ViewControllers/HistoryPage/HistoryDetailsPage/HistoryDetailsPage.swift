//
//  HistoryDetailsPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 25/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import CoreLocation
import Cosmos
import AVFoundation
import CoreFoundation

class HistoryDetailsPage: UIViewController {

    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var vehicleNoLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var mapImgView: UIImageView!
    @IBOutlet var driverImgView: UIImageView!
    @IBOutlet var driverNameLbl: UILabel!
    @IBOutlet var reviewView: UIView!
    @IBOutlet var ratingLbl: UILabel!
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var writeReviewBtn: UIButton!
    @IBOutlet var paymentBtn: UIButton!

    @IBOutlet var categoryImgView: UIImageView!
    @IBOutlet var categoryNameLbl: UILabel!
    @IBOutlet var meterPriceLbl: UILabel!
    @IBOutlet var dropTF: FloatLabelTextField!
    @IBOutlet var pickupTF: FloatLabelTextField!
    @IBOutlet var pickupTimeLbl: UILabel!
    @IBOutlet var dropTimeLbl: UILabel!
    @IBOutlet var billDetailsLbl: UILabel!
    @IBOutlet var rideInfoView: UIView!
    @IBOutlet var billInfoView: UIView!
    @IBOutlet var paymentInfoView: UIView!
    @IBOutlet var greenDot: UIView!
    @IBOutlet var redDot: UIView!
    @IBOutlet var dotLbl: UILabel!
    @IBOutlet var rideFareLbl: UILabel!
    @IBOutlet var taxLbl: UILabel!
    @IBOutlet var taxAmtLbl: UILabel!
    @IBOutlet var totalAmtLbl: UILabel!
    @IBOutlet var rideFareAmtLbl: UILabel!
    @IBOutlet var totalBillLbl: UILabel!
    @IBOutlet var paymentLbl: UILabel!
    @IBOutlet var paymentTypeLbl: UILabel!
    @IBOutlet var paymentAmtLbl: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var rideAgainBtn: UIButton!
    
    @IBOutlet var rideAgainView: UIView!
    var dropCoordination = CLLocationCoordinate2D()
    var pickCoordination = CLLocationCoordinate2D()
    var type = String()
    var onride_id = String()
    var rideDetails = NSDictionary()
    var historyDict = NSDictionary()
    var cancelEnable = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupInitialDetails()
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeLbl.textAlignment = .right
            self.vehicleNoLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.vehicleNoLbl.textAlignment = .right
            self.mapImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.driverImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.driverNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.driverNameLbl.textAlignment = .right
            self.ratingLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.ratingLbl.textAlignment = .right
            self.writeReviewBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.writeReviewBtn.contentHorizontalAlignment = .left
            self.paymentBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentBtn.contentHorizontalAlignment = .left
            self.categoryImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoryNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoryNameLbl.textAlignment = .right
            self.meterPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.meterPriceLbl.textAlignment = .right
            self.dropTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dropTF.textAlignment = .right
            self.pickupTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.pickupTF.textAlignment = .right
            self.pickupTimeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.pickupTimeLbl.textAlignment = .right
            self.dropTimeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.dropTimeLbl.textAlignment = .right
            self.billDetailsLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.billDetailsLbl.textAlignment = .right
            self.rideFareLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideFareLbl.textAlignment = .right
            self.totalBillLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.totalBillLbl.textAlignment = .right
            self.paymentLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentLbl.textAlignment = .right
            self.paymentTypeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentTypeLbl.textAlignment = .right
            self.paymentAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentAmtLbl.textAlignment = .left
            self.totalAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.totalAmtLbl.textAlignment = .left
            self.taxLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.taxLbl.textAlignment = .right
            self.taxAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.taxAmtLbl.textAlignment = .left
            self.rideFareAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideFareAmtLbl.textAlignment = .left
            self.rideAgainBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.timeLbl.transform = .identity
            self.timeLbl.textAlignment = .left
            self.vehicleNoLbl.transform = .identity
            self.vehicleNoLbl.textAlignment = .left
            self.mapImgView.transform = .identity
            self.driverImgView.transform = .identity
            self.driverNameLbl.transform = .identity
            self.driverNameLbl.textAlignment = .left
            self.ratingLbl.transform = .identity
            self.ratingLbl.textAlignment = .left
            self.writeReviewBtn.transform = .identity
            self.writeReviewBtn.contentHorizontalAlignment = .right
            self.paymentBtn.transform = .identity
            self.paymentBtn.contentHorizontalAlignment = .right
            self.categoryImgView.transform = .identity
            self.categoryNameLbl.transform = .identity
            self.categoryNameLbl.textAlignment = .left
            self.meterPriceLbl.transform = .identity
            self.meterPriceLbl.textAlignment = .left
            self.dropTF.transform = .identity
            self.dropTF.textAlignment = .left
            self.pickupTF.transform = .identity
            self.pickupTF.textAlignment = .left
            self.pickupTimeLbl.transform = .identity
            self.pickupTimeLbl.textAlignment = .left
            self.dropTimeLbl.transform = .identity
            self.dropTimeLbl.textAlignment = .left
            self.billDetailsLbl.transform = .identity
            self.billDetailsLbl.textAlignment = .left
            self.rideFareLbl.transform = .identity
            self.rideFareLbl.textAlignment = .left
            self.totalBillLbl.transform = .identity
            self.totalBillLbl.textAlignment = .left
            self.paymentLbl.transform = .identity
            self.paymentLbl.textAlignment = .left
            self.paymentTypeLbl.transform = .identity
            self.paymentTypeLbl.textAlignment = .left
            self.paymentAmtLbl.transform = .identity
            self.paymentAmtLbl.textAlignment = .right
            self.totalAmtLbl.transform = .identity
            self.totalAmtLbl.textAlignment = .right
            self.taxLbl.transform = .identity
            self.taxLbl.textAlignment = .left
            self.taxAmtLbl.transform = .identity
            self.taxAmtLbl.textAlignment = .right
            self.rideFareAmtLbl.transform = .identity
            self.rideFareAmtLbl.textAlignment = .right
            self.rideAgainBtn.transform = .identity
        }
    }
    //MARK:initial setup
    func setupInitialDetails()   {
        HPLActivityHUD.showActivity(with: .withMask)
        self.getPaymentDetails()
        scrollView.contentSize = CGSize.init(width:0 , height: 1220)
        self.navigationView.elevationEffect()
        self.cancelEnable = false
        
        timeLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: EMPTY_STRING)
        vehicleNoLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: EMPTY_STRING)
        
        driverImgView.makeItRound()
        writeReviewBtn.config(color: .orange, size: 13, align: .right, title: "write_review")
        paymentBtn.config(color: RED_COLOR, size: 13, align: .right, title: "payment_pending")

        driverNameLbl.config(color: TEXT_PRIMARY_COLOR, size: 18, align: .left, text: EMPTY_STRING)
        ratingLbl.config(color: TEXT_SECONDARY_COLOR, size: 12, align: .left, text: "you_rated")
        categoryImgView.makeItRound()
        categoryNameLbl.config(color: TEXT_PRIMARY_COLOR, size: 16, align: .left, text: EMPTY_STRING)
        meterPriceLbl.config(color: TEXT_PRIMARY_COLOR, size: 16, align: .left, text: EMPTY_STRING)

        pickupTF.config(color: TEXT_PRIMARY_COLOR, size: 13, align: .left, placeHolder: "pickup")
        dropTF.config(color: TEXT_PRIMARY_COLOR, size: 13, align: .left, placeHolder: "drop")
        pickupTimeLbl.config(color: TEXT_PRIMARY_COLOR, size: 10, align: .left, text: EMPTY_STRING)
        dropTimeLbl.config(color: TEXT_PRIMARY_COLOR, size: 10, align: .left, text: EMPTY_STRING)
        redDot.cornerViewRadius()
        greenDot.cornerViewRadius()
        redDot.backgroundColor = RED_COLOR
        greenDot.backgroundColor = GREEN_COLOR
        Utility.shared.drawDottedLine(start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: self.dotLbl.frame.size.height), label: self.dotLbl)

        billDetailsLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "bill_details")
        paymentLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "payment")
      
        rideFareLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .left, text: "ride_fare")
        taxLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .left, text: "tax")
        totalBillLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .left, text: "total_bill")
        paymentTypeLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .left, text: EMPTY_STRING)
        
        rideFareAmtLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        taxAmtLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        totalAmtLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        paymentAmtLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)

        rideAgainBtn.backgroundColor = PRIMARY_COLOR
        rideAgainBtn.cornerMiniumRadius()
        if IS_IPHONE_X {
            let adjustFrame = rideAgainBtn.frame
            rideAgainBtn.frame = CGRect.init(x: adjustFrame.origin.x, y: adjustFrame.origin.y-10, width: adjustFrame.size.width, height: adjustFrame.size.height)
        }
    }
    
    func setRideDetails(rideDict:NSDictionary)  {
        let drop_lat:Double =  Utility.shared.convertToDouble(string: rideDict.value(forKey: "drop_lat")as! String)
        let drop_lng:Double = Utility.shared.convertToDouble(string: rideDict.value(forKey: "drop_lng")as! String)
        let pick_lat:Double = Utility.shared.convertToDouble(string: rideDict.value(forKey: "pickup_lat")as! String)
        let pick_lng:Double = Utility.shared.convertToDouble(string: rideDict.value(forKey: "pickup_lng")as! String)
        
        self.pickCoordination = CLLocationCoordinate2D.init(latitude: pick_lat, longitude: pick_lng)
        self.dropCoordination = CLLocationCoordinate2D.init(latitude: drop_lat, longitude: drop_lng)
        print("URL : https://maps.googleapis.com/maps/api/staticmap?center=\(pick_lat),\(pick_lng)&zoom=16&key=\(GOOGLE_API_KEY)&size=400x200&sensor=false&maptype=roadmap&markers=color:red%7Clabel:S%7C\(pick_lat),\(pick_lng)")
        mapImgView.sd_setImage(with: URL(string:"https://maps.googleapis.com/maps/api/staticmap?center=\(pick_lat),\(pick_lng)&zoom=16&key=\(GOOGLE_API_KEY)&size=400x200&sensor=false&maptype=roadmap&markers=color:red%7Clabel:S%7C\(pick_lat),\(pick_lng)"), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))

//        self.getPolylineRoute()
        driverImgView.sd_setImage(with: URL(string:rideDict.value(forKey: "driver_image") as! String), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
        categoryImgView.sd_setImage(with: URL(string:rideDict.value(forKey: "category_image") as! String), placeholderImage: #imageLiteral(resourceName: "default_car"))

        let createdDate = (historyDict.value(forKey: "pickup_time") as AnyObject).doubleValue//time stamp
     
        self.timeLbl.text =  Utility.shared.timeStamp(stamp: createdDate!, format: "EEE, MMM d, yyyy, h:mm a")
        
        self.vehicleNoLbl.text = rideDict.value(forKey: "vehicle_no") as? String
        self.driverNameLbl.text = rideDict.value(forKey: "driver_name") as? String
        self.categoryNameLbl.text = historyDict.value(forKey: "category_name") as? String
        
        let rideFare:NSNumber = rideDict.value(forKey: "ride_fare") as! NSNumber
        let tax:NSNumber = rideDict.value(forKey: "ride_tax") as! NSNumber
        let totalAmt:NSNumber = rideDict.value(forKey: "ride_total") as! NSNumber
        let km:CGFloat = rideDict.value(forKey: "distance") as! CGFloat
        self.meterPriceLbl.text = "\(km) km"
        let pickupTime = (rideDict.value(forKey: "pickup_time") as AnyObject).doubleValue
        self.pickupTimeLbl.text = Utility.shared.timeStamp(stamp: pickupTime!, format: "h:mm a")
        let dropTime = (rideDict.value(forKey: "drop_time") as AnyObject).doubleValue
        self.dropTimeLbl.text  = Utility.shared.timeStamp(stamp: dropTime!, format: "h:mm a")
        self.pickupTF.text = rideDict.value(forKey: "pickup_location") as? String
        self.dropTF.text = rideDict.value(forKey: "drop_location") as? String
        self.rideFareAmtLbl.text = "\(Utility().currency()!) \(rideFare)"
        self.taxAmtLbl.text = "\(Utility().currency()!) \(tax)"
        self.totalAmtLbl.text = "\(Utility().currency()!) \(totalAmt)"
        self.paymentTypeLbl.text = rideDict.value(forKey: "payment_type") as? String
        self.paymentAmtLbl.text = "\(Utility().currency()!) \(totalAmt)"
        
        let reviewStatus = rideDict.value(forKey: "isreview") as? String
        if  reviewStatus == "false"{
            self.writeReviewBtn.isHidden = false
            type = "0"
            self.reviewView.isHidden = true
        }else if reviewStatus == "true"{
            self.writeReviewBtn.isHidden = true
            type = "1"
            self.reviewView.isHidden = false
            self.configRatingView()
        }
        let paymentStatus = rideDict.value(forKey: "ispayment") as? String
        if  paymentStatus == "false"{
            paymentBtn.isUserInteractionEnabled = true
            paymentBtn.config(color: RED_COLOR, size: 13, align: .right, title: "payment_pending")
        }else if paymentStatus == "true"{
            paymentBtn.isUserInteractionEnabled = false
            paymentBtn.config(color: GREEN_COLOR, size: 13, align: .right, title: "payment_completed")
        }
        rideAgainBtn.config(color: .white, size: 17, align: .center, title: "ride_again")
      
    }
    
    func configRatingView()  {
        let rating:Int
        if (self.isNsnullOrNil(object: self.rideDetails.value(forKey: "rating") as AnyObject)){
            rating = 0
        }else{
            rating = self.rideDetails.value(forKey: "rating") as! Int
        }
        self.ratingView.rating = Double.init(rating)
        self.ratingView.settings.starSize = 18
        //set fill color
        self.ratingView.settings.filledColor = UIColor.orange
        self.ratingView.settings.filledBorderColor = UIColor.orange
        //set empty color
        self.ratingView.settings.emptyBorderColor = .lightGray
        self.ratingView.settings.emptyColor = .lightGray
        //disable rating touch
        self.ratingView.settings.updateOnTouch = false
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reviewBtnTapped(_ sender: Any) {
        let reviewObj = WriteReview()
        reviewObj.viewType = self.type
        reviewObj.viewFrom = "history"
        reviewObj.onride_id = self.onride_id
        reviewObj.modalPresentationStyle = .fullScreen
        self.present(reviewObj, animated: true, completion: nil)
    }
    
    @IBAction func paymentBtnTapped(_ sender: Any) {
        let paymentObj = RideCompletedPage()
        paymentObj.onride_id = self.onride_id
        paymentObj.modalPresentationStyle = .fullScreen
        self.present(paymentObj, animated: true, completion: nil)
    }
    
    @IBAction func rideBtnTapped(_ sender: Any) {
        let rideObj = RideNavigationPage()
        rideObj.pickUpCoordination = self.pickCoordination
        rideObj.dropCoordination = self.dropCoordination
        rideObj.dropLocation = self.dropTF.text!
        rideObj.pickupLocation = self.pickupTF.text!
        rideObj.modalPresentationStyle = .fullScreen
        self.present(rideObj, animated: true, completion: nil)
    }
    
    @IBAction func editReviewBtnTapped(_ sender: Any) {
        let reviewObj = WriteReview()
        reviewObj.viewType = self.type
        reviewObj.viewFrom = "history"
        reviewObj.onride_id = self.onride_id
        reviewObj.review_msg = self.rideDetails.value(forKey: "review_message") as? String ?? ""
        let rating:Int
        if (self.isNsnullOrNil(object: self.rideDetails.value(forKey: "rating") as AnyObject)){
            rating = 0
        }else{
            rating = self.rideDetails.value(forKey: "rating") as! Int
        }
        reviewObj.review_Rating = rating
        reviewObj.modalPresentationStyle = .fullScreen
        self.present(reviewObj, animated: true, completion: nil)
    }
    //get payment details
    func getPaymentDetails(){
        let paymentInfo = RideServices()
        paymentInfo.getCompletedRideDetails(onride_id: self.onride_id, onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
             HPLActivityHUD.dismiss()
             self.rideDetails = response
             self.setRideDetails(rideDict: response)
            }else{
                Utility.shared.showAlert(msg: response.value(forKey: "message") as! String, status: "")
            }
        })
    }

    
    //get location details from google api
    func getPolylineRoute(){
        let getLocationObj = GoogleLocationService()
        getLocationObj.getLocation(destinationCoordination: self.dropCoordination, pickupCoordination: self.pickCoordination, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:String = response.value(forKey: "status") as! String
            if status == "OVER_QUERY_LIMIT"{
                self.getPolylineRoute()
            }else  if status == "ZERO_RESULTS"{
            }else{
                self.drawRoute(routesArray: response.value(forKey:"routes") as! NSArray)
            }
        }, onFailure: {errorResponse in
        })
    }
    func drawRoute(routesArray: NSArray) {
        if (routesArray.count > 0)
        {
            let routeDict = routesArray[0] as! Dictionary<String, Any>
            let routeOverviewPolyline = routeDict["overview_polyline"] as! Dictionary<String, Any>
            let points = routeOverviewPolyline["points"]
            print("points \(String(describing: points))")
            
            mapImgView.sd_setImage(with: URL(string:"https://maps.googleapis.com/maps/api/staticmap?size=600x400&path=\(String(describing: points))&key=\(GOOGLE_API_KEY)"), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
            print(" url image https://maps.googleapis.com/maps/api/staticmap?size=600x400&path=\(String(describing: points))&key=\(GOOGLE_API_KEY)")

        }
    }
    func getTime(createdDate:Double) -> String {
        let dateNew = Date(timeIntervalSince1970:createdDate)
        print("date \(dateNew)")
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormat.locale = NSLocale.current
        dateFormat.dateFormat = "h:mm a"
        return dateFormat.string(from: dateNew)
    }
    
    func isNsnullOrNil(object : AnyObject?) -> Bool
    {
        if (object is NSNull) || (object == nil)
        {
            return true
        }
        else
        {
            return false
        }
    }
}


