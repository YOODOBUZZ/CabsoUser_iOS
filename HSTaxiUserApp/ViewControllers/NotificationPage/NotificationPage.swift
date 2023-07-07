//
//  NotificationPage.swift
//  HSLiveStream
//
//  Created by APPLE on 22/01/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NotificationPage: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var notificationArray = NSMutableArray()
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var no_notificationView: UIView!
    @IBOutlet weak var no_notificationLabel: UILabel!
    @IBOutlet weak var notification_TableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet var titleLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:initial setup
    func setupInitialDetails()   {
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "notifications")
        self.no_notificationLabel.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .center, text: "no_notification")
        notification_TableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
     //   HPLActivityHUD.showActivity(with: .withMask)
        self.getNotificationService()
        // Banner Ads
//        self.bannerAds()
    }
    //MARK: get notification
    func getNotificationService()   {
        let notificationObj = UserServices()
        notificationObj.getNotifications(onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                HPLActivityHUD.dismiss()
                self.notificationArray.removeAllObjects()
                self.notificationArray.addObjects(from: (response.value(forKey: "result") as! NSArray) as! [Any])
            }
            self.checkAvailability()
        }, onFailure: { errorResponse in
            HPLActivityHUD.dismiss()
        })
    }
    
    //MARK: check if notification is empty
    func checkAvailability() {
        if (notificationArray.count == 0) {
            self.no_notificationView.isHidden = false
            self.view.bringSubview(toFront: self.no_notificationView)
            HPLActivityHUD.dismiss()
        }else{
            self.notification_TableView.isHidden = false;
            self.no_notificationView.isHidden = true
            self.notification_TableView.reloadData()
        }
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int{
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let notifyCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell 
        let notificationDict:NSDictionary =  notificationArray.object(at: indexPath.row) as! NSDictionary
        notifyCell.configureCellWithDetails(notificationDict: notificationDict)
        return notifyCell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 95
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
    }
  
}
//extension NotificationPage: GADBannerViewDelegate {
//    func bannerAds() {
//        if (BANNER_AD_ENABLED == true) {
//            self.bannerView.isHidden = true
//            self.configAds()
//        }
//        else {
//            self.bannerView.isHidden = true
//        }
//    }
//    func configAds()  {
//        bannerView.adUnitID = AD_UNIT_ID
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//        bannerView.delegate = self
//    }
//    //banner view delegate
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        bannerView.isHidden = false
//        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: self.notification_TableView.frame.width, height: 50))
//        self.notification_TableView.tableFooterView = bottomView
//    }
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        print("BANNER ERROR \(error.localizedDescription)")
//    }
//}
