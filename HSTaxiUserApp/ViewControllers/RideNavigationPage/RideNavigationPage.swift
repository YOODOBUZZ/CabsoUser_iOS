//
//  RideNavigationPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 19/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import Alamofire
import NVActivityIndicatorView


class RideNavigationPage: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {
    
    var lastDriverAngleFromNorth = CLLocationDirection()
    var mapBearing = CLLocationDirection()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    var carsMarker = GMSMarker()
    var carMarkerArray = NSMutableArray()
    var carMarkerID = NSMutableArray()
    var routeArray = NSArray()
    var checkForReview = Bool()
    var refreshFlag = Bool()
    var socketEnable = Bool()
    var enableCarList = Bool()
    var carBearing = Float()
    let cameraPostion = GMSCameraPosition()
    var locationManager = CLLocationManager()
    var selectedIndexPath : IndexPath?
    var pickupLocation = String()
    var dropLocation = String()
    var paymentType = String()
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var pickUpCoordination = CLLocationCoordinate2D()
    var dropCoordination = CLLocationCoordinate2D()
    var onride_id = String()
    var basePrice = String()
    var category_id = String()
    var carListArray = NSMutableArray()
    let rideObj = RideServices()
    var currentView = String()
    var trigger = Timer()
    var socketCron = Timer()
    var carsCron = Timer()
    var grabCron = Timer()
    var polyLineCron = Timer()
    
    var grabEnable = Bool()
    var drawOnce = Bool()
    var moveCamera = Bool()
    var animationEnable = Bool()
    var phoneNo = String()
    var timeDuration = String()
    let dateFormatter = DateFormatter()
    var currentDate = Date()
    var scheduleInterval = TimeInterval()
    var scheduleEnable = Bool()
    var driverDetailsFlag = Bool()
    var viewType = String()
    var historyDict = NSDictionary()
    var stopEnable : Bool = false
    let markerDriver = GMSMarker()
    var rideCoordination = CLLocationCoordinate2D()
    var searchCount = Int()
    var alertEnable = Bool()
    var rideDict = NSDictionary()
    var driverDict = NSDictionary()
    
    
    @IBOutlet var approxPriceLbl: UILabel!
    @IBOutlet var carlistCollectionView: UICollectionView!
    @IBOutlet var backBtnContainerView: UIView!
    @IBOutlet var timepickBtn: UIButton!
    @IBOutlet var rideBtn: UIButton!
    @IBOutlet var carListContainerView: UIView!
    @IBOutlet var no_lbl: UILabel!
    @IBOutlet var bottomContainerView: UIView!
    @IBOutlet var no_resultView: UIView!
    @IBOutlet var ridePriceLbl: UILabel!
    @IBOutlet var paymenttypeLbl: UILabel!
    @IBOutlet var codLbl: UILabel!
    @IBOutlet var creditCardLbl: UILabel!
    @IBOutlet var cardSelectImgView: UIImageView!
    @IBOutlet var cashSelectImgView: UIImageView!
    @IBOutlet var confirmRideBtn: UIButton!
    @IBOutlet var paymentView: UIView!
    @IBOutlet var approxPriceDriverLbl: UILabel!
    @IBOutlet var timeKmLbl: UILabel!
    @IBOutlet var driverProfilePicImgView: UIImageView!
    @IBOutlet var driverNameLbl: UILabel!
    @IBOutlet var categoryNameLbl: UILabel!
    @IBOutlet var taxiNoLbl: UILabel!
    @IBOutlet var otpLbl: UILabel!
    @IBOutlet var ratingLbl: UILabel!
    @IBOutlet var callBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var driverDetailsView: UIView!
    @IBOutlet var findingImgView: UIImageView!
    @IBOutlet var findingLbl: UILabel!
    @IBOutlet var findingView: UIView!
    @IBOutlet var findingBottomView: UIView!
    @IBOutlet var sosAlertBtn: UIButton!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var datePickerView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var dateOkBtn: UIButton!
    @IBOutlet var noImgView: UIImageView!
    
    @IBOutlet var makeCarLbl: UILabel!
    @IBOutlet var modelCarLbl: UILabel!
    @IBOutlet var colorCarLbl: UILabel!
    @IBOutlet var makeCarView: UIView!
    @IBOutlet var modelCarView: UIView!
    @IBOutlet var colorCarView: UIView!
    var addCarmodel = ""
    var addCarmake = ""
    var addCarcolor = ""

    @IBOutlet weak var dateDismissBtn: UIButton!
    var alertStatus = ""
    
    // Audio Call Addon Enabled or not
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupInitialDetails()
        self.gestureRecognitionForView(makeCarView)
        self.gestureRecognitionForView(modelCarView)
        self.gestureRecognitionForView(colorCarView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.trigger.invalidate()
        self.polyLineCron.invalidate()
        self.grabCron.invalidate()
    }
    override func viewWillAppear(_ animated: Bool) {
        if refreshFlag || !isCallKitEnabled {
            isCallKitEnabled = false
            self.getRideDetails(type: "onride")
        }
        else if isRideComplete {
            isRideComplete = false
            let rideObj = RideCompletedPage()
            rideObj.onride_id = self.onride_id
            rideObj.modalPresentationStyle = .fullScreen
            self.present(rideObj, animated: true, completion: nil)
            self.stopEnable = true
            
        }
        self.changeToRTL()
    }
    
    func gestureRecognitionForView(_ sender: UIView){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        if sender == makeCarView{
            makeCarView.addGestureRecognizer(tap)
        }else if sender == modelCarView{
            modelCarView.addGestureRecognizer(tap)
        }else{
            colorCarView.addGestureRecognizer(tap)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let rateViewController = CarModelPopUp()
        rateViewController.modalTransitionStyle = .crossDissolve
        rateViewController.modalPresentationStyle = .overCurrentContext
        rateViewController.addCarDetails = { [self](_ carmodel: String, _ make: String, _ carcolor: String ) -> Void in
            if make == ""{
                self.makeCarLbl.text = "Make"
                self.addCarmake = make
            }else{
                self.makeCarLbl.text = make
                self.addCarmake = make
            }
            
            if carmodel == ""{
                self.modelCarLbl.text = "Model"
                self.addCarmodel = carmodel
            }else{
                self.modelCarLbl.text = carmodel
                self.addCarmodel = carmodel
            }
            if carcolor == ""{
                self.colorCarLbl.text = "Color"
                self.addCarcolor = carcolor
            }else{
                self.colorCarLbl.text = carcolor
                self.addCarcolor = carcolor
            }
        }
        self.present(rateViewController, animated: true, completion: nil)
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.approxPriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.no_lbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.ridePriceLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymenttypeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymenttypeLbl.textAlignment = .right
            self.codLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.codLbl.textAlignment = .right
            self.creditCardLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.creditCardLbl.textAlignment = .right
            self.cardSelectImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.cashSelectImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.confirmRideBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.approxPriceDriverLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.approxPriceDriverLbl.textAlignment = .right
            self.timeKmLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.timeKmLbl.textAlignment = .left
            self.driverProfilePicImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.driverNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.driverNameLbl.textAlignment = .right
            self.categoryNameLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.categoryNameLbl.textAlignment = .left
            self.taxiNoLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.taxiNoLbl.textAlignment = .left
            self.otpLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.ratingLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.ratingLbl.textAlignment = .right
            self.callBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.cancelBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.findingImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.findingLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.findingLbl.textAlignment = .right
            self.sosAlertBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.sosAlertBtn.contentHorizontalAlignment = .left
            self.dateOkBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.mapView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.datePicker.transform = CGAffineTransform(scaleX: -1, y: 1)
            //            self.mapView.semanticContentAttribute = .forceRightToLeft
        }
        else {
            self.view.transform = .identity
            self.datePicker.transform = .identity
            self.approxPriceLbl.transform = .identity
            self.rideBtn.transform = .identity
            self.no_lbl.transform = .identity
            self.ridePriceLbl.transform = .identity
            self.paymenttypeLbl.transform = .identity
            self.paymenttypeLbl.textAlignment = .left
            self.codLbl.transform = .identity
            self.codLbl.textAlignment = .left
            self.creditCardLbl.transform = .identity
            self.creditCardLbl.textAlignment = .left
            self.cardSelectImgView.transform = .identity
            self.cashSelectImgView.transform = .identity
            self.confirmRideBtn.transform = .identity
            self.approxPriceDriverLbl.transform = .identity
            self.approxPriceDriverLbl.textAlignment = .left
            self.timeKmLbl.transform = .identity
            self.timeKmLbl.textAlignment = .right
            self.driverProfilePicImgView.transform = .identity
            self.driverNameLbl.transform = .identity
            self.driverNameLbl.textAlignment = .left
            self.categoryNameLbl.transform = .identity
            self.categoryNameLbl.textAlignment = .right
            self.taxiNoLbl.transform = .identity
            self.taxiNoLbl.textAlignment = .right
            self.otpLbl.transform = .identity
            self.ratingLbl.transform = .identity
            self.ratingLbl.textAlignment = .left
            self.callBtn.transform = .identity
            self.cancelBtn.transform = .identity
            self.findingImgView.transform = .identity
            self.findingLbl.transform = .identity
            self.findingLbl.textAlignment = .left
            self.sosAlertBtn.transform = .identity
            self.sosAlertBtn.contentHorizontalAlignment = .right
            self.dateOkBtn.transform = .identity
            self.mapView.transform = .identity
            self.mapView.semanticContentAttribute = .forceLeftToRight
            
        }
    }
    //MARK: Initial set up
    func setupInitialDetails()  {
        self.connectSocket()
        socketEnable = false
        self.checkForReview = false
        self.enableCarList = false
        self.animationEnable = true
        socketEnable = false
        self.drawOnce = false
        self.moveCamera = false
        self.addAnimationLayer()
        self.configureGoogleMaps(height: FULL_HEIGHT)
        self.grabEnable = false
        self.view.bringSubview(toFront: self.backBtnContainerView)
        self.navigationView.isHidden = true
        self.scheduleEnable = false
        self.alertEnable = true
        self.driverDetailsFlag = false
        refreshFlag = false
        //config car collection view
        carlistCollectionView.register(UINib(nibName: "TaxiCell", bundle: nil), forCellWithReuseIdentifier: "TaxiCell")
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        carlistCollectionView.collectionViewLayout = collectionViewFlowLayout
        carlistCollectionView.isPagingEnabled = true
        carlistCollectionView.isScrollEnabled = true
        carlistCollectionView.allowsMultipleSelection = false
        
        //setup approximatelbl
        self.approxPriceLbl.config(color: .white, size: 15, align: .center, text: EMPTY_STRING)
        self.approxPriceLbl.backgroundColor = GREEN_COLOR
        self.no_lbl.config(color: TEXT_TERTIARY_COLOR, size: 17, align: .center, text: EMPTY_STRING)
        
        //grab rides
        HPLActivityHUD.showActivity(withPosition: CGPoint.init(x: FULL_WIDTH/2, y: FULL_HEIGHT-135))
        
        if self.viewType == "1"{ // view driver details from history page
            self.getRideDetails(type: self.historyDict.value(forKey: "ride_status") as! String)
        }else if self.viewType == "2"{ // emit socket from history page
            self.getRideDetails(type: self.historyDict.value(forKey: "ride_status") as! String)
            self.socketCron = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.socketEmitMethods), userInfo: nil, repeats: true)
        }else{
            self.getPolylineRoute()
            self.getDistance(type: "new")
            // self.availableCarsOntheMap()
        }
        //ride btn
        self.rideBtn.config(color: .white, size: 17, align: .center, title: "ride_now")
        self.rideBtn.backgroundColor = PRIMARY_COLOR
        self.rideBtn.cornerMiniumRadius()
        self.timepickBtn.cornerMiniumRadius()
        self.timepickBtn.setBorder(color:PRIMARY_COLOR)
        self.bottomContainerView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: 330)
        self.configPaymentView()
        self.configDriverDetailsView()
        self.configFindingView()
        
        //sos alert page
        self.navigationView.elevationEffect()
        self.sosAlertBtn.config(color: RED_COLOR, size: 17, align: .right, title: "sosalert")
    }
    
    //setup payment subview
    func configPaymentView()  {
        //confirm ride btn
        self.confirmRideBtn.config(color: .white, size: 17, align: .center, title: "confirm_ride")
        self.confirmRideBtn.backgroundColor = PRIMARY_COLOR
        self.confirmRideBtn.cornerMiniumRadius()
        self.confirmRideBtn.setBorder(color:PRIMARY_COLOR)
        self.codLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: "cash")
        self.creditCardLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: "card")
        self.paymenttypeLbl.config(color: TEXT_TERTIARY_COLOR, size: 14, align: .left, text: "payment_type")
        self.ridePriceLbl.config(color: .white, size: 17, align: .center, text: EMPTY_STRING)
        self.ridePriceLbl.backgroundColor = GREEN_COLOR
        if IS_IPHONE_X {
            let adjustFrame = confirmRideBtn.frame
            confirmRideBtn.frame = CGRect.init(x: adjustFrame.origin.x, y: adjustFrame.origin.y-7, width: adjustFrame.size.width, height: adjustFrame.size.height)
        }
    }
    
    //setup driverdetails subview
    func configDriverDetailsView(){
        self.callBtn.config(color: .white, size: 17, align: .center, title: "call")
        self.cancelBtn.config(color: TEXT_TERTIARY_COLOR, size: 17, align: .center, title: "cancel_ride")
        self.callBtn.cornerMiniumRadius()
        self.callBtn.backgroundColor = PRIMARY_COLOR
        driverProfilePicImgView.makeItRound()
        ratingLbl.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, text: EMPTY_STRING)
        driverNameLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: EMPTY_STRING)
        categoryNameLbl.config(color: TEXT_PRIMARY_COLOR, size: 13, align: .right, text: EMPTY_STRING)
        taxiNoLbl.config(color: TEXT_PRIMARY_COLOR, size: 13, align: .right, text: EMPTY_STRING)
        
        otpLbl.config(color: .white, size: 15, align: .center, text: EMPTY_STRING)
        otpLbl.lblMinimumCornerRadius()
        otpLbl.backgroundColor = .orange
        
        approxPriceDriverLbl.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .left, text: EMPTY_STRING)
        timeKmLbl.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .right, text: EMPTY_STRING)
    }
    //MARK: set up minimum & maximum date for datepicker
    func configDatePicker()  {
        self.animateView(view: self.datePickerView)
        self.dateOkBtn.config(color: .white, size: 17, align: .center, title: "next")
        self.dateDismissBtn.config(color: TEXT_TERTIARY_COLOR, size: 17, align: .center, title: "cancel")
        self.dateOkBtn.backgroundColor = PRIMARY_COLOR
        self.dateOkBtn.cornerMiniumRadius()
        //        self.datePicker.timeZone = TimeZone(abbreviation: "GMT")
        self.datePicker.timeZone = TimeZone.current
        self.datePicker.locale = NSLocale.current
        
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        }
        
        var calendar = Calendar.init(identifier: .gregorian)
        //        calendar.timeZone = TimeZone(identifier: "GMT")!
        calendar.timeZone = TimeZone.current
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.day = +6
        let max = calendar.date(byAdding: components, to: currentDate)!
        self.datePicker.minimumDate = currentDate.addingTimeInterval(15.0 * 60.0) // set min date after 30 min from now
        
        self.datePicker.maximumDate = max
    }
    
    //driver details
    func setDriverDetails(driverDict:NSDictionary)  {
        //        let phoneNo:String = "\(driverDict.value(forKey: "driver_mobile") as! String)"
        self.driverDict = driverDict
        let phoneNo = driverDict.value(forKey: "driver_mobile") as? String ?? "\(driverDict.value(forKey: "driver_mobile") as? NSNumber ?? 0)"
        
        self.phoneNo = String(describing: phoneNo)
        driverProfilePicImgView.sd_setImage(with: URL(string: driverDict.value(forKey: "driver_image") as! String), placeholderImage: #imageLiteral(resourceName: "placeholder_image"))
        let ratingNo:String = driverDict.value(forKey: "driver_rating") as! String
        //        ratingLbl.text = "\(ratingNo)"
        ratingLbl.text = ratingNo
        driverNameLbl.text = driverDict.value(forKey: "driver_name") as? String
        categoryNameLbl.text = driverDict.value(forKey: "driver_vehicle") as? String
        taxiNoLbl.text = driverDict.value(forKey: "driver_vehicleno") as? String
        let otp:String = driverDict.value(forKey: "onride_otp") as! String
        otpLbl.text = "OTP: \(otp)"
        approxPriceDriverLbl.text = self.approxPriceLbl.text
    }
    
    //set up finding view
    func configFindingView()  {
        self.findingLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: "finding_driver")
        self.findingImgView.image = #imageLiteral(resourceName: "search_icon")
        let indicatorView = NVActivityIndicatorView.init(frame: CGRect(x:FULL_WIDTH - 100,y:22,width:25,height:11), type: NVActivityIndicatorType.ballPulse, color: PRIMARY_COLOR, padding: 30)
        indicatorView.startAnimating()
        findingBottomView.addSubview(indicatorView)
    }
    
    //socket function
    //MARK: Socket emit actions
    @objc func socketEmitMethods()  {
        let requestDict = NSMutableDictionary()
        requestDict.setValue(self.onride_id, forKey: "onride_id")
        socket.defaultSocket.emit("whereareyou", requestDict)
        self.socketOnMethods()
    }
    //MARK: Socket on actions
    func socketOnMethods()  {
        socket.defaultSocket.on("iamhere") { ( data, ack) -> Void in
            let locationArray = NSMutableArray()
            locationArray.addObjects(from: data)
            let locationDict :NSDictionary = locationArray.object(at: 0) as! NSDictionary
            let lat:Double = Utility.shared.convertToDouble(string: locationDict.value(forKey: "instant_lan") as! String)
            let lng:Double = Utility.shared.convertToDouble(string: locationDict.value(forKey: "instant_lng") as! String)
            
            self.markerDriver.icon = #imageLiteral(resourceName: "carIcon")
            self.rideCoordination = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
            
            //move smoothly
            let oldlat = Double(self.markerDriver.position.latitude)
            let oldlong = Double(self.markerDriver.position.longitude)
            let old = CLLocationCoordinate2D(latitude: oldlat , longitude: oldlong )
            let new = CLLocationCoordinate2D(latitude:lat , longitude: lng)
            let calBearing: Float = self.getHeadingForDirection(fromCoordinate: old, toCoordinate: new)
            self.markerDriver.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            if calBearing != 0{
                self.markerDriver.rotation = CLLocationDegrees(calBearing);
            }//found bearing value by calculation when marker add
            self.markerDriver.position = old; //this can be old position to make car movement to new position
            //marker movement animation
            CATransaction.begin()
            CATransaction.setValue(3.0, forKey: kCATransactionAnimationDuration)
            CATransaction.setCompletionBlock({() -> Void in
                if calBearing != 0{
                    self.markerDriver.rotation =  CLLocationDegrees(calBearing)
                }
                //found bearing value by calculation when marker add
            })
            self.markerDriver.position = new; //this can be new position after car moved from old position to new position with animation
            self.markerDriver.map = self.mapView;
            if calBearing != 0{
                self.markerDriver.rotation = CLLocationDegrees(calBearing);
            }
            CATransaction.commit()
            
            
            //socket status check
            let status:String = locationDict.value(forKey: "ridestatus") as! String
            if status == "cancelled"{
                self.disconnectSocket()
                self.socketCron.invalidate()
                Utility.shared.goToHomePage()
            }else if status == "completed"{
                self.disconnectSocket()
                self.socketCron.invalidate()
                if !self.stopEnable{
                    let rideObj = RideCompletedPage()
                    rideObj.onride_id = self.onride_id
                    rideObj.modalPresentationStyle = .fullScreen
                    self.present(rideObj, animated: true, completion: nil)
                    self.stopEnable = true
                }
            }else if status == "onride"{
                if !self.checkForReview{
                    self.cancelBtn.config(color: GREEN_COLOR, size: 17, align: .center, title: "write_review")
                    self.checkForReview = true
                    self.getRideDetails(type: "onride")
                }
                
            }
        }
    }
    //cancel ride
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        
        let reviewObj = WriteReview()
        reviewObj.viewFrom = "history"
        reviewObj.onride_id = self.onride_id
        
        if  Utility.shared.getLanguage()?.value(forKey: "edit_review")as? String == cancelBtn.titleLabel?.text {
            self.refreshFlag = true
            reviewObj.viewType = "1"
            let rating:Int
            if (self.isNsnullOrNil(object: self.rideDict.value(forKey: "rating") as AnyObject)){
                rating = 0
            }else{
                rating = self.rideDict.value(forKey: "rating") as! Int
            }
            reviewObj.review_msg = self.rideDict.value(forKey: "review_message") as! String
            reviewObj.review_Rating = rating
            reviewObj.modalPresentationStyle = .fullScreen
            self.present(reviewObj, animated: true, completion: nil)
        }else if  Utility.shared.getLanguage()?.value(forKey: "write_review")as? String == cancelBtn.titleLabel?.text {
            self.refreshFlag = true
            reviewObj.viewType = "0"
            reviewObj.modalPresentationStyle = .fullScreen
            self.present(reviewObj, animated: true, completion: nil)
        }else{
            
            AJAlertController.initialization().showAlert(aStrMessage: "cancel_ride_alert", aCancelBtnTitle: "cancel", aOtherBtnTitle: "okay", status: alertStatus, completion: { (index, title) in
                if index == 1{
                    //logout action
                    HPLActivityHUD.showActivity(withPosition: CGPoint.init(x: FULL_WIDTH/2, y: FULL_HEIGHT-135))
                    self.callBtn.isUserInteractionEnabled = false
                    self.rideObj.cancelRide(onride_id: self.onride_id, onSuccess: {response in
                        self.callBtn.isUserInteractionEnabled = true
                        HPLActivityHUD.dismiss()
                        self.closeView()
                    })
                }
            })
        }
    }
    //call to driver
    @IBAction func callBtnTapped(_ sender: Any) {
        if !IS_AUDIOCALL_ENABLED {
            if let url = URL(string: "tel://\(self.phoneNo)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else {
            /*
             // Audio Call Add On
             let pageobj = AudioCallViewController()
             pageobj.receiverId =  (self.driverDict.value(forKey: "driver_userid") as? String ?? "")
             pageobj.senderFlag  = true
             pageobj.call_type = "audio"
             pageobj.driverDict = self.driverDict
             pageobj.modalPresentationStyle = .fullScreen
             self.present(pageobj, animated: true, completion: nil)
             */
        }
    }
    //back btn tapped
    @IBAction func backBtnTapped(_ sender: Any) {
        if alertEnable {
            AJAlertController.initialization().showAlert(aStrMessage: "close_alert", aCancelBtnTitle: "cancel", aOtherBtnTitle: "okay", status: alertStatus, completion: { (index, title) in
                if index == 1{
                    self.closeView()
                }
            })
        }else{
            self.closeView()
        }
    }
    
    //stop & move to home page
    func closeView()  {
        HPLActivityHUD.dismiss()
        UserModel.shared.enableLocationEdit(status: "false")
        self.socketCron.invalidate()
        self.carsCron.invalidate()
        self.grabCron.invalidate()
        self.polyLineCron.invalidate()
        self.disconnectSocket()
        Utility.shared.goToHomePage()
    }
    
    @IBAction func sosAlertBtnTapped(_ sender: Any) {
        let sosAlert = SOSAlertPage()
        sosAlert.myLocation = self.rideCoordination
        sosAlert.modalPresentationStyle = .fullScreen
        self.present(sosAlert, animated: true, completion: nil)
    }
    
    func configureGoogleMaps(height:CGFloat){
        
        let camera = GMSCameraPosition.camera(withLatitude: self.pickUpCoordination.latitude, longitude: self.pickUpCoordination.longitude, zoom: 0.00)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: FULL_WIDTH, height: height), camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets.init(top: 0, left: 0, bottom: 5, right: 5)
        mapView.mapType = .normal
        self.view.addSubview(mapView)
        mapView.delegate = self
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.locationManager.startUpdatingHeading()
        // Set the map style by passing the URL of the local file.
        do {
            if let styleURL = Bundle.main.url(forResource: "mapstyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        self.showLocationTipView()
    }
    
    //MARK: Show marker tip view
    func showLocationTipView()  {
        let markerStart = GMSMarker()
        markerStart.position = CLLocationCoordinate2D(latitude: self.pickUpCoordination.latitude, longitude: self.pickUpCoordination.longitude)
        let markerStartView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 22, height: 45))
        markerStartView.image = #imageLiteral(resourceName: "current_location")
        markerStartView.contentMode = .scaleAspectFit
        markerStart.iconView = markerStartView
        markerStart.map = mapView
        
        let markerEnd = GMSMarker()
        markerEnd.position = CLLocationCoordinate2D(latitude: self.dropCoordination.latitude, longitude: self.dropCoordination.longitude)
        let markerEndView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 22, height: 45))
        markerEndView.image = #imageLiteral(resourceName: "drop_location")
        markerEndView.contentMode = .scaleAspectFit
        markerEnd.iconView = markerEndView
        markerEnd.map = mapView
    }
    
    //MARK: Draw polyline routes
    func drawRoute() {
        
        if (self.routeArray.count > 0)
        {
            if !drawOnce {
                drawOnce = true
                let routeDict = routeArray[0] as! Dictionary<String, Any>
                let routeOverviewPolyline = routeDict["overview_polyline"] as! Dictionary<String, Any>
                let points = routeOverviewPolyline["points"]
                self.path = GMSPath.init(fromEncodedPath: points as! String)!
                self.polyline.path = path
                self.polyline.strokeWidth = 3.0
                self.polyline.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                self.polyline.map = self.mapView
                if !moveCamera{
                    moveCamera = true
                    let mapBounds = GMSCoordinateBounds(path: self.path)
                    let cameraUpdate = GMSCameraUpdate.fit(mapBounds)
                    mapView.moveCamera(cameraUpdate)
                    let bounds = GMSCoordinateBounds(path: path)
                    self.mapView.moveCamera(GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: self.navigationView.frame.height+50, left: 10, bottom: self.paymentView.frame.height+30, right: 10)))
                    self.polyLineCron = Timer.scheduledTimer(timeInterval: 0.015, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
                }
            }
        }
        
    }
    //animate polyline with stroke color
    @objc func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.black
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.mapView
            self.i += 1
        }else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
    //get location details from google api
    func getPolylineRoute(){
        let getLocationObj = GoogleLocationService()
        getLocationObj.getLocation(destinationCoordination: self.dropCoordination, pickupCoordination: self.pickUpCoordination, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:String = response.value(forKey: "status") as! String
            if status == "OVER_QUERY_LIMIT"{
                self.getPolylineRoute()
            }else  if status == "ZERO_RESULTS"{
                self.noImgView.image = #imageLiteral(resourceName: "no_location")
                self.alertEnable = false
                self.no_lbl.text = Utility.shared.getLanguage()?.value(forKey: "location_unavailable") as? String
                self.animateView(view: self.no_resultView)
            }else{
                self.routeArray = response.value(forKey:"routes") as! NSArray
                self.drawRoute()
            }
        }, onFailure: {errorResponse in
        })
    }
    
    //get distance between two coordination from google api
    func getDistance(type:String)  {
        let googleObj = GoogleLocationService()
        googleObj.getDistance(drop: self.dropCoordination, pickup: self.pickUpCoordination, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:String = response.value(forKey: "status") as! String
            if status == "ZERO_RESULTS"{
                self.animateView(view: self.no_resultView)
            }else if status == "                                          "{
                self.getDistance(type: type)
            }else{
                let responseArray:NSArray =  response.value(forKey: "rows") as! NSArray
                let detailsDict:NSDictionary = responseArray.object(at: 0) as! NSDictionary
                let elementsArray:NSArray = detailsDict.value(forKey: "elements") as! NSArray
                let distanceDict:NSDictionary = elementsArray.object(at: 0) as! NSDictionary
                let finalStatus:String = distanceDict.value(forKey: "status") as! String
                if finalStatus == "ZERO_RESULTS" {
                    self.animateView(view: self.no_resultView)
                }else{
                    self.timeKmLbl.text = "\(distanceDict.value(forKeyPath: "duration.text") as! String)(\(distanceDict.value(forKeyPath: "distance.text") as! String))"
                    if type == "new"{
                        self.getAvailableRides(km:distanceDict.value(forKeyPath: "distance.text") as! String)
                    }
                }
            }
        })
    }
    
    @IBAction func rideBtnTapped(_ sender: Any) {
        if self.selectedIndexPath != nil{
            self.currentView = "payment"
            self.bottomContainerView.isHidden = true
            self.animateView(view: self.paymentView)
        }else{
            Utility.shared.showAlert(msg: "select_car", status: alertStatus)
        }
    }
    
    @IBAction func timePickBtnTapped(_ sender: Any) {
        configDatePicker()
    }
    
    @IBAction func datepickerDismissBtnTapped(_ sender: Any) {
        self.animateView(view: self.bottomContainerView)
    }
    
    @IBAction func scheduleBtnTapped(_ sender: Any) {
        var calendar = Calendar.init(identifier: .gregorian)
        //                calendar.timeZone = TimeZone(identifier: "GMT")!
        calendar.timeZone = TimeZone.current
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.hour = +5
        components.minute = +30
        let max = calendar.date(byAdding: components, to: self.datePicker.date)!
        
        let scheduledDate = Utility.shared.getValidDate(date: max)
        self.scheduleInterval = (scheduledDate?.timeIntervalSince1970)!
        self.scheduleEnable =  true
        if self.selectedIndexPath != nil{
            self.currentView = "payment"
            self.animateView(view: self.paymentView)
        }else{
            Utility.shared.showAlert(msg: "select_car", status: alertStatus)
        }
    }
    
    
    @IBAction func confirmRideBtnTapped(_ sender: Any) {
        self.grabCron.invalidate()
        if Utility.shared.checkEmptyWithString(value: self.paymentType){
            Utility.shared.showAlert(msg: "choose_payment", status: alertStatus)
        }else{
            if self.scheduleEnable{
                self.requestForRideService(type: "schedule")
            }else{
                self.requestForRideService(type: "ridenow")
            }
        }
    }
    
    @IBAction func cardBtnTapped(_ sender: Any) {
        self.cardSelectImgView.image = #imageLiteral(resourceName: "tick_icon")
        self.paymentType = "card"
        self.cashSelectImgView.isHidden = true
        self.cardSelectImgView.isHidden = false
    }
    
    @IBAction func cashBtnTapped(_ sender: Any) {
        self.cashSelectImgView.image = #imageLiteral(resourceName: "tick_icon")
        self.paymentType = "cash"
        self.cardSelectImgView.isHidden = true
        self.cashSelectImgView.isHidden = false
    }
    
    //MARK: Grab available Rides
    func getAvailableRides(km:String)  {
        rideObj.grabRides(pickup_location: self.pickupLocation, pickup_coordinate: self.pickUpCoordination, drop_location: self.dropLocation, drop_coordinate: self.dropCoordination,km:km, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                let resultArray:NSArray = response.value(forKey: "available_ride") as! NSArray
                self.carListArray = resultArray.mutableCopy() as! NSMutableArray
                //select as initial cab
                print("all availablity \(self.carListArray)")
                if self.carListArray.count != 0 {
                    let taxiDict:NSDictionary = self.carListArray.object(at: 0) as! NSDictionary
                    let availability = taxiDict.value(forKey: "available") as! NSString
                    if availability.isEqual(to: "1"){
                        self.selectedIndexPath = IndexPath.init(row: 0, section: 0)
                    }
                    self.carlistCollectionView.reloadData()
                    self.animateView(view: self.bottomContainerView)
                    self.grabCron = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.grabRides(timer:)), userInfo: km, repeats: true)
                }else{
                    self.noImgView.image = #imageLiteral(resourceName: "no_location")
                    self.alertEnable = false
                    self.no_lbl.text = response.value(forKey: "message") as? String
                    self.animateView(view: self.no_resultView)
                }
            }else if status.isEqual(to: STATUS_FALSE){
                self.noImgView.image = #imageLiteral(resourceName: "no_location")
                self.alertEnable = false
                self.no_lbl.text = response.value(forKey: "message") as? String
                self.animateView(view: self.no_resultView)
            }
        })
    }
    //cron grab ride
    @objc func grabRides(timer:Timer)  {
        DispatchQueue.global(qos: .background).async {
            //background code
            self.rideObj.grabRides(pickup_location: self.pickupLocation, pickup_coordinate: self.pickUpCoordination, drop_location: self.dropLocation, drop_coordinate: self.dropCoordination,km:timer.userInfo as! String, onSuccess: {response in
                HPLActivityHUD.dismiss()
                let status:NSString = response.value(forKey: "status") as! NSString
                if status.isEqual(to: STATUS_TRUE){
                    let resultArray:NSArray = response.value(forKey: "available_ride") as! NSArray
                    self.carListArray = resultArray.mutableCopy() as! NSMutableArray
                    //select as initial cab
                    self.animationEnable = false
                    self.carlistCollectionView.reloadData()
                }else if status.isEqual(to: STATUS_FALSE){
                    self.noImgView.image = #imageLiteral(resourceName: "no_location")
                    self.alertEnable = false
                    self.no_lbl.text = response.value(forKey: "message") as? String
                    self.animateView(view: self.no_resultView)
                }
            })
            
        }
        
    }
    //get ride details for history
    func getRideDetails(type:String)  {
        let rideObj =  RideServices()
        rideObj.getRideDetails(onride_id: self.onride_id, type: type, onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                let drop_lat:Double =  Utility.shared.convertToDouble(string: response.value(forKey: "drop_lat")as! String)
                let drop_lng:Double = Utility.shared.convertToDouble(string: response.value(forKey: "drop_lng")as! String)
                let pick_lat:Double = Utility.shared.convertToDouble(string: response.value(forKey: "pickup_lat")as! String)
                let pick_lng:Double = Utility.shared.convertToDouble(string: response.value(forKey: "pickup_lng")as! String)
                
                self.pickUpCoordination = CLLocationCoordinate2D.init(latitude: pick_lat, longitude: pick_lng)
                self.dropCoordination = CLLocationCoordinate2D.init(latitude: drop_lat, longitude: drop_lng)
                self.getDistance(type: "old")
                self.approxPriceLbl.text =  "\(Utility.shared.getLanguage()?.value(forKey: "approx_price") ?? EMPTY_STRING) \(Utility().currency()!) \(response.value(forKey: "approx_price")!)"
                
                self.pickupLocation = response.value(forKey: "pickup_location") as! String
                self.dropLocation = response.value(forKey: "drop_location") as! String
                if type == "ontheway" || type == "accepted"{
                    self.confirmRideService()
                }else if type == "onride"{
                    //                    self.confirmRideService()
                    self.rideDict = response
                    let reviewStatus = response.value(forKey: "isreview") as! String
                    if reviewStatus == "false"{
                        self.cancelBtn.config(color: GREEN_COLOR, size: 17, align: .center, title: "write_review")
                    }else{
                        self.cancelBtn.config(color: GREEN_COLOR, size: 17, align: .center, title: "edit_review")
                    }
                }else if status == "completed"{
                    self.disconnectSocket()
                    self.socketCron.invalidate()
                    if !self.stopEnable{
                        let rideObj = RideCompletedPage()
                        rideObj.onride_id = self.onride_id
                        rideObj.modalPresentationStyle = .fullScreen
                        self.present(rideObj, animated: true, completion: nil)
                        self.stopEnable = true
                    }
                }
                
                self.getPolylineRoute()
                self.showLocationTipView()
            }
        })
    }
    
    //MARK: ride now service
    @objc func confirmRideService()  {
        var notify = String()
        if viewType == "1" || viewType == "2"{
            notify = "0"
        }else{
            notify = "1"
        }
        rideObj.confirmRide(onride_id: self.onride_id,isNotify:notify,carmake: addCarmake,carmodel: addCarmodel,carcolor: addCarcolor ,onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                if !self.socketEnable{
                    self.setDriverDetails(driverDict: response)
                    HPLActivityHUD.dismiss()
                    self.trigger.invalidate()
                    self.drawOnce = false
                    self.mapView.clear()
                    self.drawRoute()
                    self.showLocationTipView()
                    self.carsCron.invalidate()
                    self.findingLbl.config(color: GREEN_COLOR, size: 17, align: .left, text: "ride_accepted")
                    self.findingImgView.image = #imageLiteral(resourceName: "tick_icon")
                    self.navigationView.isHidden = false
                    self.view.bringSubview(toFront: self.navigationView)
                    UIView.animate(withDuration: 1.0, animations: {
                        self.animateView(view: self.driverDetailsView)
                    })
                    self.socketCron = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.socketEmitMethods), userInfo: nil, repeats: true)
                    self.socketEnable = true
                }
            }else if status.isEqual(to: STATUS_FALSE){ // if status false more than 5 times means show no driver alert
                self.searchCount += 1
                if self.searchCount == 13{
                    self.trigger.invalidate()
                    self.noAcceptService()
                }
            }
        })
    }
    
    //MARK: driver not accept service call
    func noAcceptService()  {
        rideObj.noOneAccept(onride_id: self.onride_id, onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            HPLActivityHUD.dismiss()
            if status.isEqual(to: STATUS_TRUE){
                UIView.animate(withDuration: 1.0, animations: {
                    self.alertEnable = false
                    self.noImgView.image = #imageLiteral(resourceName: "no_driver")
                    self.no_lbl.text = Utility.shared.getLanguage()?.value(forKey: "no_driver_nearby") as? String
                    self.animateView(view: self.no_resultView)
                })
            }
        })
    }
    
    //MARK: confirm ride service
    func requestForRideService(type:String){
        var scheduleTime = String()
        var utc_time = String()
        if type == "schedule"{
            scheduleTime = String(self.scheduleInterval)
            utc_time = Utility.shared.getUTCTime(dateStr: self.datePicker.date)
        }else{
            scheduleTime = EMPTY_STRING
            utc_time = ""
        }
        rideObj.requestForRide(category_id: self.category_id, payment_type: self.paymentType, type: type, schedule_time: scheduleTime, pickup_location: self.pickupLocation, drop_location: self.dropLocation, pickup_coordinate: self.pickUpCoordination, drop_coordinate: self.dropCoordination,baseprice:self.basePrice, shedule_utc_time: utc_time , onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            self.scheduleEnable = false
            if status.isEqual(to: STATUS_TRUE){
                let onride_type = response.value(forKey: "onride_type") as! String
                if onride_type == "schedule"{
                    // AJAlertController.initialization().showAlertWithOkButton(aStrMessage:Utility.shared.getLanguage()?.value(forKey: "ride_scheduled") as! String, status: self.alertStatus, completion: { (index, title) in
                    let message = "ride_scheduled"
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: message, status: self.alertStatus, completion: { (index, title) in
                        Utility.shared.goToHomePage()
                    })
                }else{
                    self.animateView(view: self.findingView)
                    self.onride_id = response.value(forKey: "onride_id") as! String
                    self.confirmRideService()
                    self.searchCount = 0
                    self.trigger = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.confirmRideService), userInfo: nil, repeats: true)
                }
            }else if status.isEqual(to: STATUS_FALSE){
                //searching
            }
        })
    }
    //animate view
    func animateView(view:UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            self.hideAllSubViews()
        })
        UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: .curveLinear, animations: {
            let height:CGFloat = view.frame.size.height
            view.frame = CGRect.init(x: 0, y: FULL_HEIGHT-height, width: FULL_WIDTH, height: height)
            self.view.addSubview(view)
            self.view.bringSubview(toFront:view)
        })
    }
    //hide all sub views
    func hideAllSubViews(){
        self.datePickerView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: self.datePickerView.frame.size.height)
        self.bottomContainerView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: self.bottomContainerView.frame.size.height)
        self.no_resultView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: self.no_resultView.frame.size.height)
        self.paymentView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: self.paymentView.frame.size.height)
        self.driverDetailsView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: self.driverDetailsView.frame.size.height)
        self.findingView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: self.findingView.frame.size.height)
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

//CAR list Table view
extension RideNavigationPage:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //MARK: Collection view delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : TaxiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaxiCell", for: indexPath) as! TaxiCell
        let taxiDetails:NSDictionary = self.carListArray.object(at: indexPath.row) as! NSDictionary
        if let selected = selectedIndexPath, selected == indexPath {
            cell.animationEnable = self.animationEnable
            cell.configSelectedCell(taxiDict: taxiDetails)
            self.setSelectedDetails(taxiDetails: taxiDetails)
            self.carMarkerArray.removeAllObjects()
            self.enableCarList = false
            self.drawOnce = false
            self.mapView.clear()
            self.drawRoute()
            self.showLocationTipView()
            self.carsCron.invalidate()
            self.searchNearByCabs()
            self.carsCron = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.searchNearByCabs), userInfo: nil, repeats: true)
        }else{
            cell.configCell(taxiDict: taxiDetails)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 130)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell:TaxiCell = collectionView.cellForItem(at: indexPath) as! TaxiCell
        self.animationEnable = true
        let taxiDetails:NSDictionary = self.carListArray.object(at: indexPath.row) as! NSDictionary
        let availability = taxiDetails.value(forKey: "available") as! NSString
        if availability.isEqual(to: "1") {
            //set values
            self.setSelectedDetails(taxiDetails: taxiDetails)
            //config cells
            cell.configSelectedCell(taxiDict: taxiDetails)
            //            var cellsToReload = [indexPath]
            //            if let selected = selectedIndexPath {
            //                cellsToReload.append(selected)
            //            }
            selectedIndexPath = indexPath
            self.carlistCollectionView.reloadData()
            //            self.carlistCollectionView.reloadItems(at: [indexPath])
        }
        DispatchQueue.main.async {
            if indexPath.row == (self.carListArray.count - 1) {
                self.carlistCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell:TaxiCell = collectionView.cellForItem(at: indexPath) as? TaxiCell {
            let taxiDetails:NSDictionary = self.carListArray.object(at: indexPath.row) as! NSDictionary
            UIView.animate(withDuration: 0.4,delay: 0.0,usingSpringWithDamping: 1.0,initialSpringVelocity: 0.0,options: UIViewAnimationOptions(),animations: {
                cell.configCell(taxiDict: taxiDetails)
            },completion: nil)
        }
    }
    
    func setSelectedDetails(taxiDetails:NSDictionary)  {
        self.approxPriceLbl.text =  "\(Utility.shared.getLanguage()?.value(forKey: "approx_price") ?? EMPTY_STRING) \(Utility().currency()!) \(taxiDetails.value(forKey: "baseprice")!)"
        self.ridePriceLbl.text = "\(Utility.shared.getLanguage()?.value(forKey: "approx_price") ?? EMPTY_STRING) \(Utility().currency()!) \(taxiDetails.value(forKey: "baseprice")!)"
        self.category_id = taxiDetails.value(forKey: "_id") as! String
        self.timeDuration = taxiDetails.value(forKey: "reach_pickup") as! String
        let baseAmt:NSNumber = taxiDetails.value(forKey: "baseprice") as! NSNumber
        self.basePrice = String(describing: baseAmt)
    }
    
    @objc func searchNearByCabs()  {
        let requestDict = NSMutableDictionary()
        requestDict.setValue(self.category_id, forKey: "category_id")
        requestDict.setValue(self.pickUpCoordination.latitude, forKey: "lat")
        requestDict.setValue(self.pickUpCoordination.longitude, forKey: "lng")
        socket.defaultSocket.emit("cabneargo", requestDict)
        self.catchNearByCabs()
    }
    
    func catchNearByCabs()  {
        socket.defaultSocket.on("cabnearby") { ( data, ack) -> Void in
            //            print(" CAR NEARBY : \(data)")
            let carList:NSArray = data as NSArray
            let carArray:NSArray = carList.object(at: 0) as! NSArray
            if self.enableCarList{
                for newitem in carArray {
                    // new list from service
                    let newCarDict:NSDictionary = newitem as! NSDictionary
                    //check weather its available on previous list
                    self.checkCarAvailability(newDict: newCarDict)
                }
            }else{
                if !self.enableCarList{
                    for car in carArray {
                        //initial add list to car array
                        let carDict:NSDictionary = car as! NSDictionary
                        self.addCarToMap(carDict: carDict)
                    }
                    self.enableCarList = true
                }
            }
        }
        
    }
    
    //check availability
    func checkCarAvailability(newDict:NSDictionary)  {
        let newMarkId:String = newDict.value(forKey: "id")! as! String
        if self.carMarkerID.contains(newMarkId) {
            let markerIndex = self.carMarkerID.index(of: newMarkId)
            //            print("index \(markerIndex)")
            for item in self.carMarkerArray {
                let checkMarker  = item  as! GMSMarker
                if checkMarker.title == newMarkId {
                    let oldlat = Double(checkMarker.position.latitude)
                    let oldlong = Double(checkMarker.position.longitude)
                    let old = CLLocationCoordinate2D(latitude: oldlat , longitude: oldlong )
                    let newlat : Double = Double(newDict.value(forKey: "lat") as! String)!
                    let newlong : Double = Double(newDict.value(forKey: "lng") as! String)!
                    let new = CLLocationCoordinate2D(latitude:newlat , longitude: newlong )
                    let calBearing: Float = self.getHeadingForDirection(fromCoordinate: old, toCoordinate: new)
                    checkMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
                    if calBearing != 0{
                        checkMarker.rotation = CLLocationDegrees(calBearing);
                    }//found bearing value by calculation when marker add
                    checkMarker.position = old; //this can be old position to make car movement to new position
                    //marker movement animation
                    CATransaction.begin()
                    CATransaction.setValue(3.0, forKey: kCATransactionAnimationDuration)
                    CATransaction.setCompletionBlock({() -> Void in
                        if calBearing != 0{
                            checkMarker.rotation =  CLLocationDegrees(calBearing)
                        }
                        //found bearing value by calculation when marker add
                    })
                    checkMarker.position = new; //this can be new position after car moved from old position to new position with animation
                    checkMarker.map = self.mapView;
                    if calBearing != 0{
                        checkMarker.rotation = CLLocationDegrees(calBearing);
                    }
                    CATransaction.commit()
                    
                }
            }
        }else{
            self.addCarToMap(carDict: newDict)
        }
    }
    
    
    //add car to map
    func addCarToMap(carDict:NSDictionary)  {
        let lat   =  Double(carDict.value(forKey: "lat") as! String)
        let long =  Double(carDict.value(forKey: "lng")as! String)
        let position = CLLocationCoordinate2D(latitude:lat!, longitude: long! )
        self.carMarkerID.add(carDict.value(forKey: "id") as Any)
        let marker = GMSMarker(position: position)
        marker.icon = #imageLiteral(resourceName: "carIcon")
        marker.title = carDict.value(forKey: "id") as? String
        marker.map = self.mapView
        self.carMarkerArray.add(marker)
    }
    
    
    private func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        return (degree >= 0) ? degree : (360 + degree)
    }
    
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints1(point1 : CLLocationCoordinate2D, point2 : CLLocationCoordinate2D) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.latitude)
        let lon1 = degreesToRadians(degrees: point1.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.latitude)
        let lon2 = degreesToRadians(degrees: point2.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
    
}


