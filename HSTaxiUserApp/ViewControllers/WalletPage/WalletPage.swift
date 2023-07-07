//
//  WalletPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 20/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import Braintree
import BraintreeDropIn
import LocalAuthentication
import GoogleMobileAds

class WalletPage: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var addMoneyLbl: UILabel!
    @IBOutlet var safeLbl: UILabel!
    @IBOutlet var historyBtn: UIButton!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var rideNowBtn: UIButton!
    @IBOutlet var moneyBorderLbl: UILabel!
    @IBOutlet var currencyLbl: UILabel!
    @IBOutlet var usingMoneyLbl: UILabel!
    @IBOutlet var moneyTF: FloatLabelTextField!

    var clientTokenOrTokenizationKey = String()
    
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
            self.addMoneyLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.safeLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.historyBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.historyBtn.contentHorizontalAlignment = .left
            self.addBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideNowBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideNowBtn.contentHorizontalAlignment = .right
            self.currencyLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.currencyLbl.textAlignment = .right
            self.usingMoneyLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.usingMoneyLbl.textAlignment = .left
            self.moneyTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.moneyTF.textAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.addMoneyLbl.transform = .identity
            self.safeLbl.transform = .identity
            self.historyBtn.transform = .identity
            self.historyBtn.contentHorizontalAlignment = .right
            self.addBtn.transform = .identity
            self.rideNowBtn.transform = .identity
            self.rideNowBtn.contentHorizontalAlignment = .left
            self.currencyLbl.transform = .identity
            self.currencyLbl.textAlignment = .left
            self.usingMoneyLbl.transform = .identity
            self.usingMoneyLbl.textAlignment = .right
            self.moneyTF.transform = .identity
            self.moneyTF.textAlignment = .left
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: set up intial details
    func setupInitialDetails()  {
        print("currency \(Utility().currency()!)")
        Utility.shared.fetchAdminData()
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "balance")
        self.setWalletAmount()
        self.addMoneyLbl.config(color: TEXT_PRIMARY_COLOR, size: 30, align: .center, text: "add_wallet_money")
        self.safeLbl.config(color: TEXT_SECONDARY_COLOR, size: 17, align: .center, text: "safe_quick")
        self.addBtn.config(color: .white, size: 17, align: .center, title: "add_money")
        self.addBtn.cornerMiniumRadius()
        self.addBtn.backgroundColor = PRIMARY_COLOR
        self.moneyTF.delegate = self
        
        self.historyBtn.config(color: TEXT_SECONDARY_COLOR, size: 14, align: .right, title: "history")
        self.usingMoneyLbl.config(color: TEXT_SECONDARY_COLOR, size: 12, align: .right, text: "money_only_using")
        self.rideNowBtn.config(color: GREEN_COLOR, size: 12, align: .left, title: "ride_now")
        self.currencyLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: EMPTY_STRING)
        self.currencyLbl.text = Utility().currency()! as String
        self.moneyTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "enter_amount")
        self.configBrainTreeToken()
//        self.bannerAds()
    }
    @IBAction func backBtnTapped(_ sender: Any) {
        self.moneyTF.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func historyBtnTapped(_ sender: Any) {
        let historyObj  = WalletHistory()
        historyObj.modalPresentationStyle = .fullScreen
        self.present(historyObj, animated: true, completion: nil)
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        if moneyTF.isEmptyValue(){
            self.moneyTF.setAsInvalidTF("enter_amount", in: self.view)
            self.moneyBorderLbl.backgroundColor = RED_COLOR
        }else{
            self.moneyTF.setAsValidTF()
            self.moneyBorderLbl.backgroundColor = SEPARTOR_COLOR
            self.authenticateUser()
        }
    }
    
    @IBAction func ridenowBtnTapped(_ sender: Any) {
        Utility.shared.goToHomePage()
    }
    
    //MARK: authenticate with touch id
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "To access the secure data"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
                [unowned self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.brainTreePayment()
                    } else {
                        let ac = UIAlertController(title: "Sorry!", message:"Authentication failed" , preferredStyle: .alert)
                        if UserModel.shared.getAppLanguage() == "Arabic" {
                            ac.view.semanticContentAttribute = .forceRightToLeft
                        }
                        else {
                            ac.view.semanticContentAttribute = .forceLeftToRight
                        }
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            self.brainTreePayment()
        }
    }
    
    func configBrainTreeToken()  {
        let getTokenObj = PaymentServices()
        getTokenObj.getBrainTreeToken(onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                self.addBtn.isUserInteractionEnabled = true
                self.clientTokenOrTokenizationKey = response.value(forKey: "clientToken") as! String
            }else if status.isEqual(to: STATUS_FALSE){
                Utility.shared.showAlert(msg: "wrong_braintreeToken", status: "")
                self.addBtn.isUserInteractionEnabled = false
            }
        })
    }
    //braintree payment
    func brainTreePayment()  {
        // Create a BTDropInViewController
        let request =  BTDropInRequest()
        request.paypalDisabled = false
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
                self.view.makeToast(Utility.shared.getLanguage()?.value(forKey: "server_alert") as? String, align: UserModel.shared.getAppLanguage() ?? "English")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
                self.view.makeToast(Utility.shared.getLanguage()?.value(forKey: "payment_cancelled") as? String, align: UserModel.shared.getAppLanguage() ?? "English")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
                HPLActivityHUD.showActivity(with: .withMask)
                self.addMoneyToWallet(nonce: result.paymentMethod?.nonce ?? EMPTY_STRING)
            }
            controller.dismiss(animated: true, completion: nil)
        }
        if UserModel.shared.getAppLanguage() == "Arabic" {
            dropIn?.view.semanticContentAttribute = .forceRightToLeft
        }
        else {
            dropIn?.view.semanticContentAttribute = .forceLeftToRight
        }
        self.present(dropIn!, animated: true, completion: nil)
      
    }
        

    
    //update nonce to server
    func addMoneyToWallet(nonce:String)   {
        let paymentObj = PaymentServices()
        paymentObj.addToWallet(amount: self.moneyTF.text!, paynonce: nonce, onSuccess: {response in
            HPLActivityHUD.dismiss()
        let status:NSString = response.value(forKey: "status") as! NSString
        if status.isEqual(to: STATUS_TRUE){
            self.moneyTF.text =  EMPTY_STRING
            UserModel.shared.setWalletAmt(wallet_amt:response.value(forKey: "walletmoney") as! NSNumber)
            self.setWalletAmount()
            Utility.shared.showAlert(msg:"amount_added_to_wallet", status: "")
        }else{
            Utility.shared.showAlert(msg: response.value(forKey: "message") as! String, status: "")
        }
    })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let full_string = textField.text!+string
            let set = NSCharacterSet.init(charactersIn:NUMERIC_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            if full_string.count>6{
                return false
            }
            return set.isSuperset(of: characterSet)
    }
    
    //set wallet amount instantly
    func setWalletAmount()  {
        let Amt:NSNumber = UserModel.shared.getWalletAmt()!
        let walletAmt:String = "\(Utility().currency()!) \(Amt)"
        let msgString:String = Utility.shared.getLanguage()?.value(forKey: "balance") as! String
        let walletString = "\(msgString) \(String(walletAmt))"
        
        let range:NSRange = NSRange.init(location: msgString.count+1, length: walletAmt.count)
        var attributedString = NSMutableAttributedString()
                attributedString = NSMutableAttributedString(string: walletString, attributes: [NSAttributedStringKey.font:UIFont(name: APP_FONT_REGULAR, size: 20)!])
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: RED_COLOR, range: range)
        self.titleLbl.attributedText = attributedString
    }
}
//extension WalletPage: GADBannerViewDelegate {
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
