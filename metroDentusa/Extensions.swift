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
    
    func setUpActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        return activityIndicator
    }
    
    func hideKeyBoardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func toggleMenuButton(menuButton: UIBarButtonItem){
        if self.navigationController != nil {
            self.navigationItem.leftBarButtonItem = menuButton
            if self.revealViewController() != nil {
                menuButton.target = self.revealViewController()
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }
    }
    
    func setUpBackBarButton(title: String?){
        if self.navigationController != nil {
            let backItem = UIBarButtonItem()
            backItem.title = title
            self.navigationItem.backBarButtonItem = backItem
        }
    }
    
    func setUpScrollViewAndContentView(scrollView: UIScrollView, contentView: UIView){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
    }
  
}


extension UIButton {
    func setUpDefaultType(title: String?){
        self.setTitle(title, for: .normal)
        self.backgroundColor = LoginSignUpViewController.themeColor
        self.titleLabel?.textColor = UIColor.white
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
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

public protocol genericTableViewCell : class {
    static var reuseIdentifier : String { get }
    
}

extension genericTableViewCell {
    public static var reuseIdentifier : String {
        return String(describing: self)
    }
}


extension UITableView {
    func scrollToFirstRow(sectionNum: Int){
        let indexPath = IndexPath(row: 0, section: sectionNum)
        self.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    public func register<T: genericTableViewCell>(cellClass: T.Type){
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    public func dequeueReusableCell<T: genericTableViewCell>(ofType cellClass: T.Type, for indexPath: IndexPath) -> T{
        return dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as! T
    }
    
    
}





