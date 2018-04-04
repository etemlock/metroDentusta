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
    
    /* Instance Variables for Views and Constraints */
    var innerView = UIView()
    var header = UILabel()
    var headerXConstraint : NSLayoutConstraint!
    var headerWidthConstraint: NSLayoutConstraint!
    var divider = UIView()
    var nameLabel = UILabel()
    var groupLabel = UILabel()
    var idLabel = UILabel()
    var activeLabel = UILabel()
    var viewClaimsButton = UIButton()
    var viewClaimsXConstraint: NSLayoutConstraint!
    var viewClaimsYConstraint: NSLayoutConstraint!
    var sendInfoButton = UIButton()
    var sendInfoXConstraint: NSLayoutConstraint!
    var sendInfoYConstraint: NSLayoutConstraint!
    var buttonLandScapeViews : [UIView] = []
    
    
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
        edgesForExtendedLayout = []
        setUpInnerView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orient = UIDevice.current.orientation
        headerXConstraint.isActive = false
        headerWidthConstraint.isActive = false
        viewClaimsXConstraint.isActive = false
        viewClaimsYConstraint.isActive = false
        sendInfoXConstraint.isActive = false
        sendInfoYConstraint.isActive = false
        switch orient {
        case .portrait:
            viewDidTransitionPortrait()
        case .landscapeLeft, .landscapeRight:
            viewDidTransitionLandScape()
        default:
            break
        }
        headerXConstraint.isActive = true
        headerWidthConstraint.isActive = true
        viewClaimsXConstraint.isActive = true
        viewClaimsYConstraint.isActive = true
        sendInfoXConstraint.isActive = true
        sendInfoYConstraint.isActive = true
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    
    func viewDidTransitionPortrait(){
        headerXConstraint = header.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 8)
        headerWidthConstraint = header.widthAnchor.constraint(equalToConstant: 220)
        header.font = UIFont.boldSystemFont(ofSize: 15)
        
        viewClaimsXConstraint = viewClaimsButton.centerXAnchor.constraint(equalTo: innerView.centerXAnchor)
        viewClaimsYConstraint = viewClaimsButton.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 20)
        sendInfoXConstraint = sendInfoButton.centerXAnchor.constraint(equalTo: innerView.centerXAnchor)
        sendInfoYConstraint = sendInfoButton.topAnchor.constraint(equalTo: viewClaimsButton.bottomAnchor, constant: 20)
    }
    
    func viewDidTransitionLandScape(){
        headerXConstraint = header.centerXAnchor.constraint(equalTo: innerView.centerXAnchor)
        headerWidthConstraint = header.widthAnchor.constraint(equalToConstant: 300)
        header.font = UIFont.boldSystemFont(ofSize: 19)
        
        if buttonLandScapeViews.count < 2 {
            setUpButtonLandscapeViews()
        }
        
        viewClaimsXConstraint = viewClaimsButton.centerXAnchor.constraint(equalTo: buttonLandScapeViews[0].centerXAnchor)
        viewClaimsYConstraint = viewClaimsButton.centerYAnchor.constraint(equalTo: buttonLandScapeViews[1].centerYAnchor)
        
        sendInfoXConstraint = sendInfoButton.centerXAnchor.constraint(equalTo: buttonLandScapeViews[1].centerXAnchor, constant: -25)
        sendInfoYConstraint = sendInfoButton.centerYAnchor.constraint(equalTo: buttonLandScapeViews[1].centerYAnchor)
    }
    
    func setUpInnerView(){
        /*innerView = UIView(frame: CGRect(x: 12, y: (self.navigationController?.navigationBar.frame.maxY)!+10, width: 351, height: 500))
        innerView.backgroundColor = UIColor.white
         
         let header = UILabel(frame: CGRect(x: 8, y: 8, width: 220, height: 50))
         header.font = UIFont.boldSystemFont(ofSize: 19)
         header.numberOfLines = 1
         header.text = "ASO MEMBER BENEFIT PLAN"
         
         let logo = UIImageView(frame: CGRect(x: 230, y: 8, width: 113, height: 50))
         logo.image = UIImage(named: "Logo Icon")
         logo.contentMode = .scaleAspectFit
         
         let divider = UIView(frame: CGRect(x: 0, y: header.frame.maxY+5, width: innerView.frame.width, height: 5))
         divider.backgroundColor = LoginSignUpViewController.themeColor
         
         
         
         /* innerView.addSubview(header)
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
         }*/
         */
        
        innerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(innerView)
        
        innerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        innerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 12).isActive = true
        innerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12).isActive = true
        innerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        innerView.backgroundColor = UIColor.white
        
        innerView.layoutIfNeeded()
        
        header.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(header)
        
        header.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 8).isActive = true
        if UIDevice.current.orientation.isPortrait {
            headerXConstraint = header.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 8)
            headerWidthConstraint = header.widthAnchor.constraint(equalToConstant: 220)
            header.font = UIFont.boldSystemFont(ofSize: 15)
            
        } else {
            headerXConstraint = header.centerXAnchor.constraint(equalTo: innerView.centerXAnchor)
            headerWidthConstraint = header.widthAnchor.constraint(equalToConstant: 300)
            header.font = UIFont.boldSystemFont(ofSize: 19)
        }
        headerXConstraint.isActive = true
        headerWidthConstraint.isActive = true
        header.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        header.numberOfLines = 1
        header.text = "ASO MEMBER BENEFIT PLAN"
        
        
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(logo)
        
        logo.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        logo.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -8).isActive = true
        logo.widthAnchor.constraint(equalTo: innerView.widthAnchor, multiplier: 0.32).isActive = true
        logo.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        logo.image = UIImage(named: "Logo Icon")
        logo.contentMode = .scaleAspectFit
        
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(divider)
        
        divider.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 5).isActive = true
        divider.leadingAnchor.constraint(equalTo: innerView.leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: innerView.trailingAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 5).isActive = true
        divider.backgroundColor = LoginSignUpViewController.themeColor
        
        setUpUserDetailLabels()
        setUpButtons()
        
       /*let disclaimer = UILabel(frame: CGRect(x: 8, y: sendInfoButton.frame.maxY + 20, width: innerView.frame.width-16, height: 230))*/
        
        let disclaimer = UILabel()
        disclaimer.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(disclaimer)
        
        disclaimer.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 8).isActive = true
        disclaimer.topAnchor.constraint(equalTo: viewClaimsButton.bottomAnchor, constant: 20).isActive = true
        disclaimer.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -8).isActive = true
        disclaimer.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -8).isActive = true
        disclaimer.text = "You may receive care from any licensed dentist.\n\nThis plan is subject to maximums and frequency limitations. You are responsible to your dentist for all amounts not covered by the Plan.\n\nYour plan is subject to certain limitations and exclusions. Predeterminations are recommended in order to verify coverage for major work including surgical, periodontal, orthodontia, bridges and implants.\n\nClaim forms should be submitted within 30 days of treatment to:\n\n \tElectronic Claims: Payer ID# CX076\n\tpaper Claims: ASO, PO Box 9005, Lynbrook, NY 11559"
        disclaimer.numberOfLines = 16
        disclaimer.font = disclaimer.font.withSize(12)
        
    }
    
    func setUpUserDetailLabels(){
        /*let nameLabel = UILabel(frame: CGRect(x: 8, y: divider.frame.maxY + 5, width: 150, height: 20))
        nameLabel.text = user.getUsername()
        
        
        let groupLabel = UILabel(frame: CGRect(x: innerView.frame.width - 108, y: divider.frame.maxY + 5, width: 100, height: 20))
        groupLabel.text = "Group: #V190"
        
        let idLabel = UILabel(frame: CGRect(x: 8, y: nameLabel.frame.maxY + 5, width: 150, height: 20))
        idLabel.text = "ID#:\(user.getId())"
        
        let activeLabel = UILabel(frame: CGRect(x: innerView.frame.width - 108, y: groupLabel.frame.maxY + 5, width: 100, height: 20))
        activeLabel.text = "Level: ACTIVE"*/
        
        

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 5).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        nameLabel.text = user.getUsername()
        let estWidth1 = nameLabel.text?.estimateFrameForText(maxWidth: 150, maxHeight: 20, font: 15).width
        nameLabel.widthAnchor.constraint(equalToConstant: estWidth1! + 8).isActive = true
        nameLabel.font = nameLabel.font.withSize(15)
        
        

        groupLabel.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(groupLabel)
        
        groupLabel.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -8).isActive = true
        groupLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        groupLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        groupLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        groupLabel.text = "Group: #V190"
        groupLabel.font = groupLabel.font.withSize(15)
        
        
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(idLabel)
        
        idLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        idLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        idLabel.text = "ID#:\(user.getId())"
        let estWidth2 = idLabel.text?.estimateFrameForText(maxWidth: 150, maxHeight: 20, font: 15).width
        idLabel.widthAnchor.constraint(equalToConstant: estWidth2! + 8).isActive = true
        idLabel.font = idLabel.font.withSize(15)
        
        
        activeLabel.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(activeLabel)
        
        activeLabel.trailingAnchor.constraint(equalTo: groupLabel.trailingAnchor).isActive = true
        activeLabel.topAnchor.constraint(equalTo: idLabel.topAnchor).isActive = true
        activeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        activeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        activeLabel.text = "Level: ACTIVE"
        activeLabel.font = activeLabel.font.withSize(15)
    }
    
    func setUpButtonLandscapeViews(){
        let view1 = UIView()
        view1.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(view1)
        
        view1.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        view1.trailingAnchor.constraint(equalTo: innerView.centerXAnchor).isActive = true
        view1.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        view1.bottomAnchor.constraint(equalTo: idLabel.bottomAnchor).isActive = true
        view1.backgroundColor = UIColor.clear
        buttonLandScapeViews.append(view1)
        
        let view2 = UIView()
        view2.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(view2)
        
        view2.leadingAnchor.constraint(equalTo: innerView.centerXAnchor).isActive = true
        view2.trailingAnchor.constraint(equalTo: groupLabel.leadingAnchor).isActive = true
        view2.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        view2.bottomAnchor.constraint(equalTo: idLabel.bottomAnchor).isActive = true
        view2.backgroundColor = UIColor.clear
        buttonLandScapeViews.append(view2)
    }
    
    func setUpButtons(){
        /*let viewClaimsButton = UIButton(frame: CGRect(x: self.view.center.x - 75, y: activeLabel.frame.maxY+20, width: 150, height: 40))
        viewClaimsButton.setUpDefaultType(title: "View My Claims")
        
        let sendInfoButton = UIButton(frame: CGRect(x: self.view.center.x - 100, y: viewClaimsButton.frame.maxY + 20, width: 200, height: 40))
        sendInfoButton.setUpDefaultType(title: "Send My Benefit Info")*/
        
        viewClaimsButton.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(viewClaimsButton)
        
        sendInfoButton.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(sendInfoButton)
        
        viewClaimsButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        viewClaimsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        sendInfoButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        sendInfoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        if UIDevice.current.orientation.isPortrait {
            viewClaimsXConstraint = viewClaimsButton.centerXAnchor.constraint(equalTo: innerView.centerXAnchor)
            viewClaimsYConstraint = viewClaimsButton.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 20)
            
            sendInfoXConstraint = sendInfoButton.centerXAnchor.constraint(equalTo: innerView.centerXAnchor)
            sendInfoYConstraint = sendInfoButton.topAnchor.constraint(equalTo: viewClaimsButton.bottomAnchor, constant: 20)
        } else {
            setUpButtonLandscapeViews()
            
            viewClaimsXConstraint = viewClaimsButton.centerXAnchor.constraint(equalTo: buttonLandScapeViews[0].centerXAnchor)
            viewClaimsYConstraint = viewClaimsButton.centerYAnchor.constraint(equalTo: buttonLandScapeViews[1].centerYAnchor)
            
            sendInfoXConstraint = sendInfoButton.centerXAnchor.constraint(equalTo: buttonLandScapeViews[1].centerXAnchor, constant: -25)
            sendInfoYConstraint = sendInfoButton.centerYAnchor.constraint(equalTo: buttonLandScapeViews[1].centerYAnchor)

        }
        viewClaimsXConstraint.isActive = true
        viewClaimsYConstraint.isActive = true
        sendInfoXConstraint.isActive = true
        sendInfoYConstraint.isActive = true
        
        viewClaimsButton.setUpDefaultType(title: "View My Claims")
        sendInfoButton.setUpDefaultType(title: "Send My Benefit Info")
    }
    
    
    /********************************************* UIButton actions ******************************************/
    func viewClaims(){
        AppDelegate().makeHTTPPostRequestToViewClaims(urlString: "https://edi.asonet.com/httpserver.ashx?obj=serviceHistoryHTML", userDetails: user, completion: { (data: Data?) in
            if data != nil {
                print("there was data")
                print("not sure what to do with this data")
            }
        })
    }
    
    
}
