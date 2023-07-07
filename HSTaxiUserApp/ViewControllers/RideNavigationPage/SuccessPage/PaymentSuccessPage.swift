//
//  PaymentSuccessPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 11/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
protocol reviewDelegate {
    func dismissSuccessAlert(onride_id:String)
}
class PaymentSuccessPage: UIViewController {

    @IBOutlet weak var tickIcon: UIImageView!
    @IBOutlet var rideCompletedLbl: UILabel!
    @IBOutlet var billDetailsLbl: UILabel!
    @IBOutlet var rideFareLbl: UILabel!
    @IBOutlet var rideFareAmtLbl: UILabel!
    @IBOutlet var taxLbl: UILabel!
    @IBOutlet var taxAmtLbl: UILabel!
    @IBOutlet var walletDetailsLbl: UILabel!
    @IBOutlet var walletDetailsAmtLbl: UILabel!
    @IBOutlet var totalBillLbl: UILabel!
    @IBOutlet var totalBillAmtLbl: UILabel!
    
    var paymentDict = NSDictionary()
    var walletAmt = String()
    var totalAmount = String()
    var onride_id = String()
    var delegate:reviewDelegate?

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
            self.billDetailsLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.billDetailsLbl.textAlignment = .right
            self.rideFareLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.rideFareLbl.textAlignment = .right
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
            self.tickIcon.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.rideCompletedLbl.transform = .identity
            self.billDetailsLbl.transform = .identity
            self.billDetailsLbl.textAlignment = .left
            self.rideFareLbl.transform = .identity
            self.rideFareLbl.textAlignment = .left
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
            self.tickIcon.transform = .identity

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpInitialDetails()  {
        self.rideCompletedLbl.config(color: TEXT_PRIMARY_COLOR, size: 25, align: .center, text: "payment_completed")
        self.billDetailsLbl.config(color: TEXT_PRIMARY_COLOR, size: 18, align: .left, text: "bill_details")
        self.rideFareLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: "ride_fare")
        self.taxLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: "tax")
        self.walletDetailsLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: "wallet")
        self.totalBillLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .left, text: "total_bill")
        self.rideFareAmtLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        self.taxAmtLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        self.walletDetailsAmtLbl.config(color: RED_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        self.totalBillAmtLbl.config(color: TEXT_SECONDARY_COLOR, size: 15, align: .right, text: EMPTY_STRING)
        
        self.setBillDetails()
    }
    func setBillDetails()  {
        
        let rideFare:NSNumber = paymentDict.value(forKey: "ride_fare") as! NSNumber
        let tax:NSNumber = paymentDict.value(forKey: "ride_tax") as! NSNumber
        let totalAmt:NSNumber = paymentDict.value(forKey: "ride_total") as! NSNumber
        
        self.rideFareAmtLbl.text = "\(Utility().currency()!) \(rideFare)"
        self.taxAmtLbl.text = "\(Utility().currency()!) \(tax)"
        self.totalBillAmtLbl.text = "\(Utility().currency()!) \(totalAmt)"
        self.walletDetailsAmtLbl.text = self.walletAmt

    }
    //dismiss current view and show review page
    @IBAction func closeBtnTapped(_ sender: Any) {
      let isReview = self.paymentDict.value(forKey: "isreview") as! String
        if isReview == "false"{
            let reviewObj = WriteReview()
            reviewObj.onride_id = self.onride_id
            reviewObj.modalPresentationStyle = .fullScreen
            self.present(reviewObj, animated: true, completion: nil)
        }else{
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            Utility.shared.goToHomePage()
            
        }
    }

}
