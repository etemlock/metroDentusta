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
    var logoView : UIImageView!
    var homePic: UIImageView!
    var menuButton : UIBarButtonItem!
    var subPicLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = menuButton
        
        
        //let logoView = UIImageView(image: UIImage(named: "Logo Icon"))
        self.navigationItem.title = "Welcome to ASO Data Services"
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        setUpImages()
        setUpLabel()
    }
    
    func setUpImages(){
        logoView = UIImageView(frame: CGRect(x: self.view.center.x - 70, y: 75, width: 140, height: 40))
        logoView.image = UIImage(named: "Logo Icon")
        logoView.contentMode = .scaleAspectFit
        
        homePic = UIImageView(frame: CGRect(x: 0, y: logoView.frame.maxY + 25, width: self.view.frame.width, height: 200))
        homePic.image = UIImage(named: "HomePic")
        homePic.contentMode = .scaleAspectFill
        
        self.view.addSubview(logoView)
        self.view.addSubview(homePic)
    }
    
    func setUpLabel(){
        let otherLabel = UILabel(frame: CGRect(x: 50, y: homePic.frame.minY + 50, width: 220, height: 40))
        otherLabel.font = UIFont.boldSystemFont(ofSize: 15)
        otherLabel.numberOfLines = 2
        otherLabel.text = "Serving members and their families since 1970"
        
        subPicLabel = UILabel(frame: CGRect(x: self.view.center.x - 125, y: homePic.frame.maxY + 5, width: 250, height: 40))
        subPicLabel.textColor = UIColor.lightGray
        subPicLabel.numberOfLines = 2
        subPicLabel.font = subPicLabel.font.withSize(13)
        subPicLabel.text = "Login below for more details about plans and benefits"
        self.view.addSubview(subPicLabel)
        self.view.addSubview(otherLabel)
        self.view.bringSubview(toFront: otherLabel)
        
        /*let WelcomeLabel = UILabel(frame: CGRect(x: 87, y: 350, width: 200, height: 50))
        WelcomeLabel.font = WelcomeLabel.font.withSize(22)
        WelcomeLabel.textColor = RootViewController.themeColor
        WelcomeLabel.text = "Welcome!"
        WelcomeLabel.textAlignment = NSTextAlignment.center
        WelcomeLabel.layer.borderColor = RootViewController.themeColor.cgColor
        self.view.addSubview(WelcomeLabel)*/
    }
    
}
