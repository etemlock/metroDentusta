//
//  benefitCardViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 2/27/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class benefitCardViewController: UIViewController {
    var menuButton: UIBarButtonItem!
    private var user: member!
    private var session: URLSession?
    var innerView: UIView!
    
    
    init(user: member, session: URLSession?){
        super.init(nibName: nil, bundle: nil)
        self.user = user
        self.session = session
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardWhenTappedAround()
        self.view.backgroundColor = UIColor(red: 238/255, green: 236/255, blue: 246/255, alpha: 1)
        self.view.backgroundColor?.withAlphaComponent(0.5)
        
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.toggleMenuButton(menuButton: menuButton)
        setUpInnerView()
    }
    
    func setUpInnerView(){
        innerView = UIView(frame: CGRect(x: 12, y: (self.navigationController?.navigationBar.frame.maxY)!+10, width: 351, height: 500))
        innerView.backgroundColor = UIColor.white
        
        let header = UILabel(frame: CGRect(x: 8, y: 8, width: 220, height: 50))
        header.font = UIFont.boldSystemFont(ofSize: 19)
        header.numberOfLines = 2
        header.text = "ASO MEMBER BENEFIT PLAN"
        
        let logo = UIImageView(frame: CGRect(x: 230, y: 8, width: 113, height: 50))
        logo.image = UIImage(named: "Logo Icon")
        logo.contentMode = .scaleAspectFit
        
        let divider = UIView(frame: CGRect(x: 0, y: header.frame.maxY+5, width: innerView.frame.width, height: 5))
        divider.backgroundColor = LoginSignUpViewController.themeColor
        
        let nameLabel = UILabel(frame: CGRect(x: 8, y: divider.frame.maxY + 5, width: 150, height: 20))
        nameLabel.text = user.getUsername()
        
        let groupLabel = UILabel(frame: CGRect(x: innerView.frame.width - 108, y: divider.frame.maxY + 5, width: 100, height: 20))
        groupLabel.text = "Group: #V190"
        
        let idLabel = UILabel(frame: CGRect(x: 8, y: nameLabel.frame.maxY + 5, width: 150, height: 20))
        idLabel.text = "ID#:\(user.getId())"
        
        let activeLabel = UILabel(frame: CGRect(x: innerView.frame.width - 108, y: groupLabel.frame.maxY + 5, width: 100, height: 20))
        activeLabel.text = "Level: ACTIVE"
        
        let viewClaimsButton = UIButton(frame: CGRect(x: self.view.center.x - 75, y: activeLabel.frame.maxY+20, width: 150, height: 40))
        viewClaimsButton.setUpDefaultType(title: "View My Claims")
        
        let sendInfoButton = UIButton(frame: CGRect(x: self.view.center.x - 100, y: viewClaimsButton.frame.maxY + 20, width: 200, height: 40))
        sendInfoButton.setUpDefaultType(title: "Send My Benefit Info")
        
        let disclaimer = UILabel(frame: CGRect(x: 8, y: sendInfoButton.frame.maxY + 20, width: innerView.frame.width-16, height: 230))
        disclaimer.text = "You may receive care from any licensed dentist.\n\nThis plan is subject to maximums and frequency limitations. You are responsible to your dentist for all amounts not covered by the Plan.\n\nYour plan is subject to certain limitations and exclusions. Predeterminations are recommended in order to verify coverage for major work including surgical, periodontal, orthodontia, bridges and implants.\n\nClaim forms should be submitted within 30 days of treatment to:\n\n \tElectronic Claims: Payer ID# CX076\n\tpaper Claims: ASO, PO Box 9005, Lynbrook, NY 11559"
        disclaimer.numberOfLines = 16
        disclaimer.font = disclaimer.font.withSize(12)
        
        innerView.addSubview(header)
        innerView.addSubview(logo)
        innerView.addSubview(divider)
        innerView.addSubview(nameLabel)
        innerView.addSubview(groupLabel)
        innerView.addSubview(idLabel)
        innerView.addSubview(activeLabel)
        innerView.addSubview(viewClaimsButton)
        innerView.addSubview(sendInfoButton)
        
        for case let label as UILabel in innerView.subviews {
            label.font = label.font.withSize(15)
        }
        
        innerView.addSubview(disclaimer)
        
        self.view.addSubview(innerView)
    }
    
    
}
