//
//  InvitePage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 20/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class InvitePage: UIViewController {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet var inviteBtn: UIButton!
    @IBOutlet var inviteMsgLbl: UILabel!
    
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
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.inviteMsgLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.inviteBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.inviteMsgLbl.transform = .identity
            self.inviteBtn.transform = .identity
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: set up intial details
    func setupInitialDetails()  {
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "invite_earn")
        self.inviteMsgLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .center, text: "invite_msg")
        self.inviteBtn.config(color: .white, size: 17, align: .center, title: "invite_frds")
        self.inviteBtn.cornerMiniumRadius()
        self.inviteBtn.backgroundColor = PRIMARY_COLOR
//        self.bannerAds()
    }
    @IBAction func inviteBtnTapped(_ sender: Any) {
        let string: String = Utility.shared.getLanguage()?.value(forKey: "share_msg") as! String
        let activityViewController = UIActivityViewController(activityItems:[string], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
}
//extension InvitePage: GADBannerViewDelegate {
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
//    }
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        print("BANNER ERROR \(error.localizedDescription)")
//    }
//}
