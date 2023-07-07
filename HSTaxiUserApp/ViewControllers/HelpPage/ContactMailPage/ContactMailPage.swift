//
//  ContactMailPage.swift
//  HSTaxiDriverApp
//
//  Created by APPLE on 24/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class ContactMailPage: UIViewController,UITextFieldDelegate {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var emailTF: FloatLabelTextField!
    @IBOutlet var subjectTF: FloatLabelTextField!
    @IBOutlet var nameTF: FloatLabelTextField!
    @IBOutlet var messageTF: FloatLabelTextField!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var sendBtn: UIButton!
    
    @IBOutlet var emailBorderLbl: UILabel!
    @IBOutlet var subjectBorderLbl: UILabel!
    
    @IBOutlet var messageBorderLbl: UILabel!
    @IBOutlet var nameBorderLbl: UILabel!
    
    @IBOutlet var containerView: UIView!
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
            self.emailTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.emailTF.textAlignment = .right
            self.subjectTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.subjectTF.textAlignment = .right
            self.nameTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.nameTF.textAlignment = .right
            self.messageTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.messageTF.textAlignment = .right
            self.cancelBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.sendBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.emailTF.transform = .identity
            self.emailTF.textAlignment = .left
            self.subjectTF.transform = .identity
            self.subjectTF.textAlignment = .left
            self.nameTF.transform = .identity
            self.nameTF.textAlignment = .left
            self.messageTF.transform = .identity
            self.messageTF.textAlignment = .left
            self.cancelBtn.transform = .identity
            self.sendBtn.transform = .identity
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: set up intial details
    func setupInitialDetails()  {
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 25, align: .center, text: "contact")
        self.nameTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "name")
        self.emailTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "email")
        self.subjectTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "subject")
        self.messageTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "message")
        self.sendBtn.config(color: .white, size: 17, align: .center, title: "send")
        self.cancelBtn.config(color: TEXT_TERTIARY_COLOR, size: 17, align: .center, title: "cancel")
        self.sendBtn.cornerMiniumRadius()
        self.sendBtn.backgroundColor = PRIMARY_COLOR
    }

    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        if isValidationSuccess() {
        HPLActivityHUD.showActivity(with: .withMask)
            let contactObj = UserServices()
            contactObj.contactUs(name: self.nameTF.text!, email: self.emailTF.text!, subject: self.subjectTF.text!, message: self.messageTF.text!, onSuccess: {response in
                let status:NSString = response.value(forKey: "status") as! NSString
                if(status.isEqual(to: STATUS_TRUE)){
                    HPLActivityHUD.dismiss()
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: response.value(forKey: "message") as! String, status: "", completion: { (index, title) in
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            })
        }
    }
    
    //MARK: Check text field validation
    func isValidationSuccess() -> Bool {
        var status:Bool = false
        if self.nameTF.isEmptyValue(){
            self.nameBorderLbl.backgroundColor = RED_COLOR
            self.nameTF.setAsInvalidTF("enter_name", in: self.containerView)
        }else if (self.nameTF.text?.count)!<3{
            self.nameBorderLbl.backgroundColor = RED_COLOR
            self.nameTF.setAsInvalidTF("name_limit", in: self.view)
        }else if self.emailTF.isEmptyValue() {
            self.emailBorderLbl.backgroundColor = RED_COLOR
            self.emailTF.setAsInvalidTF("enter_email", in: self.containerView)
        }else if !self.emailTF.isValidEmail(){
            self.emailBorderLbl.backgroundColor = RED_COLOR
            self.emailTF.setAsInvalidTF("enter_valid_email", in: self.containerView)
        }else if self.subjectTF.isEmptyValue(){
            self.subjectBorderLbl.backgroundColor = RED_COLOR
            self.subjectTF.setAsInvalidTF("enter_subject", in: self.containerView)
        }else if self.messageTF.isEmptyValue(){
            self.subjectBorderLbl.backgroundColor = RED_COLOR
            self.messageTF.setAsInvalidTF("enter_msg", in: self.containerView)
        }else{
            status = true
            self.clearValidation()
        }
        return status
    }
    //MARK: Clear text field validation
    func clearValidation()  {
        self.emailTF.setAsValidTF()
        self.subjectTF.setAsValidTF()
        self.nameTF.setAsValidTF()
        self.messageTF.setAsValidTF()
        
        self.emailBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.subjectBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.nameBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.messageBorderLbl.backgroundColor = SEPARTOR_COLOR
    }
    
    //MARK: Textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.clearValidation()
        if textField.tag == 1 || textField.tag == 3 || textField.tag == 4 {
            let set = NSCharacterSet.init(charactersIn:ALPHA_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            return true //set.isSuperset(of: characterSet)
        }
        return true
    }
    
}
