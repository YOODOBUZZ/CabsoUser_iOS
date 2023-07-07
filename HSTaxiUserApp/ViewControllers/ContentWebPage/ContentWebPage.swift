//
//  ContentWebPage.swift
//  HSLiveStream
//
//  Created by APPLE on 20/02/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class ContentWebPage: UIViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    var helpDict = NSDictionary()
    var viewType = NSString()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        HPLActivityHUD.showActivity(with: .withOutMask)
        self.configureWebviewWithDetails(contentDict: helpDict)
        self.contentTextView.config(color: TEXT_PRIMARY_COLOR, size: 15, align: .left)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeToRTL()
    }
    func changeToRTL() {
        if UserModel.shared.getAppLanguage() == "Arabic" {
            self.view.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.titleLbl.textAlignment = .right
            self.contentTextView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.contentTextView.textAlignment = .right
        }
        else {
            self.view.transform = .identity
            self.titleLbl.transform = .identity
            self.titleLbl.textAlignment = .left
            self.contentTextView.transform = .identity
            self.contentTextView.textAlignment = .left
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Configure web view
    func configureWebviewWithDetails(contentDict:NSDictionary)  {
        print("dict\(contentDict)")
        self.navigationView.elevationEffect()
        
        self.titleLbl.config(color: TEXT_PRIMARY_COLOR, size: 20, align: .left, text:EMPTY_STRING)
        self.titleLbl.text = contentDict.value(forKey: "title") as? String
        
        let contentString:String = contentDict.value(forKey: "content") as! String
        self.contentTextView.text = contentString.html2String
        HPLActivityHUD.dismiss()
    }
    
}
extension UITextView {
    
    //MARK: configure textField
    public func config(color:UIColor,size:CGFloat, align:NSTextAlignment){
        self.textColor = color
        self.textAlignment = align
        self.font = UIFont.init(name:APP_FONT_REGULAR, size: size+2)
    }
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
