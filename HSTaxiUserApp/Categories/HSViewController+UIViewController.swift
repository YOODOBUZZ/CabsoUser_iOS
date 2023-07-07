//
//  HSViewController+UIViewController.swift
//  HSTaxiUserApp
//
//  Created by APPLE on 15/03/18.
//  Copyright © 2018 APPLE. All rights reserved.
//

import Foundation
import SocketIO

extension UIViewController{
        
    func addAnimationLayer() {
        let pubbleView = UIView.init(frame:  CGRect.init(x: FULL_WIDTH/2-25, y: FULL_HEIGHT/2-25, width: 50, height: 50))
        pubbleView.cornerViewRadius()
        pubbleView.backgroundColor = .black
        pubbleView.backgroundColor?.withAlphaComponent(0.1)
        pubbleView.alpha = 0.7
        self.navigationController?.view.addSubview(pubbleView)
        
        UIView.animate(withDuration: 0.7, animations: {
            if IS_IPHONE_X{
                pubbleView.frame = CGRect.init(x: -200, y: 0, width: FULL_HEIGHT, height: FULL_HEIGHT)
            }else{
                pubbleView.frame = CGRect.init(x: -150, y: 0, width: FULL_HEIGHT, height: FULL_HEIGHT)
            }
            pubbleView.cornerViewRadius()
            self.navigationController?.view.addSubview(pubbleView)
            pubbleView.alpha = 0
        }, completion: { _ in
        })
    }
    
    //SOCKET METHODS
    //MARK: socket sconnect
    func connectSocket()  {
        //connect socket
        socket.defaultSocket.connect()
        socket.defaultSocket.on(clientEvent: .connect) {data, ack in
            print("socket new connected")
        }
    }
    
    //MARK: socket disconnect
    func disconnectSocket() {
        socket.defaultSocket.off("whereareyou")
        socket.defaultSocket.disconnect()
    }
}
