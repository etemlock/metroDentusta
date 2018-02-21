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
    
    func createTransition(duration: CFTimeInterval, transitionSubType: String){
        let transition = CATransition()
        transition.duration = duration
        transition.type = kCATransitionPush
        transition.subtype = transitionSubType
        self.view.window!.layer.add(transition, forKey: kCATransition)
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
    
    func seperateNumbers() -> String {
        var trimmedString = ""
        let digitRegex = "^[0-9]$"
        for index in self.characters.indices {
            let char = String(self[index])
            if char.validatePredicate(regex: digitRegex){
                trimmedString += char
            }
        }
        return trimmedString
    }
    
    func estimateFrameForText(maxWidth: CGFloat, maxHeight: CGFloat, font: CGFloat?) -> CGRect {
        let size = CGSize(width: maxWidth, height: maxHeight)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        if font != nil {
            return NSString(string: self).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: font!)], context: nil)
        }
        return NSString(string: self).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)], context: nil)
        
    }
}

/*extension countryInfo {
    mutating func clear(){
        self.topoName = ""
        self.name = ""
        self.lat = 0
        self.long = 0
        self.geoId = 0
        self.countryCode = ""
        self.countryName = ""
    }
}*/





