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
    
    func hideKeyBoardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
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

extension String {
    func validatePredicate(regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
}

extension countryInfo {
    mutating func clear(){
        self.topoName = ""
        self.name = ""
        self.lat = 0
        self.long = 0
        self.geoId = 0
        self.countryCode = ""
        self.countryName = ""
    }
}





