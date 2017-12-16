//
//  Extensions.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/14/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation

extension UIViewController {
    func promptAlertWithDelay(_ intitle: String,  inmessage: String, indelay: Double){
        let alert = UIAlertController(title: intitle, message: inmessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        let time = DispatchTime.now() + indelay
        DispatchQueue.main.asyncAfter(deadline: time){
            alert.dismiss(animated: true, completion: nil)
        }
    }
}

extension UIButton {
    func setUpDefaultType(title: String?){
        self.setTitle(title, for: .normal)
        self.backgroundColor = RootViewController.themeColor
        self.titleLabel?.textColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
    }
}
    

 
