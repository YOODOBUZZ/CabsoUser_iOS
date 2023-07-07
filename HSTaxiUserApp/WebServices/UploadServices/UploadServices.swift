//
//  UploadServices.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 29/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit
import Alamofire

class UploadServices: BaseWebService {

    //MARK: upload profiel pic service
    public func uploadProfilePic(profileimage:Data, onSuccess success: @escaping (NSDictionary) -> Void) {
        let BaseUrl = URL(string: BASE_URL+PROFILE_PIC_API)
        print("BASE URL : \(BASE_URL+PROFILE_PIC_API)")
        let parameters = ["user_id": UserModel.shared.userID()!]
        print("REQUEST : \(parameters)")
        print("data \(profileimage)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(profileimage, withName: "userImage", fileName: "profilepic.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append((value.data(using: String.Encoding.utf8.rawValue)!), withName: key)
            }
        }, to:BaseUrl!,method:.post,headers:self.getHeaders())
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    let JSON = response.result.value as? NSDictionary
                    print("RESPONSE \(response)")
                    if JSON != nil {
                        success(JSON!)
                    }
                    else {
                        Utility.shared.showAlert(msg: "server_alert", status: "")
                    }
                }
            case .failure(let error):
                print("FAILURE RESPONSE: \(error.localizedDescription)")
                HPLActivityHUD.dismiss()
                if error._code == NSURLErrorTimedOut{
                    Utility.shared.showAlert(msg: "timed_out", status: "")
                }else if error._code == NSURLErrorNotConnectedToInternet{
                    Utility.shared.goToOffline()
                }else{
                    Utility.shared.showAlert(msg: "server_alert", status: "")
                }
            }
        }
    }
}
