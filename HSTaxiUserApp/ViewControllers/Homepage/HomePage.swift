//
//  HomePage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 13/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import IQKeyboardManagerSwift
import SocketIO

let socket = SocketManager(socketURL: URL(string: SOCKET_URL)!, config: [.log(true), .compress])

class HomePage: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate{
   
    var locationManager = CLLocationManager()
    var mapView = GMSMapView()
    var marker = GMSMarker()
    let cameraPostion = GMSCameraPosition()
    let placesClient = GMSPlacesClient.shared()
    var session_token = GMSAutocompleteSessionToken()


    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var textfieldView: UIView!
    @IBOutlet var destinationTF: FloatLabelTextField!
    @IBOutlet var locationTableView: UITableView!
    @IBOutlet var locationListContainerView: UIView!
    
    @IBOutlet var greenDotLbl: UILabel!
    @IBOutlet var onlineLbl: UILabel!
    @IBOutlet var onlineView: UIView!
    @IBOutlet weak var otherInputView: UIView!
    
    @IBOutlet weak var bookMarkView: UIView!
    @IBOutlet weak var bmTitleLbl: UILabel!
    @IBOutlet weak var homeSelBtn: UIButton!
    @IBOutlet weak var officeSelBtn: UIButton!
    @IBOutlet weak var otherSelBtn: UIButton!
    @IBOutlet weak var HomeBtn: UIButton!
    @IBOutlet weak var officeBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    
    @IBOutlet weak var otherTF: UITextField!
    @IBOutlet weak var selectedIcon: UIImageView!
    
    @IBOutlet weak var bookMarkBGView: UIView!
    @IBOutlet weak var firstAddress: UILabel!
    @IBOutlet weak var secondAddress: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    var animateNavigation = Bool()
    var navEnable = Bool()
    var hideAll = Bool()
    var pickUpTF = FloatLabelTextField()
    var separatorLbl = UILabel()
    var verticalSeparatorLbl = UILabel()
    var closeBtn = UIButton()
    var closeImg = UIImageView()
    var redDot = UIView()
    var greenDot = UIView()
    var pickupClearView = UIView()
    var dropClearView = UIView()
    var locationArray = NSMutableArray()
    var googleIDArray = NSMutableArray()
    var locationCacheArray = NSMutableArray()

    var fetcher: GMSAutocompleteFetcher?
    var type = String()
    var bookmark_type = String()
    var selectedLocDict = NSMutableDictionary()
    var pickUpCoordination = CLLocationCoordinate2D()
    var dropCoordination = CLLocationCoordinate2D()
    var viewType = String()
    var currentLocation = CLLocation()
    var isSearch = Bool()
    var selectedAddress = NSMutableArray()
    var isFindMyLocation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupInitialDetails()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        print("will appear")
        self.setupInitialDetails()
        self.changeToRTL()
        self.locationTableView.reloadData()
        DispatchQueue.main.async {
            Utility.shared.fetchAdminData()
        }
    }
    
    //Model PopUp view
    
    
    
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.pickUpTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.pickUpTF.textAlignment = .right
            self.destinationTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.destinationTF.textAlignment = .right
            self.bmTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.onlineLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.onlineLbl.textAlignment = .right
            self.HomeBtn.contentHorizontalAlignment = .right
            self.officeBtn.contentHorizontalAlignment = .right
            self.otherBtn.contentHorizontalAlignment = .right
            self.otherTF.textAlignment = .right
            self.firstAddress.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.firstAddress.textAlignment = .right
            self.secondAddress.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.secondAddress.textAlignment = .right
            self.appIconImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.mapView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.mapView.semanticContentAttribute = .forceRightToLeft

        }
        else {
            self.view.transform = .identity
            self.pickUpTF.transform = .identity
            self.pickUpTF.textAlignment = .left
            self.destinationTF.transform = .identity
            self.destinationTF.textAlignment = .left
            self.bmTitleLbl.transform = .identity
            self.onlineLbl.transform = .identity
            self.onlineLbl.textAlignment = .left
            self.HomeBtn.contentHorizontalAlignment = .left
            self.officeBtn.contentHorizontalAlignment = .left
            self.otherBtn.contentHorizontalAlignment = .left
            self.otherTF.textAlignment = .left
            self.firstAddress.transform = .identity
            self.firstAddress.textAlignment = .left
            self.secondAddress.transform = .identity
            self.secondAddress.textAlignment = .left
            self.appIconImageView.transform = .identity
            self.mapView.transform = .identity
            self.mapView.semanticContentAttribute = .forceLeftToRight
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        print("did appear")
        hideAll = true
        self.locationListContainerView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height:  FULL_HEIGHT-150)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    //MARK: Initial set up
    func setupInitialDetails()  {
        self.animateNavigation =  false
        DispatchQueue.main.async {
            self.updatedSavedPlaces()
        }
        hideAll = true
        self.type = "2"
        self.navEnable = true
        self.isSearch = false
        bookMarkBGView.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.destinationTF.delegate = self
//        self.destinationTF.keyboardType = .asciiCapable
        self.addAnimationLayer()
        self.configureGoogleMap()
        self.navigationView.elevationEffect()
        self.view.bringSubview(toFront: self.navigationView)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: .curveLinear, animations: {
            self.navigationView.frame = CGRect.init(x: 0, y: 0, width: FULL_WIDTH, height: 80)
            self.navigationView.isHidden = false
        }, completion: nil)
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.destinationTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .right, placeHolder: "wherego")
            self.destinationTF.setRightPadding()

        }
        else {
            self.destinationTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "wherego")
            self.destinationTF.setLeftPadding()
        }
        self.destinationTF.cornerMiniumRadius()
        
        //textfield animation
        self.textfieldView.frame = CGRect.init(x: 20, y: -50, width: FULL_WIDTH-40, height: 50)
        self.textfieldView.cornerViewMiniumRadius()
        self.textfieldView.elevationEffect()
        self.otherTF.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .left, placeHolder: "other_fav_name")
        self.onlineView.elevationEffect()
        self.greenDotLbl.backgroundColor = GREEN_COLOR
        self.greenDotLbl.cornerRadius()
        self.onlineLbl.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .left, text: "cab_ready_msg")
        self.configBookMarkView()
        UIView.animate(withDuration: 0.8, delay: 1.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: .curveLinear, animations: {
            self.textfieldView.isHidden = false
            self.textfieldView.frame = CGRect.init(x: 20, y: 130, width: FULL_WIDTH-40, height: 50)
            self.destinationTF.frame = CGRect.init(x: 0, y: 0, width: FULL_WIDTH-40, height: 50)
        }, completion: nil)
        
        //keyboard manager
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        self.locationListContainerView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height: FULL_HEIGHT)
        

        locationTableView.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        self.view.addSubview(self.locationListContainerView)
        self.view.bringSubview(toFront: self.locationListContainerView)
        self.view.addSubview(self.textfieldView)
        self.view.bringSubview(toFront: self.textfieldView)
        //check location edit option.
        if UserModel.shared.checkEditStatus() == "true" {
                self.removeLocationSearchView()
                self.destinationTF.becomeFirstResponder()
                self.addLocationSearchView()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
            self.animateNavigation = true
        })
        session_token = GMSAutocompleteSessionToken.init()
        fetcher?.provide(session_token)
    }
    func showSavedAddress()  {
        self.locationArray.removeAllObjects()
        self.locationCacheArray.removeAllObjects()
        if  UserModel.shared.getSavedLoc() != nil {
            self.locationArray = UserModel.shared.getSavedLoc()?.mutableCopy() as! NSMutableArray
            self.locationCacheArray = UserModel.shared.getSavedLoc()?.mutableCopy() as! NSMutableArray
            self.googleIDArray = UserModel.shared.getSavedStrLoc()?.mutableCopy() as! NSMutableArray
            self.locationTableView.reloadData()
        }
    }
    
    func configBookMarkView(){
        self.bookMarkView.elevationEffect()
        self.otherInputView.isHidden = true
        self.saveBtn.config(color: .white, size: 17, align: .center, title: "save")
        self.cancelBtn.config(color: TEXT_TERTIARY_COLOR, size: 17, align: .center, title: "cancel")
        self.bmTitleLbl.config(color: TEXT_PRIMARY_COLOR, size: 23, align: .center, text: "save_your_place")
        self.saveBtn.cornerMiniumRadius()
        self.saveBtn.backgroundColor = PRIMARY_COLOR
        self.HomeBtn.config(color: TEXT_PRIMARY_COLOR, size: 16, align: .center, title: "home")
        self.officeBtn.config(color: TEXT_PRIMARY_COLOR, size: 16, align: .center, title: "office")
        self.otherBtn.config(color: TEXT_PRIMARY_COLOR, size: 16, align: .center, title: "others")
        self.officeBtn.frame = CGRect.init(x: officeSelBtn.frame.origin.x+officeSelBtn.frame.size.width+7, y: officeSelBtn.frame.origin.y, width: officeBtn.frame.size.width, height: 20)
        self.homeSelBtn.cornerMiniumRadius()
        self.officeSelBtn.cornerMiniumRadius()
        self.otherSelBtn.cornerMiniumRadius()

        firstAddress.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left, text: EMPTY_STRING)
        secondAddress.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .left, text: EMPTY_STRING)
        
        if IS_IPHONE_X {
            let cancelFrame = cancelBtn.frame
            let saveFrame = saveBtn.frame
            cancelBtn.frame = CGRect.init(x: cancelFrame.origin.x, y: cancelFrame.origin.y-5, width: cancelFrame.size.width, height: cancelFrame.size.height)
            saveBtn.frame = CGRect.init(x: saveFrame.origin.x, y: saveFrame.origin.y-5, width: saveFrame.size.width, height: saveFrame.size.height)

        }
    }
    
    /*
     * configure map sizes
     * add mapstyle  with json file
     * location update delegate methods
     */
    func configureGoogleMap(){
         mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: FULL_WIDTH, height: FULL_HEIGHT), camera: cameraPostion)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
//        mapView.padding = UIEdgeInsets.init(top: 0, left: 0, bottom: 5, right: 5)
        mapView.mapType = .normal
        self.view.addSubview(mapView)
        mapView.delegate = self
        self.addMapPin()
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.startUpdatingLocation()
        // Set the map style by passing the URL of the local file.
        do {
            if let styleURL = Bundle.main.url(forResource: "mapstyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("One or more of the map styles failed to load. \(error)")
        }
    }
    //MARK: show side menu
    @IBAction func sideBtnTapped(_ sender: Any) {
        hideAll = false
        self.locationListContainerView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height:  FULL_HEIGHT-150)
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    //MARK: show notifications
    @IBAction func notificationBtnTapped(_ sender: Any) {
        let notificationObj = NotificationPage()
        notificationObj.modalPresentationStyle = .fullScreen
        self.navigationController?.present(notificationObj, animated: true, completion: nil)
    }
    
    //MARK: TextField delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.session_token = GMSAutocompleteSessionToken.init()
        self.fetcher?.provide(self.session_token)
        if textField.tag == 1{
            type = "1"
        }else{
            type = "2"
        }
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: .curveLinear, animations: {
           self.addLocationSearchView()
        }, completion: nil)
    }
    //iq keyboard manger done button action
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !self.isSearch{
//            self.searchForRide(textField: textField)
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.isSearch = true
//        self.searchForRide(textField: textField)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let location = textField.text!+string
        if location.count > 2 {
            fetcher?.sourceTextHasChanged(location)
        }
        return true
    }
    // search for new ride
    func searchForRide()  {
        destinationTF.resignFirstResponder()
        pickUpTF.resignFirstResponder()
        if( (destinationTF.text == Utility.shared.getLanguage()?.value(forKey: "loading") as? String) || (pickUpTF.text == Utility.shared.getLanguage()?.value(forKey: "loading")as? String) || destinationTF.isEmptyValue() || pickUpTF.isEmptyValue()){
//            self.removeLocationSearchView()
        }else{
            self.moveToRidePage()
        }
    }
    
    func moveToRidePage()  {
        let rideObj = RideNavigationPage()
        rideObj.pickUpCoordination = self.pickUpCoordination
        rideObj.dropCoordination = self.dropCoordination
        rideObj.dropLocation = self.destinationTF.text!
        rideObj.pickupLocation = self.pickUpTF.text!
        self.removeLocationSearchView()
        rideObj.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(rideObj, animated: true)
    }
    //MARK: Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude), zoom: 17.0)
        self.mapView.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        //set initial pickup coordination
        
        self.setAddress(coordinate: currentLocation.coordinate, type:self.type)

        //add custom marker to gmsmarker
        marker.position = CLLocationCoordinate2D(latitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude))
        
        //set filter bounds to fetch near by location as first
        self.setNearBounds(boundsCoordinate: currentLocation.coordinate)

        }
    
    //MARK: location manager authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
            self.locationPermissionAlert()
        case .denied:
            print("User denied access to location.")
            self.locationPermissionAlert()
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    //MARK:location restriction alert
    func locationPermissionAlert(){
        AJAlertController.initialization().showAlert(aStrMessage: "location_permission", aCancelBtnTitle: "cancel", aOtherBtnTitle: "settings", status: "", completion: { (index, title) in
            print(index,title)
            if index == 1{
                //open settings page
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
    }

    
    @IBAction func homeBtnTapped(_ sender: Any) {
        bookmark_type = "Home"
        self.otherInputView.isHidden = true
        self.selectedOption(btn: self.homeSelBtn)
        self.selectedIcon.image = UIImage.init(named: "home_icon")
    }
    
    @IBAction func officeBtnTapped(_ sender: Any) {
        bookmark_type = "Office"
        self.otherInputView.isHidden = true
        self.selectedOption(btn: self.officeSelBtn)
        self.selectedIcon.image = UIImage.init(named: "office_icon")
    }
    
    @IBAction func otherBtnTapped(_ sender: Any) {
        bookmark_type = "Other"
        self.otherInputView.isHidden = false
        self.selectedOption(btn: self.otherSelBtn)
        self.selectedIcon.image = UIImage.init(named: "office_icon")
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.googleIDArray.remove(selectedLocDict.value(forKey:"google_place_id") as! String)
        self.bookMarkBGView.isHidden = true
        self.locationTableView.reloadData()
        self.destinationTF.becomeFirstResponder()
    }
    
   
    
    @IBAction func saveBtntTapped(_ sender: Any) {
        if self.bookmark_type == "Other"{
            if self.otherTF.text == ""{
                self.otherTF.resignFirstResponder()
                self.view.makeToast(Utility.shared.getLanguage()?.value(forKey: "enter_fav_place")as? String, align: UserModel.shared.getAppLanguage() ?? "English")
            }else{
                self.saveFavPlaces()
            }
        }else{
            self.saveFavPlaces()
        }
        }
    
    func saveFavPlaces()  {
        let placeID = selectedLocDict.value(forKey:"google_place_id") as! String
        self.placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            if let place = place {
                
                self.selectedLocDict.setValue(place.coordinate.latitude, forKey: "lat")
                self.selectedLocDict.setValue(place.coordinate.longitude, forKey: "lon")
                if self.bookmark_type == "Other"{
                    self.selectedLocDict.setValue(self.otherTF.text, forKey: "type")
                }else{
                    self.selectedLocDict.setValue(self.bookmark_type, forKey: "type")
                }
                
                let userObj = UserServices()
                userObj.addPlace(firstAdd: self.selectedLocDict.value(forKey:"address_first") as! String, fullAdd: self.selectedLocDict.value(forKey:"address_second") as! String, lat: "\(place.coordinate.latitude)", lng: "\(place.coordinate.longitude)", place_type:self.selectedLocDict.value(forKey:"type") as! String, place_id: placeID, onSuccess: {response in
                    let status:String = response.value(forKey: "status") as! String
                    if status.isEqual(STATUS_TRUE){
                        self.otherTF.text = ""
                        self.bookMarkBGView.isHidden = true
                        self.locationCacheArray.add(self.selectedLocDict)
                        UserModel.shared.removeSavedLoc()
                        UserModel.shared.setSavedLoc(locArray: self.locationCacheArray.mutableCopy() as! NSArray)
                        UserModel.shared.setSavedStrLoc(locArray: self.googleIDArray.mutableCopy() as! NSArray)
                        self.view.makeToast(Utility.shared.getLanguage()?.value(forKey: "save_place_alert") as? String, align: UserModel.shared.getAppLanguage() ?? "English")
                    }else{
                        self.view.makeToast(Utility.shared.getLanguage()?.value(forKey: "server_alert")as? String, align: UserModel.shared.getAppLanguage() ?? "English")
                        self.googleIDArray.remove(placeID)
                        self.locationTableView.reloadData()
                    }
                })
            }
        })
    }
    func selectedOption(btn:UIButton) {
        self.configRadioBtn(btn: self.homeSelBtn)
        self.configRadioBtn(btn: self.officeSelBtn)
        self.configRadioBtn(btn: self.otherSelBtn)

        UIView.animate( withDuration: 1.0, delay: 0.0,usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0,options: UIViewAnimationOptions(),animations: {
        let templateImage =  UIImage.init(named: "tick_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        btn.setImage(templateImage, for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = PRIMARY_COLOR
        btn.setBorder(color: PRIMARY_COLOR)
        },   completion: nil)

    }
    func configRadioBtn(btn:UIButton){
        btn.setImage(nil, for: .normal)
        btn.backgroundColor = .white
        btn.setBorder(color: TEXT_TERTIARY_COLOR)
    }
    //MARK: Add custom map pin
    func addMapPin() {
        let pinImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 22, height: 45))
//        pinImageView.image = UIImage.init(cgImage: #imageLiteral(resourceName: "current_location").cgImage!, scale: 3.0, orientation: .up)
        pinImageView.image = #imageLiteral(resourceName: "current_location")

        pinImageView.contentMode = .scaleAspectFit
        pinImageView.center = CGPoint.init(x: self.mapView.center.x-2.5, y: self.mapView.center.y-20)
        self.view.addSubview(pinImageView)
        self.view.bringSubview(toFront: pinImageView)
            //marker view animation
            let bounce = CABasicAnimation(keyPath: "position.y")
            bounce.duration = 1
            bounce.fromValue = self.mapView.center.y-100
            bounce.toValue = self.mapView.center.y-20
            bounce.repeatCount = 0
            bounce.autoreverses = false
            pinImageView.layer.add(bounce, forKey: "position")
    }
   
    
    //GMS Map view delegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let coordinate = CLLocationCoordinate2DMake(Double(latitude),Double(longitude))
        self.setAddress(coordinate: coordinate,type:"2")
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: .curveLinear, animations: {
            self.navigationView.frame = CGRect.init(x: 0, y: 0, width: FULL_WIDTH, height: 80)
            self.navigationView.isHidden = false
            mapView.settings.myLocationButton = true
        }, completion: nil)

    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if self.animateNavigation {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: .curveLinear, animations: {
                self.navigationView.frame = CGRect.init(x: 0, y: -80, width: FULL_WIDTH, height: 80)
                self.navigationView.isHidden = true
                mapView.settings.myLocationButton = false
            }, completion: nil)
        }
    }

    func setAddress(coordinate:CLLocationCoordinate2D,type:String) {
        let locaServ = GoogleLocationService()
        locaServ.getlocationFromCordination(coordinate: coordinate, onSuccess: {response in
            let status :String = response.value(forKey: "status") as! String
            if status == "OK"{
                let resultArray :NSArray = response.value(forKey: "results") as! NSArray
                let dict:NSDictionary = resultArray.object(at: 0) as! NSDictionary
                if UserModel.shared.getAppLanguage() == "Arabic" {
                    self.pickUpTF.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .right, placeHolder: "pickup")
                    self.pickUpTF.setRightPadding()
                }
                else {
                    self.pickUpTF.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .left, placeHolder: "pickup")
                    self.pickUpTF.setLeftPadding()
                }
                
                let place_id =  dict.value(forKey: "place_id") as! String
                if self.googleIDArray.contains(place_id){
                    
                    for location in self.locationCacheArray{
                        let locDict:NSDictionary = location as! NSDictionary
                        print("textfilecd item \(locDict)")
                        let prev_google_place_id = locDict.value(forKey: "google_place_id") as! String
                        if place_id.isEqual(prev_google_place_id){
                            let lat:NSNumber = locDict.value(forKeyPath:"lat") as! NSNumber
                            let lon:NSNumber =  locDict.value(forKeyPath:"lon") as! NSNumber
                            let lattitute:Double = Double(truncating: lat)
                            let longitute:Double = Double(truncating: lon)
                            if type == "1" {
                                self.destinationTF.text = locDict.value(forKey: "type") as? String
                                self.dropCoordination = CLLocationCoordinate2D.init(latitude: lattitute, longitude: longitute)
                            }else if type == "2"{
                                self.pickUpTF.text = locDict.value(forKey: "type") as? String
                                self.pickUpCoordination = CLLocationCoordinate2D.init(latitude: lattitute, longitude: longitute)
                            }
                        }
                    }
                    
                }else{
                    if self.type == "1" {
                        self.destinationTF.text = dict.value(forKey: "formatted_address") as? String
                        self.dropCoordination = coordinate
                    }else if self.type == "2"{
                        self.pickUpTF.text = dict.value(forKey: "formatted_address") as? String
                        self.pickUpCoordination = coordinate
                    }
                }
                if self.isFindMyLocation {
                    self.moveToRidePage()
                }
                self.isFindMyLocation = false
            }
            
        })
    }
    
    
    //MARK: Keyboard hide/show
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        if hideAll {
            if IS_IPHONE_X{
                self.locationListContainerView.frame = CGRect.init(x: 0, y: 170, width: FULL_WIDTH, height:  FULL_HEIGHT-170)
            }else{
                self.locationListContainerView.frame = CGRect.init(x: 0, y: 150, width: FULL_WIDTH, height:  FULL_HEIGHT-150)
            }
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.locationListContainerView.frame.size.height -= keyboardFrame.height+15
        }
       
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.locationListContainerView.frame.size.height += keyboardFrame.height+15
    }
    
    //MARK: Add pickup drop location search view programmatically
    func addLocationSearchView()  {
        //disable the hidde views
        self.pickUpTF.isHidden = false
        self.redDot.isHidden = false
        self.greenDot.isHidden = false
        self.separatorLbl.isHidden = false
        self.verticalSeparatorLbl.isHidden = false
        
        //enlarge textfields view
        self.textfieldView.removeCornerRadius()
        self.textfieldView.isHidden = false
        self.textfieldView.backgroundColor = .white
        var padding = CGFloat()
        if IS_IPHONE_X {
            self.textfieldView.frame = CGRect.init(x: 0, y: 0, width: FULL_WIDTH, height: 170)
            padding = 20
        }else{
            self.textfieldView.frame = CGRect.init(x: 0, y: 0, width: FULL_WIDTH, height: 150)
            padding = 0
        }
        self.textfieldView.elevationEffect()
     
        //config pickup textfield
        self.pickUpTF.frame = CGRect.init(x: 30, y: 50+padding, width: FULL_WIDTH-50, height: 35)
        self.pickUpTF.delegate = self
        self.pickupClearView.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        let picClearImgView = UIImageView()
        picClearImgView.frame = CGRect.init(x: 10, y: 10, width: 15, height: 15)
        picClearImgView.image = #imageLiteral(resourceName: "close_icon")
        picClearImgView.contentMode = .scaleAspectFill
        let clearPicTFtap = UITapGestureRecognizer(target: self, action: #selector(self.clearPickUpTF(_:)))
        self.pickupClearView.addGestureRecognizer(clearPicTFtap)
        self.pickupClearView.addSubview(picClearImgView)

        self.pickUpTF.tag = 2
        self.pickUpTF.returnKeyType = .search // set return key
        //config pickup custom text clear button
        self.textfieldView.addSubview(pickUpTF)
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.pickUpTF.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .right, placeHolder: "pickup")
            self.pickUpTF.leftView = self.pickupClearView
            self.pickUpTF.leftViewMode = .whileEditing

        }
        else {
            self.pickUpTF.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .left, placeHolder: "pickup")
            self.pickUpTF.rightView = self.pickupClearView
            self.pickUpTF.rightViewMode = .whileEditing
        }
//        self.pickUpTF.setLeftPadding()
//        self.pickUpTF.setRightPadding()

        //separatore between two textfields
        self.separatorLbl.frame = CGRect.init(x: 50, y: 92.5+padding, width: FULL_WIDTH-30, height: 0.5)
        self.separatorLbl.backgroundColor = SEPARTOR_COLOR
        self.textfieldView.addSubview(separatorLbl)

        //destination textfield
        self.destinationTF.frame = CGRect.init(x: 30, y: 100+padding, width: FULL_WIDTH-50, height: 35)
        self.dropClearView.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        let dropClearImgView = UIImageView()
        dropClearImgView.frame = CGRect.init(x: 10, y: 10, width: 15, height: 15)
        dropClearImgView.image = #imageLiteral(resourceName: "close_icon")
        dropClearImgView.contentMode = .scaleAspectFill
        let dropPicTFtap = UITapGestureRecognizer(target: self, action: #selector(self.clearDropTF(_:)))
        //config pickup custom text clear button
        self.dropClearView.addGestureRecognizer(dropPicTFtap)
        self.dropClearView.addSubview(dropClearImgView)

        
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.destinationTF.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .right, placeHolder: "drop")
//            self.destinationTF.setRightPadding()
            self.destinationTF.leftView = self.dropClearView
            self.destinationTF.leftViewMode = .whileEditing

        }
        else {
            self.destinationTF.config(color: TEXT_PRIMARY_COLOR, size: 14, align: .left, placeHolder: "drop")
            self.destinationTF.rightView = self.dropClearView
            self.destinationTF.rightViewMode = .whileEditing

//            self.destinationTF.setLeftPadding()
        }
        //green circle view
        self.greenDot.frame = CGRect.init(x: 20, y: 64+padding, width: 10, height: 10)
        self.greenDot.cornerViewRadius()
        self.greenDot.backgroundColor = GREEN_COLOR
        self.textfieldView.addSubview(greenDot)
        //join green circle and red circle by vertical dotted line
        self.verticalSeparatorLbl.frame = CGRect.init(x: 25, y: 79+padding, width: 1, height: 30)
        self.verticalSeparatorLbl.backgroundColor = .clear
        Utility.shared.drawDottedLine(start: CGPoint.init(x: 0, y: 0), end: CGPoint.init(x: 0, y: 30), label: self.verticalSeparatorLbl)
        self.textfieldView.addSubview(verticalSeparatorLbl)
        //red circle
        self.redDot.frame = CGRect.init(x: 20, y: 114+padding, width: 10, height: 10)
        self.redDot.cornerViewRadius()
        self.redDot.backgroundColor = RED_COLOR
        self.textfieldView.addSubview(redDot)
        //close view & action
        self.closeImg.frame = CGRect.init(x: 15, y: 30+padding, width: 20, height: 20)
        self.closeImg.image = #imageLiteral(resourceName: "navigaion_back")
        self.textfieldView.addSubview(closeImg)
        self.closeBtn.frame = CGRect.init(x: 12.5, y: 17.5+padding, width: 40, height: 40)
        self.closeBtn.addTarget(self, action: #selector(self.removeLocationSearchView), for: .touchUpInside)
        self.textfieldView.addSubview(closeBtn)
        self.closeBtn.isHidden = false
        self.closeImg.isHidden = false
        //location list page
        if IS_IPHONE_X{
            self.locationListContainerView.frame = CGRect.init(x: 0, y: 170, width: FULL_WIDTH, height:  FULL_HEIGHT-170)
        }else{
            self.locationListContainerView.frame = CGRect.init(x: 0, y: 150, width: FULL_WIDTH, height:  FULL_HEIGHT-150)

        }

    }
    
    @objc func clearPickUpTF(_ sender: UITapGestureRecognizer) {
        self.pickUpTF.text = EMPTY_STRING
        self.showSavedAddress()

    }
    @objc func clearDropTF(_ sender: UITapGestureRecognizer) {
        self.destinationTF.text = EMPTY_STRING
        self.showSavedAddress()
    }
    //remove location search view
    @objc func removeLocationSearchView(){
        self.destinationTF.text = EMPTY_STRING
        self.destinationTF.resignFirstResponder()
        self.pickUpTF.resignFirstResponder()
        self.pickUpTF.isHidden = true
        self.redDot.isHidden = true
        self.greenDot.isHidden = true
        self.separatorLbl.isHidden = true
        self.verticalSeparatorLbl.isHidden = true
        self.destinationTF.rightView = nil
        self.type = "2"
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: .curveLinear, animations: {
            self.closeBtn.isHidden = true
            self.closeImg.isHidden = true
            self.destinationTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "wherego")
            self.textfieldView.cornerViewMiniumRadius()
            self.textfieldView.elevationEffect()
            self.textfieldView.isHidden = false
            self.textfieldView.frame = CGRect.init(x: 20, y: 130, width: FULL_WIDTH-40, height: 50)
            self.destinationTF.frame = CGRect.init(x: 0, y: 0, width: FULL_WIDTH-40, height: 50)
            self.locationListContainerView.frame = CGRect.init(x: 0, y: FULL_HEIGHT, width: FULL_WIDTH, height:  FULL_HEIGHT)

        }, completion: nil)
        self.locationArray.removeAllObjects()
        UserModel.shared.setSavedLoc(locArray: self.locationCacheArray.mutableCopy() as! NSArray)
        UserModel.shared.setSavedStrLoc(locArray: self.googleIDArray.mutableCopy() as! NSArray)
        
        if  UserModel.shared.getSavedLoc() != nil {
            self.locationArray = UserModel.shared.getSavedLoc()?.mutableCopy() as! NSMutableArray
            self.locationTableView.reloadData()
        }
    }
   
}
//MARK: Location auto complete fetcher
extension HomePage: GMSAutocompleteFetcherDelegate,UITableViewDelegate,UITableViewDataSource {
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.locationArray.removeAllObjects()
        for prediction in predictions{
            let mutableDict = NSMutableDictionary()
            mutableDict.setValue(prediction.attributedPrimaryText.string, forKey: "address_first")
            mutableDict.setValue(prediction.attributedSecondaryText?.string, forKey: "address_second")
            mutableDict.setValue(prediction.attributedFullText.string, forKey: "address_full")
            mutableDict.setValue(prediction.placeID, forKey: "google_place_id")
            mutableDict.setValue("new", forKey: "type")
            mutableDict.setValue("0.0", forKey: "lat")
            mutableDict.setValue("0.0", forKey: "lon")
            self.locationArray.addObjects(from: [mutableDict])
        }
        self.locationTableView.reloadData()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    func GetPlaceDataByPlaceID(pPlaceID: String)
    {
        self.placesClient.lookUpPlaceID(pPlaceID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                self.GetPlaceDataByPlaceID(pPlaceID: pPlaceID)
                return
            }
            if let place = place {

                if self.type == "1" {
                    self.dropCoordination = place.coordinate
                    self.destinationTF.text = place.name
                }else if self.type == "2"{
                    self.pickUpCoordination = place.coordinate
                    self.pickUpTF.text =  place.name
                  self.setNearBounds(boundsCoordinate: place.coordinate)
                }
                self.session_token = GMSAutocompleteSessionToken.init()
                self.fetcher?.provide(self.session_token)
                self.searchForRide()
            } else {
                print("No place details for \(pPlaceID)")
            }
        })
    }
    
    func setNearBounds(boundsCoordinate:CLLocationCoordinate2D) {
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        let mylocation = CLLocationCoordinate2D.init(latitude: boundsCoordinate.latitude, longitude: boundsCoordinate.longitude)
        let bounds = GMSCoordinateBounds.init(coordinate: mylocation, coordinate: mylocation)
        fetcher = GMSAutocompleteFetcher.init(bounds:bounds , filter:filter)
        fetcher?.delegate = self
    }
    
    //MARK: Table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count+1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let locationObj = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
         if indexPath.row != 0{
            let locationDict:NSDictionary =  self.locationArray.object(at: indexPath.row-1) as! NSDictionary
            locationObj.configCell(locationDict: locationDict)
            locationObj.like_btn.tag = indexPath.row-1
            locationObj.like_btn.addTarget(self, action:#selector(likeBtnTapped(sender:)), for: .touchUpInside)
            if googleIDArray.contains(locationDict.value(forKey: "google_place_id") as! String){
                locationObj.like_btn.setImage(UIImage.init(named: "liked_icon"), for: .normal)
            }else{
                locationObj.like_btn.setImage(UIImage.init(named: "like_icon"), for: .normal)
            }

         }else if indexPath.row == 0 {
            locationObj.configMyLocationCell()
        }
        return locationObj
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.isFindMyLocation = true
            locationManager.startUpdatingLocation()
        }else{
            let locationDict:NSDictionary =  self.locationArray.object(at: indexPath.row-1) as! NSDictionary
            let google_place_id = locationDict.value(forKey: "google_place_id") as! NSString
            if googleIDArray.contains(google_place_id){ // already saved data
                for location in self.locationCacheArray{
                    let locDict:NSDictionary = location as! NSDictionary
                    let prev_google_place_id = locDict.value(forKey: "google_place_id") as! String
                    if google_place_id.isEqual(to: prev_google_place_id){
                        let lat:NSNumber = locDict.value(forKeyPath:"lat") as! NSNumber
                        let lon:NSNumber =  locDict.value(forKeyPath:"lon") as! NSNumber
                        let lattitute:Double = Double(truncating: lat)
                        let longitute:Double = Double(truncating: lon)
                        if type == "1" {
                            self.destinationTF.text = locDict.value(forKey: "address_full") as? String
                            self.dropCoordination = CLLocationCoordinate2D.init(latitude: lattitute, longitude: longitute)
                        }else if type == "2"{
                            self.pickUpTF.text = locDict.value(forKey: "address_full") as? String
                            self.pickUpCoordination = CLLocationCoordinate2D.init(latitude: lattitute, longitude: longitute)
                            self.setNearBounds(boundsCoordinate: self.pickUpCoordination)

                        }
                        if( (destinationTF.text == Utility.shared.getLanguage()?.value(forKey: "loading") as? String) || (pickUpTF.text == Utility.shared.getLanguage()?.value(forKey: "loading")as? String) || destinationTF.isEmptyValue() || pickUpTF.isEmptyValue()){
                        }else{
                            self.moveToRidePage()
                        }
                       
                    }
                }
            }else{ // location from goole map
                if type == "1" {
                    self.destinationTF.text = Utility.shared.getLanguage()?.value(forKey: "loading") as? String
                }else if type == "2"{
                    self.pickUpTF.text = Utility.shared.getLanguage()?.value(forKey: "loading") as? String
                }
                self.GetPlaceDataByPlaceID(pPlaceID: locationDict.value(forKey: "google_place_id") as! String)
            }
        }
    }

    
    func updatedSavedPlaces()  {
        let userObj = UserServices()
        userObj.savedPlaces(onSuccess: {response in
            let status:String = response.value(forKey: "status") as! String
            if status.isEqual(STATUS_TRUE){
                DispatchQueue.main.async {
                    
                let savedArray:NSArray = response.value(forKey: "saved_places") as! NSArray
                let googleIDArray = NSMutableArray()
                let cacheArray = NSMutableArray()
                for locDict in savedArray{
                    let savedDict:NSDictionary = locDict as! NSDictionary
                    let newDict = NSMutableDictionary()
                    let first_add = savedDict.value(forKey: "place_name") as! String
                    let second_add = savedDict.value(forKey: "place_full_address") as! String
                    
                    newDict.setValue(first_add, forKey: "address_first")
                    newDict.setValue(second_add, forKey: "address_second")
                    newDict.setValue("\(first_add), \(second_add)", forKey: "address_full")
                    newDict.setValue(savedDict.value(forKey: "place_type") as! String, forKey: "type")
                    let placeID = savedDict.value(forKey: "google_place_id") as! String
                    newDict.setValue(placeID, forKey: "google_place_id")
                    newDict.setValue(savedDict.value(forKey: "place_latitude") as! NSNumber, forKey: "lat")
                    newDict.setValue(savedDict.value(forKey: "place_longitude") as! NSNumber, forKey: "lon")
                    
                    cacheArray.add(newDict)
                    googleIDArray.add(placeID)
                    
                }
                UserModel.shared.removeSavedLoc()
                UserModel.shared.setSavedLoc(locArray:cacheArray)
                UserModel.shared.setSavedStrLoc(locArray: googleIDArray)
                self.showSavedAddress()
            }
            }

        })

    }
    //like and dislike
    @objc func likeBtnTapped(sender:UIButton)  {
        self.otherTF.text = ""
        self.isSearch = true
        let locDict : NSDictionary = locationArray.object(at: sender.tag) as! NSDictionary
        let google_place_id:String = locDict.value(forKey:"google_place_id") as! String
        let first_address:String = locDict.value(forKey:"address_first") as! String
        let second_address:String = locDict.value(forKey:"address_second") as! String
        let type:NSString = locDict.value(forKey:"type") as! NSString
        
        if self.googleIDArray.contains(google_place_id) {
            
            //confirmation alert
            self.destinationTF.resignFirstResponder()
            self.pickUpTF.resignFirstResponder()
            AJAlertController.initialization().showAlert(aStrMessage: "location_remove", aCancelBtnTitle: "cancel", aOtherBtnTitle: "okay", status: "", completion: { (index, title) in
                if index == 1{ // remove
            
            let userObj = UserServices()
            userObj.removePlace(place_id: google_place_id, onSuccess:{response in
                let status:String = response.value(forKey: "status") as! String
                if status.isEqual(STATUS_TRUE){
                    
                    self.googleIDArray.remove(google_place_id)
                    self.bookMarkBGView.isHidden = true
                    for location in self.locationCacheArray{
                        let newDict:NSDictionary = location as! NSDictionary
                        let prev_google_place_id = newDict.value(forKey: "google_place_id") as! String
                        if google_place_id == prev_google_place_id{
                            self.locationCacheArray.remove(newDict)
                        }
                    }
                    
                    UserModel.shared.removeSavedLoc()
                    UserModel.shared.setSavedLoc(locArray: self.locationCacheArray.mutableCopy() as! NSArray)
                    UserModel.shared.setSavedStrLoc(locArray: self.googleIDArray.mutableCopy() as! NSArray)
                    print("cache loc type\(type)")
                    print("remove cache loc \(self.locationCacheArray)")

                    if type.isEqual(to: "new"){
                    }else{
                        self.locationArray.removeAllObjects()
                        self.locationArray = UserModel.shared.getSavedLoc()?.mutableCopy() as! NSMutableArray
                    }
                    self.showSavedAddress()
                }else{
                    self.view.makeToast(Utility.shared.getLanguage()?.value(forKey: "server_alert")as? String, align: UserModel.shared.getAppLanguage() ?? "English")
                }
            })//service end
               
                }
            })//alert end
            

        }else{
            self.bookmark_type = "Home"
            self.otherInputView.isHidden = true
            self.destinationTF.resignFirstResponder()
            self.pickUpTF.resignFirstResponder()
            self.googleIDArray.add(locDict.value(forKey:"google_place_id") as! String)
            self.locationTableView.reloadData()
            selectedLocDict = locDict as! NSMutableDictionary
            self.firstAddress.text = first_address
            self.secondAddress.text = second_address
            self.bookMarkView.frame = CGRect.init(x: 0, y: FULL_HEIGHT-self.bookMarkView.frame.size.height, width: FULL_WIDTH, height: self.bookMarkView.frame.size.height)
            self.selectedOption(btn: self.homeSelBtn)
            self.view.bringSubview(toFront: self.bookMarkBGView)
            self.bookMarkBGView.isHidden = false
        }
     
    }
    
   
    
}
