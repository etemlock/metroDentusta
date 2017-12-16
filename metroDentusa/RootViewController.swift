//
//  RootViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/14/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import UIKit

class RootViewController : UIViewController {
    static var themeColor = UIColor(red: 26/255, green: 122/255, blue: 1, alpha: 1)
    var menuButton : UIBarButtonItem!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = menuButton
        self.navigationItem.title = "Root View Controller"
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let WelcomeLabel = UILabel(frame: CGRect(x: 87, y: 315, width: 200, height: 50))
        WelcomeLabel.font = WelcomeLabel.font.withSize(22)
        WelcomeLabel.textColor = RootViewController.themeColor
        WelcomeLabel.text = "Welcome!"
        WelcomeLabel.textAlignment = NSTextAlignment.center
        WelcomeLabel.layer.borderColor = RootViewController.themeColor.cgColor
        self.view.addSubview(WelcomeLabel)
    }
}
