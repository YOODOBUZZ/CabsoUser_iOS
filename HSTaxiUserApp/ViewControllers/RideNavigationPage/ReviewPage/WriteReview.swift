//
//  WriteReview.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 11/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import Cosmos

class WriteReview: UIViewController,UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var messageTextViewTitle: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet var ratingHeaderLbl: UILabel!
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var msgBorderLbl: UILabel!
    @IBOutlet var submitBtn: UIButton!
    
    @IBOutlet weak var msgTxtView: UITextView!
    var ratingValue = String()
    var onride_id = String()
    var review_msg = String()
    var viewType = String()
    var viewFrom = String()
    var review_Rating = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupInitialDetails()
        self.msgTxtView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.messageTextViewTitle.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.messageTextViewTitle.textAlignment = .right
            self.ratingHeaderLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.ratingHeaderLbl.textAlignment = .right
            self.submitBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.msgTxtView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.msgTxtView.textAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.messageTextViewTitle.transform = .identity
            self.messageTextViewTitle.textAlignment = .left
            self.ratingHeaderLbl.transform = .identity
            self.ratingHeaderLbl.textAlignment = .left
            self.submitBtn.transform = .identity
            self.msgTxtView.transform = .identity
            self.msgTxtView.textAlignment = .left
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: set up intial details
    func setupInitialDetails()  {
        self.navigationView.elevationEffect()
        self.ratingHeaderLbl.config(color: TEXT_SECONDARY_COLOR, size: 13, align:.left , text:"your_rating")
        //        self.msgTxtView.hint = Utility.shared.getLanguage()?.value(forKey: "your_msg") as! String
        self.msgTxtView.text = ""
        self.msgTxtView.textContainerInset = UIEdgeInsets.zero
        self.msgTxtView.textContainer.lineFragmentPadding = 0

        
        self.msgTxtView.textColor = TEXT_SECONDARY_COLOR
        self.msgTxtView.font = UIFont.init(name: APP_FONT_REGULAR, size: 16)
        self.messageTextViewTitle.config(color: TEXT_SECONDARY_COLOR, size: 13, align:.left , text:"your_msg")
        self.messageTextViewTitle.sizeToFit()
        self.msgTxtView.textAlignment = .left
        //        self.msgTxtView.titleTextColour = .clear
        //        self.msgTxtView.titleActiveTextColour = .clear
        
        self.submitBtn.config(color: .white, size: 17, align: .center, title: "submit")
        self.submitBtn.backgroundColor = PRIMARY_COLOR
        self.submitBtn.cornerMiniumRadius()
        self.submitBtn.setBorder(color:PRIMARY_COLOR)
        if viewType == "1" {
            self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "edit_review")
            //            self.msgTxtView.becomeFirstResponder()
            self.ratingView.rating = Double.init(self.review_Rating)
            self.msgTxtView.text = self.review_msg
            self.ratingValue = String(self.review_Rating)
        }else{
            self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "write_review")
        }
        self.ratingView.didFinishTouchingCosmos = { rating in
            self.ratingValue = "\(rating)"
            
        }
        
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
    //submit review
    @IBAction func submitBtnTapped(_ sender: Any) {
        if self.msgTxtView.text == "" {
            self.msgBorderLbl.backgroundColor = RED_COLOR
            Utility.shared.showAlert(msg: "enter_msg", status: "")
            
        }else{
            HPLActivityHUD.showActivity(with: .withMask)
            let ratingServiceObj = RideServices()
            ratingServiceObj.rideReview(onride_id: self.onride_id, review_message: self.msgTxtView.text!, rating: self.ratingValue, onSuccess: {response in
                HPLActivityHUD.dismiss()
                let status:NSString = response.value(forKey: "status") as! NSString
                if status.isEqual(to: STATUS_TRUE){
                    self.view.makeToast(response.value(forKey: "message") as? String, align: UserModel.shared.getAppLanguage() ?? "English")
                    if self.viewFrom == "history"{
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        AJAlertController.initialization().showAlertWithOkButton(aStrMessage: response.value(forKey: "message") as! String, status: "", completion: { (index, title) in
                            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                            Utility.shared.goToHomePage()
                        })
                    }
                }
            })
        }
    }
    
    //close prsent view
    @IBAction func closeBtnTapped(_ sender: Any) {
        if self.viewFrom == "history"{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            Utility.shared.goToHomePage()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.msgBorderLbl.backgroundColor = SEPARTOR_COLOR
        let set = NSCharacterSet.init(charactersIn:ALPHA_PREDICT)
        let characterSet = CharacterSet(charactersIn: string)
        return true //set.isSuperset(of: characterSet)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "" {
            //            self.messageTextViewTitle.isHidden = false
            self.msgTxtView.frame = CGRect(x: self.msgTxtView.frame.origin.x, y: self.msgTxtView.frame.origin.y + 5, width: self.msgTxtView.frame.width, height: self.msgTxtView.frame.height)

            self.messageTextViewTitle.frame = CGRect(x: self.messageTextViewTitle.frame.origin.x, y: self.msgTxtView.frame.origin.y - self.messageTextViewTitle.frame.height - 5, width: self.messageTextViewTitle.frame.width, height: self.messageTextViewTitle.frame.height)
            self.messageTextViewTitle.textColor = TEXT_SECONDARY_COLOR
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            //            self.messageTextViewTitle.isHidden = false
            self.msgTxtView.frame = CGRect(x: self.msgTxtView.frame.origin.x, y: self.msgTxtView.frame.origin.y - 5, width: self.msgTxtView.frame.width, height: self.msgTxtView.frame.height)

            self.messageTextViewTitle.frame = CGRect(x: self.messageTextViewTitle.frame.origin.x, y: self.msgTxtView.frame.origin.y , width: self.messageTextViewTitle.frame.width, height: self.messageTextViewTitle.frame.height)
            self.messageTextViewTitle.textColor = TEXT_SECONDARY_COLOR
        }
    }
//    func textViewDidChange(_ textView: UITextView) {
//        if textView.text == "" {
//            //            self.messageTextViewTitle.isHidden = true
//            self.messageTextViewTitle.frame = CGRect(x: self.messageTextViewTitle.frame.origin.x, y: self.msgTxtView.frame.origin.y, width: self.messageTextViewTitle.frame.width, height: self.messageTextViewTitle.frame.height)
//            self.messageTextViewTitle.textColor = UIColor(white: 67, alpha: 100)
//        }
//        else {
//            //            self.messageTextViewTitle.isHidden = false
//            self.messageTextViewTitle.frame = CGRect(x: self.messageTextViewTitle.frame.origin.x, y: self.msgTxtView.frame.origin.y - self.messageTextViewTitle.frame.height - 5, width: self.messageTextViewTitle.frame.width, height: self.messageTextViewTitle.frame.height)
//            self.messageTextViewTitle.textColor = TEXT_SECONDARY_COLOR
//        }
//    }
}
