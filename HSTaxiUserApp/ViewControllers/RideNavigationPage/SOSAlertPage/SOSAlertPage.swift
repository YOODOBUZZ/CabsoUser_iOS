//
//  SOSAlertPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 18/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation

class SOSAlertPage: UIViewController,MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var messageAlertImageView: UIImageView!
    @IBOutlet weak var callAlertImageView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var msgLbl: UILabel!
    @IBOutlet var useEmgLbl: UILabel!
    @IBOutlet var emgCallBtn: UIButton!
    @IBOutlet var emgMsgBtn: UIButton!
    
    var myLocation = CLLocationCoordinate2D()
    
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
            self.msgLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.useEmgLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emgCallBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emgCallBtn.contentHorizontalAlignment = .right
            self.emgMsgBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.messageAlertImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.callAlertImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emgMsgBtn.contentHorizontalAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.msgLbl.transform = .identity
            self.useEmgLbl.transform = .identity
            self.emgCallBtn.transform = .identity
            self.emgCallBtn.contentHorizontalAlignment = .left
            self.emgMsgBtn.transform = .identity
            self.callAlertImageView.transform = .identity
            self.messageAlertImageView.transform = .identity
            self.emgMsgBtn.contentHorizontalAlignment = .left
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Initial set up
    func setupInitialDetails()  {
        self.navigationView.elevationEffect()
        Utility.shared.fetchAdminData()
        self.useEmgLbl.config(color: TEXT_PRIMARY_COLOR, size: 25, align: .center, text: "user_emg")
        self.msgLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .center, text: EMPTY_STRING)
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 18.0
        paragraphStyle.maximumLineHeight = 18.0
        paragraphStyle.minimumLineHeight = 18.0
        paragraphStyle.alignment = .center
        let ats = [NSAttributedStringKey.font: UIFont(name: APP_FONT_REGULAR, size: 15)!, NSAttributedStringKey.paragraphStyle: paragraphStyle]
        self.msgLbl.attributedText = NSAttributedString(string: Utility.shared.getLanguage()?.value(forKey: "emg_content") as! String, attributes: ats)
        
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "emergency_alert")
        self.emgCallBtn.config(color: RED_COLOR, size: 17, align: .left, title: "emg_call")
        self.emgMsgBtn.config(color: RED_COLOR, size: 17, align: .left, title: "emg_contact")
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emgCallBtnTapped(_ sender: Any) {
        if let url = URL(string: "tel://\(Utility().policeNo()!)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func alertEmgContactBtnTapped(_ sender: Any) {
        if (UserModel.shared.getEmergenctContact() != nil) {
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "Emergency: My Location: https://maps.googleapis.com/maps/api/staticmap?center=\(myLocation.latitude),\(myLocation.longitude)&zoom=16&size=400x200&sensor=false&key=\(GOOGLE_API_KEY)&maptype=roadmap&markers=color:red%7Clabel:S%7C\(myLocation.latitude),\(myLocation.longitude)"
                controller.recipients = self.getEmergencyNo() as? [String]
                print(controller.body ?? EMPTY_STRING)
                controller.messageComposeDelegate = self
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }else{
            Utility.shared.showAlert(msg: "no_emg_Alert", status: "")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    func getEmergencyNo() ->NSMutableArray {
        var contactString = String()
        var contactArray = NSMutableArray()

        for contact in UserModel.shared.getEmergenctContact()! {
            let tempArray = NSMutableArray.init(array: [contact])
            var tempDict = NSDictionary()
            tempDict = tempArray.object(at: 0) as! NSDictionary
            let tempDetails = NSMutableDictionary.init(dictionary:tempDict)
            let contactStr:String = tempDetails.value(forKey: "phone_no") as! String
            contactString += "\"\(contactStr)\","
            contactArray.add(contactStr)
        }
        return contactArray
    }
    
}
