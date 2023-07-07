//
//  EmergecnyContactPage.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 26/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class EmergecnyContactPage: UIViewController,UITableViewDelegate,UITableViewDataSource,editContactDelegate {
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emergencyTableView: UITableView!
    var contactArray = NSMutableArray()
    
    @IBOutlet var no_contactLbl: UILabel!
    @IBOutlet var no_contactView: UIView!
    @IBOutlet var addcontactBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupInitialDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserModel.shared.getEmergenctContact() != nil {
            initalContactDetails()
        }
        self.checkAvailability()
        self.changeToRTL()
        self.emergencyTableView.reloadData()

    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.addcontactBtn.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.no_contactLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.addcontactBtn.transform = .identity
            self.no_contactLbl.transform = .identity
        }
    }
    //MARK: set up intial details
    func setupInitialDetails()  {
        self.navigationView.elevationEffect()
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text: "emergency_contact")
        emergencyTableView.register(UINib(nibName: "EmergencyCell", bundle: nil), forCellReuseIdentifier: "EmergencyCell")
        self.addcontactBtn.config(color: .white, size: 17, align: .center, title: "add")
        self.addcontactBtn.backgroundColor = PRIMARY_COLOR
        self.addcontactBtn.cornerMiniumRadius()
        self.no_contactView.isHidden = true
        self.no_contactLbl.config(color: TEXT_TERTIARY_COLOR, size: 15, align: .center, text: "no_contact")
        
        if IS_IPHONE_X {
            let adjustFrame = addcontactBtn.frame
            addcontactBtn.frame = CGRect.init(x: adjustFrame.origin.x, y: adjustFrame.origin.y-7, width: adjustFrame.size.width, height: adjustFrame.size.height)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addContactBtnTapped(_ sender: Any) {
        let addContactObj = AddEditContactPage()
        addContactObj.contactArray = self.contactArray
        addContactObj.delegate = self
        addContactObj.modalPresentationStyle = .fullScreen
        self.present(addContactObj, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int{
        return self.contactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emgCell = tableView.dequeueReusableCell(withIdentifier: "EmergencyCell", for: indexPath) as! EmergencyCell
        let helpDict:NSDictionary = self.contactArray.object(at: indexPath.row) as! NSDictionary
        emgCell.configCell(contactDict: helpDict)
        emgCell.menuBtn.tag = indexPath.row
        emgCell.menuBtn.addTarget(self, action: #selector(menuBtnTapped), for: .touchUpInside)
        emgCell.editBtn.tag = indexPath.row
        emgCell.editBtn.addTarget(self, action: #selector(editBtnTapped), for: .touchUpInside)
        emgCell.deleteBtn.tag = indexPath.row
        emgCell.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)

        return emgCell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }
    
    @objc func menuBtnTapped(_ sender: UIButton!) {
        var selectedDict = NSDictionary()
        selectedDict = self.contactArray.object(at: sender.tag) as! NSDictionary
        let selectedIndex : Int = selectedDict.value(forKey: "id") as! Int
        self.contactArray.removeAllObjects()
        for contact in UserModel.shared.getEmergenctContact()! {
            let tempArray = NSMutableArray.init(array: [contact])
            var tempDict = NSDictionary()
            tempDict = tempArray.object(at: 0) as! NSDictionary
            let index : Int = tempDict.value(forKey: "id") as! Int
            let tempDetails = NSMutableDictionary.init(dictionary:tempDict)
            if (selectedIndex == index){
                tempDetails.setValue("1", forKey: "menuShow")
            }else{
                tempDetails.setValue("0", forKey: "menuShow")
            }
            self.contactArray.addObjects(from: [tempDetails])
        }
        self.emergencyTableView.reloadData()
    }
    
    @objc func editBtnTapped(_ sender: UIButton!) {
        var tempDict = NSDictionary()
        tempDict = self.contactArray.object(at: sender.tag) as! NSDictionary
        let addContactObj = AddEditContactPage()
        addContactObj.viewType = "1"
        addContactObj.indexNo = sender.tag
        addContactObj.contactName = tempDict.value(forKey: "name") as! String
        addContactObj.contactNo = tempDict.value(forKey: "phone_no") as! String
        addContactObj.contactArray = self.contactArray
        addContactObj.delegate = self
        addContactObj.modalPresentationStyle = .fullScreen
        self.present(addContactObj, animated: true, completion: nil)
    }
    @objc func deleteBtnTapped(_ sender: UIButton!) {
        self.contactArray.removeObject(at: sender.tag)
        UserModel.shared.setEmergencyContact(contactArray: self.contactArray)
        HPLActivityHUD.showActivity(with: .withMask)
        self.updateEmergencyContact()
    }

    // MARK: customize contact array
    func initalContactDetails()  {
        var count:Int = 0
        self.contactArray.removeAllObjects()
        for contact in UserModel.shared.getEmergenctContact()! {
            let tempArray = NSMutableArray.init(array: [contact])
            var tempDict = NSDictionary()
            tempDict = tempArray.object(at: 0) as! NSDictionary
            let tempDetails = NSMutableDictionary.init(dictionary:tempDict)
            tempDetails.setValue("0", forKey: "menuShow")
            tempDetails.setValue(count, forKey: "id")
            count += 1
            self.contactArray.addObjects(from: [tempDetails])
        }
        UserModel.shared.removeEmergencyContact()
        UserModel.shared.setEmergencyContact(contactArray: self.contactArray)
        self.emergencyTableView.reloadData()
    }
    
    //MARK: prepare for request
    func getFinalRequestArray() -> NSArray{
        let requestArray = NSMutableArray()
        for contact in self.contactArray {
            let tempArray = NSMutableArray.init(array: [contact])
            var tempDict = NSDictionary()
            tempDict = tempArray.object(at: 0) as! NSDictionary
            let tempDetails = NSMutableDictionary.init(dictionary:tempDict)
            tempDetails.removeObject(forKey: "menuShow")
            tempDetails.removeObject(forKey: "id")
            requestArray.addObjects(from: [tempDetails])
        }
        let finalArray = NSMutableArray()
        finalArray.insert(requestArray, at: 0)
        var finalDict = NSArray()
        finalDict = finalArray.object(at: 0) as! NSArray
        return finalDict
    }
    
    // service call
    func updateEmergencyContact()  {
        let userObj = UserServices()
        userObj.updateEmergecyContact(emergencyContact: self.getFinalRequestArray(), onSuccess: {response in
            HPLActivityHUD.dismiss()
            let status:NSString = response.value(forKey: "status") as! NSString
            if status.isEqual(to: STATUS_TRUE){
                self.emergencyTableView.reloadData()
                self.view.makeToast(Utility.shared.getLanguage()?.value(forKey: (response.value(forKey: "message") as? String ?? "")) as? String, align: UserModel.shared.getAppLanguage() ?? "English")
            }else{
                Utility.shared.showAlert(msg: "server_alert", status: "")
            }
            self.checkAvailability()
        })
        
    }
    //add edit page delegate
    func notifyToUpdateContact() {
        self.initalContactDetails()
        self.updateEmergencyContact()
    }
    
    func checkAvailability()  {
        print("stored \(UserModel.shared.getEmergenctContact()), count array \(self.contactArray.count)")
        if UserModel.shared.getEmergenctContact() == nil || self.contactArray.count == 0 {
            self.no_contactView.isHidden = false
        }else {
            self.no_contactView.isHidden = true
        }
    }
}
