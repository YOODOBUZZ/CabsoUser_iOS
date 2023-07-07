//
//  HelpPage.swift
//  HSLiveStream
//
//  Created by APPLE on 20/02/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HelpPage: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    var helpArray = NSArray()
    @IBOutlet weak var helpTableView: UITableView!
    @IBOutlet var floatingBtnView: UIView!
    @IBOutlet var noLbl: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupInitialDetails()
        getHelpPageContentService()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.noLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.noLbl.transform = .identity
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: configure design
    func setupInitialDetails()  {
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "help")
        helpTableView.register(UINib(nibName: "HelpPageCell", bundle: nil), forCellReuseIdentifier: "HelpPageCell")
        self.noLbl.config(color: TEXT_TERTIARY_COLOR, size: 17, align: .center, text: "no_help_data")

        self.navigationView.elevationEffect()
        self.floatingBtnView.backgroundColor = PRIMARY_COLOR
        self.floatingBtnView.elevationEffect()
        // Banner Ads
//        self.bannerAds()
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int{
        return helpArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let helpCell = tableView.dequeueReusableCell(withIdentifier: "HelpPageCell", for: indexPath) as! HelpPageCell
        let helpDict:NSDictionary =  helpArray.object(at: indexPath.row) as! NSDictionary
        helpCell.helpTitle.text = helpDict.value(forKey: "title") as? String
        return helpCell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 70
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        let helpDict:NSDictionary =  helpArray.object(at: indexPath.row) as! NSDictionary
        let contentObj = ContentWebPage()
        contentObj.viewType = "1"
        contentObj.helpDict = helpDict
        contentObj.modalPresentationStyle = .fullScreen
        self.present(contentObj, animated: true, completion: nil)
    }
    
    
    @IBAction func contactBtnTapped(_ sender: Any) {
        let contactObj = ContactMailPage()
        contactObj.modalPresentationStyle = .overCurrentContext
        contactObj.modalTransitionStyle = .crossDissolve
        self.present(contactObj, animated: true, completion: nil)
        
    }
    
    //MARK: Get Help pages content
    func getHelpPageContentService()  {
        let helpServiceObj = LoginWebServices()
        helpServiceObj.getHelpDetails(onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if(status.isEqual(to: STATUS_TRUE)){
                self.helpArray =  response.value(forKey: "result")  as! NSArray
                self.helpTableView.reloadData()
                self.checkAvailablity()
            }else if(status.isEqual(to: STATUS_FALSE)){
                self.checkAvailablity()
            }
        }, onFailure:{ errorResponse in
        })
    }
    
    func checkAvailablity(){
        if self.helpArray.count == 0{
            self.noLbl.isHidden = false
            self.helpTableView.isHidden = true
        }else{
            self.noLbl.isHidden = true
            self.helpTableView.isHidden = false
        }
    }

}
/*
extension HelpPage: GADBannerViewDelegate {
    func bannerAds() {
        if (BANNER_AD_ENABLED == true) {
            self.bannerView.isHidden = true
            self.configAds()
        }
        else {
            self.bannerView.isHidden = true
        }
    }
    func configAds()  {
        bannerView.adUnitID = AD_UNIT_ID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    //banner view delegate
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: self.helpTableView.frame.width, height: 50))
        self.helpTableView.tableFooterView = bottomView
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("BANNER ERROR \(error.localizedDescription)")
    }
}
*/
