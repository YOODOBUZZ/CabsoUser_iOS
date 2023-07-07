//
//  AddEditContactPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 26/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import Toast_Swift

protocol editContactDelegate {
    func notifyToUpdateContact()
}
class AddEditContactPage: UIViewController,UITextFieldDelegate,CNContactPickerDelegate {
    var viewType = String()
    var contactName = String()
    var contactNo = String()
    var indexNo = Int()

    var contactArray = NSMutableArray()

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var contactNameTF: FloatLabelTextField!
    @IBOutlet var contactNoTF: FloatLabelTextField!
    @IBOutlet var pickBtn: UIButton!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var nameBorderLbl: UILabel!
    @IBOutlet var numberBorderLbl: UILabel!
    
    var delegate : editContactDelegate?
    var contactStore = CNContactStore()
    let contactPicker = CNContactPickerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.contactNameTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.contactNameTF.textAlignment = .right
            self.contactNoTF.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.contactNoTF.textAlignment = .right
            self.pickBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.pickBtn.contentHorizontalAlignment = .right
            self.submitBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.contactNameTF.transform = .identity
            self.contactNameTF.textAlignment = .left
            self.contactNoTF.transform = .identity
            self.contactNoTF.textAlignment = .left
            self.pickBtn.transform = .identity
            self.pickBtn.contentHorizontalAlignment = .left
            self.submitBtn.transform = .identity
        }
     }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: set up intial details
    func setupInitialDetails()  {
        contactPicker.delegate = self
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "contact")
        self.submitBtn.config(color: .white, size: 17, align: .center, title: "save")
        self.submitBtn.backgroundColor = PRIMARY_COLOR
        self.submitBtn.cornerMiniumRadius()
        self.pickBtn.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, title: "pick_contact")
        self.contactNameTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "name")
        self.contactNoTF.config(color: TEXT_PRIMARY_COLOR, size: 17, align: .left, placeHolder: "phonenumber")
        if self.viewType == "1" {
            self.contactNameTF.text = contactName
            self.contactNoTF.text = contactNo
        }
    }

    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func pickContactBtnTapped(_ sender: Any) {
        DispatchQueue.main.async{

            self.requestForAccess { (accessGranted) in
            if accessGranted == true{
                self.contactPicker.modalPresentationStyle = .fullScreen
                self.present(self.contactPicker,animated: true, completion: nil)
            }
        }
        }
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        if isValidationSuccess() {
            let mutableDict = NSMutableDictionary()
            mutableDict.setValue(self.contactNameTF.text, forKey: "name")
            mutableDict.setValue(self.contactNoTF.text, forKey: "phone_no")
            mutableDict.setValue("0", forKey: "menuShow")
            mutableDict.setValue(self.contactArray.count, forKey: "id")
            if self.viewType == "1"{
                self.contactArray.removeObject(at: indexNo)
                self.contactArray.insert(mutableDict, at: indexNo)
            }else{
                self.contactArray.addObjects(from: [mutableDict])
            }
            UserModel.shared.removeEmergencyContact()
            UserModel.shared.setEmergencyContact(contactArray: self.contactArray)
            delegate?.notifyToUpdateContact()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Check text field validation
    func isValidationSuccess() -> Bool {
        var status:Bool = false
        if self.contactNameTF.isEmptyValue(){
            self.nameBorderLbl.backgroundColor = RED_COLOR
            self.contactNameTF.setAsInvalidTF("enter_name", in: self.view)
        }else if self.contactNoTF.isEmptyValue(){
            self.numberBorderLbl.backgroundColor = RED_COLOR
            self.contactNoTF.setAsInvalidTF("enter_phone", in: self.view)
        }else{
            status = true
            self.clearValidation()
        }
        return status
    }
    
    //MARK: Clear text field validation
    func clearValidation(){
        self.contactNoTF.setAsValidTF()
        self.contactNameTF.setAsValidTF()

        self.numberBorderLbl.backgroundColor = SEPARTOR_COLOR
        self.nameBorderLbl.backgroundColor = SEPARTOR_COLOR
    }
    
    //MARK: Textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.clearValidation()
        if textField.tag == 1 {
            let set = NSCharacterSet.init(charactersIn:ALPHA_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            return true//set.isSuperset(of: characterSet)
        }else if textField.tag == 2{
            let set = NSCharacterSet.init(charactersIn:COUNTRY_PREDICT)
            let characterSet = CharacterSet(charactersIn: string)
            return set.isSuperset(of: characterSet)
        }
        return true
    }
 
    // Ask contact access permisssion
    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async{
                            self.contactPermissionAlert()
                        }
                    }
                }
            })
        default:
            completionHandler(false)
        }
    }
    //MARK:contact restriction alert
    func contactPermissionAlert()  {
        AJAlertController.initialization().showAlert(aStrMessage: "contact_permission", aCancelBtnTitle: "cancel", aOtherBtnTitle: "settings", status: "", completion: { (index, title) in
            print(index,title)
            if index == 1{
                //open settings page
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
    }
    
    // MARK: contact picker view delegate
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        if contact.isKeyAvailable(CNContactPhoneNumbersKey){
            // handle the selected contact
            if contact.phoneNumbers.count != 0{
            if (contact.phoneNumbers[0].value).value(forKey: "digits") != nil {
                
            self.contactNameTF.text = contact.givenName
            self.contactNoTF.text = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
            }
            }else{
                self.view.makeToast(Utility().getLanguage()!.value(forKey: "choose_valid_contact") as? String, align: "")
            }
        }
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancelled picking a contact")

    }
}
