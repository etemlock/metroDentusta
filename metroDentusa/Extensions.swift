//
//  Extensions.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/14/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func createTransition(duration: CFTimeInterval, transitionSubType: String){
        let transition = CATransition()
        transition.duration = duration
        transition.type = kCATransitionPush
        transition.subtype = transitionSubType
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func getAnchorYPositionDiff(anchorTop: NSLayoutAnchor<NSLayoutYAxisAnchor>, anchorBottom: NSLayoutAnchor<NSLayoutYAxisAnchor>) -> CGFloat {
        let measureStick = UIView()
        var heightDiff : CGFloat = 0
        
        measureStick.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(measureStick)
        measureStick.topAnchor.constraint(equalTo: anchorTop).isActive = true
        measureStick.bottomAnchor.constraint(equalTo: anchorBottom).isActive = true
        measureStick.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        measureStick.widthAnchor.constraint(equalToConstant: 1).isActive = true
        measureStick.layoutIfNeeded()
        heightDiff = measureStick.frame.height
        measureStick.removeFromSuperview()
        return heightDiff
    }
    
    func hideKeyBoardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func promptAlertWithDelay(_ intitle: String,  inmessage: String, indelay: Double){
        let alert = UIAlertController(title: intitle, message: inmessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        let time = DispatchTime.now() + indelay
        DispatchQueue.main.asyncAfter(deadline: time){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func resizeScrollViewAfterTransition(coordinator: UIViewControllerTransitionCoordinator,scrollView: UIScrollView, contentView: UIView){
        coordinator.animate(alongsideTransition: nil, completion: {
            (context) -> Void in
            contentView.layoutIfNeeded()
            scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        })
    }
    
    
    func setUpActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        return activityIndicator
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
    
    
}

extension UIAlertController {
    func willPerformLogout(completion: @escaping (_ didSelectLogout: Bool) -> Void){
        self.title = "Logout?"
        self.message = "Are you sure you want to logout? Your current activity will not be saved"
        self.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action: UIAlertAction) in
            completion(true)
        }))
        self.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
            completion(false)
        }))
    }
}



extension UIView {
    func setUpActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        return activityIndicator
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
    
    func estimateFrameForText(maxWidth: CGFloat, maxHeight: CGFloat, font: CGFloat?) -> CGRect {
        let size = CGSize(width: maxWidth, height: maxHeight)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        if font != nil {
            return NSString(string: self).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: font!)], context: nil)
        }
        return NSString(string: self).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)], context: nil)
        
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
    
    func validatePredicate(regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
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





