//
//  CarModelPopUp.swift
//  HSTaxiUserApp
//
//  Created by Mani Murugesan on 03/07/23.
//  Copyright © 2023 APPLE. All rights reserved.
//

import UIKit

class CarModelPopUp: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var carMakeNAme: FloatingLabeltextField!
    @IBOutlet weak var carModelName: FloatingLabeltextField!
    @IBOutlet weak var colorName: FloatingLabeltextField!
    @IBOutlet var submitBtn: UIButton!
    var addCarDetails: ((_ carmodel: String,_ make: String,_ carcolor: String) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.initialLoadView()
    }
    
    func initialLoadView(){
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        titleName.font = UIFont(name: APP_FONT_REGULAR, size: 16)
        carMakeNAme.font = UIFont(name: APP_FONT_REGULAR, size: 15)
        carModelName.font = UIFont(name: APP_FONT_REGULAR, size: 15)
        colorName.font = UIFont(name: APP_FONT_REGULAR, size: 15)
        submitBtn.titleLabel?.font = UIFont(name: APP_FONT_REGULAR, size: 17)
        self.submitBtn.cornerMiniumRadius()
    }
    
    @IBAction func submitBtn(_ sender: UIButton){
        if self.addCarDetails != nil {
            self.addCarDetails!(carModelName.text ?? "",carMakeNAme.text ?? "",colorName.text ?? "")
        }
        print("Submit.....")
        self.dismiss(animated: true)
    }
    
    
}
