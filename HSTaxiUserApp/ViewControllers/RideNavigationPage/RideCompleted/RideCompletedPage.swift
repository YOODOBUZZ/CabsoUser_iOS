//
//  RideCompletedPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 11/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import Braintree
import BraintreeDropIn
import LocalAuthentication

class RideCompletedPage: UIViewController ,UIAlertViewDelegate,reviewDelegate{
    
    @IBOutlet weak var tickImageview: UIImageView!
    @IBOutlet var rideCompletedLbl: UILabel!
    @IBOutlet var subTitleLbl: UILabel!
    @IBOutlet var useWalletLbl: UILabel!
    @IBOutlet var walletAmtLbl: UILabel!
    @IBOutlet var billDetailsLbl: UILabel!
    @IBOutlet var rideFareLbl: UILabel!
    @IBOutlet var rideFareAmtLbl: UILabel!
    @IBOutlet var taxLbl: UILabel!
    @IBOutlet var taxAmtLbl: UILabel!
    @IBOutlet var walletDetailsLbl: UILabel!
    @IBOutlet var walletDetailsAmtLbl: UILabel!
    @IBOutlet var totalBillLbl: UILabel!
    @IBOutlet var totalBillAmtLbl: UILabel!
    @IBOutlet var paymentMethodLbl: UILabel!
    @IBOutlet var paypalLbl: UILabel!
    @IBOutlet var codLbl: UILabel!
    @IBOutlet var payBtn: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var walletTicBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    var isWallet = Bool()
    var clientTokenOrTokenizationKey = String()
    var onride_id = String()
    var paymentDict = NSDictionary()
    var walletAmt =  NSNumber()
    var walletStatus = String()
    let reviewObj = WriteReview()
    @IBOutlet var cashBtn: UIButton!
    @IBOutlet var paypalBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUpInitialDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideCompletedLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.subTitleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.useWalletLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.useWalletLbl.textAlignment = .right
            self.walletAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.walletAmtLbl.textAlignment = .right
            self.billDetailsLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.billDetailsLbl.textAlignment = .right
            self.rideFareLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideFareLbl.textAlignment = .right
            self.rideFareAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideFareAmtLbl.textAlignment = .left
            self.taxLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.taxLbl.textAlignment = .right
            self.taxAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.taxAmtLbl.textAlignment = .left
            self.walletDetailsLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.walletDetailsLbl.textAlignment = .right
            self.walletDetailsAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.walletDetailsAmtLbl.textAlignment = .left
            self.totalBillLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.totalBillLbl.textAlignment = .right
            self.totalBillAmtLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.totalBillAmtLbl.textAlignment = .left
            self.paymentMethodLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paymentMethodLbl.textAlignment = .right
            self.paypalLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paypalLbl.textAlignment = .right
            self.codLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.codLbl.textAlignment = .right
            self.payBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.walletTicBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.cashBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.paypalBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.tickImageview.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.rideCompletedLbl.transform = .identity
            self.subTitleLbl.transform = .identity
            self.useWalletLbl.transform = .identity
            self.useWalletLbl.textAlignment = .left
            self.walletAmtLbl.transform = .identity
            self.walletAmtLbl.textAlignment = .left
            self.billDetailsLbl.transform = .identity
            self.billDetailsLbl.textAlignment = .left
            self.rideFareLbl.transform = .identity
            self.rideFareLbl.textAlignment = .left
            self.rideFareAmtLbl.transform = .identity
            self.rideFareAmtLbl.textAlignment = .right
            self.taxLbl.transform = .identity
            self.taxLbl.textAlignment = .left
            self.taxAmtLbl.transform = .identity
            self.taxAmtLbl.textAlignment = .right
            self.walletDetailsLbl.transform = .identity
            self.walletDetailsLbl.textAlignment = .left
            self.walletDetailsAmtLbl.transform = .identity
            self.walletDetailsAmtLbl.textAlignment = .right
            self.totalBillLbl.transform = .identity
            self.totalBillLbl.textAlignment = .left
            self.totalBillAmtLbl.transform = .identity
            self.totalBillAmtLbl.textAlignment = .right
            self.paymentMethodLbl.transform = .identity
            self.paymentMethodLbl.textAlignment = .left
            self.paypalLbl.transform = .identity
            self.paypalLbl.textAlignment = .left
            self.codLbl.transform = .identity
            self.codLbl.textAlignment = .left
            self.payBtn.transform = .identity
            self.walletTicBtn.transform = .identity
            self.cashBtn.transform = .identity
            self.paypalBtn.transform = .identity
            self.tickImageview.transform = .identity
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpInitialDetails()  {
        Utility.shared.fetchAdminData()
        self.getPaymentDetails()
        self.isWallet = false
        self.walletStatus = "0"
//        self.walletTicBtn.backgroundColor = PRIMARY_COLOR
//        self.walletTicBtn.layer.cornerRadius = 5
//        self.walletTicBtn.clipsToBounds = true
        walletAmt = UserModel.shared.getWalletAmt()!
        self.topView.elevationEffect()
        scrollView.contentSize = CGSize.init(width:0 , height: 720)
        self.rideCompletedLbl.config(color: TEXT_PRIMARY_COLOR, size: 30, align: .center, text: "ride_completed")
        self.subTitleLbl.config(color: TEXT_SECONDARY_COLOR, size: 14, align: .center, text: "cash_or_code")
        self.useWalletLbl.config(color: TEXT_PRIMARY_COLOR, size: 18, align: .left, text: "use_wallet")
        self.billDetailsLbl.config(color: TEXT_PRIMARY_COLOR, size: 18, align: .left, text: "bill_details")
        self.paymentMethodLbl.config(color: TEXT_PRIMARY_COLOR, size: 18, align: .left, text: "payment_method")
        self.walletAmtLbl.config(color: TEXT_SECONDARY_COLOR, size: 14, align: .left, text: EMPTY_STRING)
        
        self.rideFareLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: "ride_fare")
        self.taxLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: "tax")
        self.walletDetailsLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: "wallet")
        self.totalBillLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: "total_bill")

        self.rideFareAmtLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        self.taxAmtLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        self.walletDetailsAmtLbl.config(color: RED_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        self.totalBillAmtLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        
        self.paypalLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: "paypal")
        self.codLbl.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, text: "cash")
        
        self.payBtn.config(color: .white, size: 17, align: .center, title: "pay")
        self.payBtn.backgroundColor = PRIMARY_COLOR
        self.payBtn.cornerMiniumRadius()
        self.payBtn.setBorder(color:PRIMARY_COLOR)
        self.configBrainTreeToken()
    }
    func setBillDetails(paymentDict:NSDictionary)  {
        if let tax = paymentDict.value(forKey: "ride_tax") as? NSNumber, let rideFare:NSNumber = paymentDict.value(forKey: "ride_fare") as? NSNumber, let totalAmt:NSNumber = paymentDict.value(forKey: "ride_total") as? NSNumber {
            self.walletAmtLbl.text = "\(Utility().currency()!) \(walletAmt)"
            self.rideFareAmtLbl.text = "\(Utility().currency()!) \(Double(round(Double(1000*Int(truncating: rideFare)))/1000))"
            self.taxAmtLbl.text = "\(Utility().currency()!) \(tax)"
            self.walletDetailsAmtLbl.text = "\(Utility().currency()!) 0.00"
            self.totalBillAmtLbl.text = "\(Utility().currency()!) \(Double(round(Double(1000*Int(truncating: totalAmt)))/1000))"
        }
    }
    
    func configBrainTreeToken()  {
        let getTokenObj = PaymentServices()
        getTokenObj.getBrainTreeToken(onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                self.clientTokenOrTokenizationKey = response.value(forKey: "clientToken") as! String
            }else if status.isEqual(to: STATUS_FALSE){
                Utility.shared.showAlert(msg: "wrong_braintreeToken", status: "")
            }
        })
    }
    @IBAction func paypalBtnTapped(_ sender: Any) {
        //authenticate before payment
       self.authenticateUser()
    }
    
 
    //braintree payment
    func brainTreePayment()  {
        // Create a BTDropInViewController
        let request =  BTDropInRequest()
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
                self.checkOut(nonce: result.paymentMethod?.nonce ?? EMPTY_STRING)
            }
            controller.dismiss(animated: true, completion: nil)
        }
        if dropIn != nil {
            self.present(dropIn!, animated: true, completion: nil)
        }
    }
    
    //cash on delivery
    @IBAction func codBtnTapped(_ sender: Any) {
        let paymentObj = PaymentServices()
        paymentObj.paybyCash(amount: self.trim(str:self.totalBillAmtLbl.text!),  onride_id: self.onride_id,iswallet:self.walletStatus, walletmoney: self.trim(str:self.walletDetailsAmtLbl.text!),basefare: self.paymentDict.value(forKey: "basefare") as! NSNumber, commissionamount: self.paymentDict.value(forKey: "commissionamount") as! NSNumber, tax: self.paymentDict.value(forKey: "ride_tax") as! NSNumber,driver_id:self.paymentDict.value(forKey: "driver_id") as! String, onSuccess: {response in
          
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                if self.walletStatus == "1"{
                    UserModel.shared.setWalletAmt(wallet_amt: response.value(forKey: "walletmoney") as? NSNumber ?? 0)
                }
                let successObj = PaymentSuccessPage()
                successObj.delegate = self
                successObj.onride_id = self.onride_id
                successObj.paymentDict = self.paymentDict
                successObj.walletAmt = self.walletDetailsAmtLbl.text!
                successObj.totalAmount = self.totalBillAmtLbl.text!
                successObj.modalPresentationStyle = .fullScreen
                self.present(successObj, animated: true, completion: nil)
            }else{
                Utility.shared.showAlert(msg: response.value(forKey: "message") as! String, status: "")
            }
        })
    }
    //pay by wallet
    @IBAction func payBtnTapped(_ sender: Any) {
        let paymentObj = PaymentServices()
        if self.walletDetailsAmtLbl.text != nil {
            paymentObj.paybyCash(amount: "0", onride_id: self.onride_id,iswallet:self.walletStatus, walletmoney: self.trim(str:self.walletDetailsAmtLbl.text!), basefare: self.paymentDict.value(forKey: "basefare") as! NSNumber, commissionamount: self.paymentDict.value(forKey: "commissionamount") as! NSNumber, tax: self.paymentDict.value(forKey: "ride_tax") as! NSNumber,driver_id:self.paymentDict.value(forKey: "driver_id") as! String, onSuccess: {response in
               
                let status:NSString = response.value(forKey: "status") as! NSString
                if status.isEqual(to: STATUS_TRUE){
                    if self.walletStatus == "1"{
                        UserModel.shared.setWalletAmt(wallet_amt: response.value(forKey: "walletmoney") as! NSNumber)
                    }
                    let successObj = PaymentSuccessPage()
                    successObj.onride_id = self.onride_id
                    successObj.paymentDict = self.paymentDict
                    successObj.walletAmt = self.walletDetailsAmtLbl.text!
                    successObj.totalAmount = self.totalBillAmtLbl.text!
                    successObj.modalPresentationStyle = .fullScreen
                    self.present(successObj, animated: true, completion: nil)
                }else{
                    Utility.shared.showAlert(msg: response.value(forKey: "message") as! String, status: "")
                }
            })
        }
        
    }

    func checkOut(nonce:String)   {
        let paymentObj = PaymentServices()
        paymentObj.paybyCard(amount: self.trim(str:self.totalBillAmtLbl.text!), paynonce: nonce, onride_id: self.onride_id,iswallet:self.walletStatus, walletmoney: self.trim(str: self.walletDetailsAmtLbl.text!), basefare: self.paymentDict.value(forKey: "basefare") as! NSNumber, commissionamount: self.paymentDict.value(forKey: "commissionamount") as! NSNumber, tax: self.paymentDict.value(forKey: "ride_tax") as! NSNumber,driver_id:self.paymentDict.value(forKey: "driver_id") as! String, onSuccess: {response in
            
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                if self.walletStatus == "1"{
                    if response.value(forKey: "walletmoney") != nil{
                    UserModel.shared.setWalletAmt(wallet_amt: response.value(forKey: "walletmoney") as! NSNumber)
                    }
                }
                let successObj = PaymentSuccessPage()
                successObj.onride_id = self.onride_id
                successObj.paymentDict = self.paymentDict
                successObj.walletAmt = self.walletDetailsAmtLbl.text!
                successObj.totalAmount = self.totalBillAmtLbl.text!
                successObj.modalPresentationStyle = .fullScreen
                self.present(successObj, animated: true, completion: nil)
            }else{
                Utility.shared.showAlert(msg: response.value(forKey: "message") as! String, status: "")
            }
        })
    }
    
    @IBAction func walletTicTapped(_ sender: Any) {
        if walletAmt != 0 {
        let paypal = Utility.shared.getLanguage()?.value(forKey: "paypal") as! String
        let cash = Utility.shared.getLanguage()?.value(forKey: "cash") as! String
        let pay = Utility.shared.getLanguage()?.value(forKey: "pay") as! String
        let baseAmt:NSNumber = self.paymentDict.value(forKey: "ride_total") as! NSNumber
            let finalAmt:CGFloat = CGFloat(truncating: baseAmt) - CGFloat(truncating: walletAmt)

        if !isWallet {
            self.isWallet = true
            UIView.animate(withDuration: 0.5, animations: {
                self.walletTicBtn.setImage(#imageLiteral(resourceName: "tick_white"), for: .normal)
            })
            self.walletStatus = "1"
            
            if  CGFloat(truncating: baseAmt) < CGFloat(truncating: walletAmt){
                self.totalBillAmtLbl.text = "\(Utility().currency()!) 0.00"
                self.walletDetailsAmtLbl.text = "-\(Utility().currency()!) \(baseAmt)"
                self.bottomView.isHidden = false
                self.paypalBtn.isUserInteractionEnabled = false
                self.cashBtn.isUserInteractionEnabled = false
                self.payBtn.setTitle("\(pay) \(Utility().currency()!) \(baseAmt)", for: .normal)
            }else{
                self.bottomView.isHidden = true
                self.paypalBtn.isUserInteractionEnabled = true
                self.cashBtn.isUserInteractionEnabled = true
                self.paypalLbl.text = "\(paypal) \(Utility().currency()!) \(finalAmt)"
                self.codLbl.text = "\(cash) \(Utility().currency()!) \(finalAmt)"
                self.totalBillAmtLbl.text = "\(Utility().currency()!) \(finalAmt)"
                self.walletDetailsAmtLbl.text = "-\(Utility().currency()!) \(walletAmt)"
            }
        }else{
            self.paypalBtn.isUserInteractionEnabled = true
            self.cashBtn.isUserInteractionEnabled = true
            self.walletStatus = "0"
            self.isWallet = false
            self.walletTicBtn.setImage(#imageLiteral(resourceName: "checkbox"), for: .normal)
            self.walletDetailsAmtLbl.text = "\(Utility().currency()!) 0.00"
            self.totalBillAmtLbl.text = "\(baseAmt)"
            self.bottomView.isHidden = true
            self.paypalLbl.text = paypal
            self.codLbl.text = cash
        }
        }else{
            Utility.shared.showAlert(msg: "wallet_feature", status: "")
        }
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
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            self.brainTreePayment()
        }
    }
    //get payment details
    func getPaymentDetails(){
        let paymentInfo = RideServices()
        paymentInfo.getCompletedRideDetails(onride_id: self.onride_id, onSuccess: {response in
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                self.setBillDetails(paymentDict: response)
                self.paymentDict = response
            }else{
                Utility.shared.showAlert(msg: response.value(forKey: "message") as! String, status: "")
            }
        })
    }
    //MARK: Payment success page delegate
    func dismissSuccessAlert(onride_id: String) {
  
    }

    
    func trim(str:String) ->String  {
        
        let currencyString:String = str.trimmingCharacters(in: [" ","+","-"])
       let trimmedString:String = currencyString.replacingOccurrences(of: "\(Utility().currency()!)", with: "", options: NSString.CompareOptions.literal, range: nil)
        return trimmedString
    }
}
