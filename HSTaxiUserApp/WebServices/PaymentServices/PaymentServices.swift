//
//  PaymentServices.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 11/04/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import UIKit

class PaymentServices: BaseWebService {

    // get brainTree token
    public func getBrainTreeToken(onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        self.baseService(subURl: BRAINTREEE_TOKEN_API, params: (requestDict as! Parameters), onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    // checkout braintree payment with nonce id
    public func paybyCard(amount:String,paynonce:String,onride_id:String,iswallet:String,walletmoney:String,basefare:NSNumber,commissionamount:NSNumber,tax:NSNumber,driver_id:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(amount, forKey: "amount")
        requestDict.setValue(paynonce, forKey: "paynonce")
        requestDict.setValue(onride_id, forKey: "onride_id")
        requestDict.setValue(iswallet, forKey: "iswallet")
        requestDict.setValue(basefare, forKey: "basefare")
        requestDict.setValue(commissionamount, forKey: "commissionamount")
        requestDict.setValue(tax, forKey: "tax")
        requestDict.setValue(driver_id, forKey: "driver_id")

        if iswallet == "1"{
            requestDict.setValue(walletmoney, forKey: "walletamount")
        }
        self.baseService(subURl: CARD_PAYMENT_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    // Pay by cash
    public func paybyCash(amount:String,onride_id:String,iswallet:String,walletmoney:String,basefare:NSNumber,commissionamount:NSNumber,tax:NSNumber,driver_id:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(amount, forKey: "amount")
        requestDict.setValue(onride_id, forKey: "onride_id")
        requestDict.setValue(iswallet, forKey: "iswallet")
        requestDict.setValue(basefare, forKey: "basefare")
        requestDict.setValue(commissionamount, forKey: "commissionamount")
        requestDict.setValue(tax, forKey: "tax")
        requestDict.setValue(driver_id, forKey: "driver_id")
        if iswallet == "1"{
        requestDict.setValue(walletmoney, forKey: "walletamount")
        }
        self.baseService(subURl: CASH_PAYMENT_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    // add money to wallet
    public func addToWallet(amount:String,paynonce:String, onSuccess success: @escaping (NSDictionary) -> Void) {
        let requestDict = NSMutableDictionary.init()
        requestDict.setValue(UserModel.shared.userID(), forKey: "user_id")
        requestDict.setValue(amount, forKey: "amount")
        requestDict.setValue(paynonce, forKey: "paynonce")
        self.baseService(subURl: ADD_WALLET_API, params: requestDict as! Parameters, onSuccess: {response in
            success(response)
        }, onFailure: {errorResponse in
        })
    }
    
    //MARK: wallet history service
    public func getWalletHistory(onSuccess success: @escaping (NSDictionary) -> Void) {
        self.getBaseService(subURl: ("\(WALLET_HISTORY_API)/\(UserModel.shared.userID()!)"), onSuccess: {response in
            success(response)
        },onFailure: {errorResponse in
        })
    }
}
