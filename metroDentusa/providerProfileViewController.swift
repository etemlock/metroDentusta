//
//  providerProfileViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 2/8/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation
import MapKit

class providerProfileViewController : UIViewController, translateMaskingConstraintDelegate {
    var scrollView = UIScrollView()
    var contentView = UIView()
    var headingView = UIView()
    //var headingViewHeight: NSLayoutConstraint!
    var instTitle = UILabel()
    var instTitleHeight: NSLayoutConstraint!
    var addressLabel = UILabel()
    var addressLabelHeight: NSLayoutConstraint!
    var mapView = MKMapView()
    var mapViewHeight: NSLayoutConstraint!
    var midViewLeft = UIView()
    var midViewRight = UIView()
    var handicapLabel = UILabel()
    var providerLabel = UILabel()
    var providerLabelHeight: NSLayoutConstraint!
    var location: CLLocation?
    var providerInfo: providerModel!
    
    /******* data *********/
    var translateDelegate: translateMaskingConstraintDelegate?
    
    
    /********* Old **********
    var headingView: UIView!
    var mapView: MKMapView!
    var midView: UIView!
    var scrollView: UIScrollView!
    var location : CLLocation?
    var providerInfo : providerModel!
    ***/
    
    
    /*init(provider: providerModel){
        self.providerInfo = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Office Profile"
        view.backgroundColor = UIColor(red: 238/255, green: 236/255, blue: 246/255, alpha: 1)
        view.backgroundColor?.withAlphaComponent(0.5)
 
        edgesForExtendedLayout = []
        self.hideKeyBoardWhenTappedAround()
        translateDelegate = self
        translateDelegate?.translateAllInstanceViewsMaskingConstraints()
        providerInfo = expProvider.getSingleton()

        
        
        /************** New **********/
        self.setUpScrollViewAndContentView(scrollView: self.scrollView, contentView: self.contentView)
        setUpHeader()
        setUpMapView()
        setUpMidView()
        setUpBottomView()
        
        contentView.bottomAnchor.constraint(equalTo: providerLabel.bottomAnchor, constant: 30).isActive = true
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            (context) -> Void in
            self.mapViewHeight.isActive = false
            
            let orient = UIDevice.current.orientation
            switch orient {
            case .landscapeRight, .landscapeLeft:
                self.mapViewHeight = self.mapView.heightAnchor.constraint(equalToConstant: 235)
            default:
                self.mapViewHeight = self.mapView.heightAnchor.constraint(equalToConstant: 265)
            }
            self.mapViewHeight.isActive = true
            
            self.contentView.layoutIfNeeded()
            self.scrollView.contentSize = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height)
        })
    }
    
    /********************************** functions to set up view *******************************/
    
    //You could make a protocol out of this.
    func translateAllInstanceViewsMaskingConstraints(){
        headingView.translatesAutoresizingMaskIntoConstraints = false
        instTitle.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        midViewLeft.translatesAutoresizingMaskIntoConstraints = false
        midViewRight.translatesAutoresizingMaskIntoConstraints = false
        handicapLabel.translatesAutoresizingMaskIntoConstraints = false
        providerLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func setUpScrollView(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scrollView.backgroundColor = UIColor.clear
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
        self.view.addSubview(scrollView)
    }
    
    
    func setUpHeader() {

        contentView.addSubview(headingView)
        headingView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        headingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        headingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        let estHeight = providerInfo.instName.estimateFrameForText(maxWidth: self.view.frame.width - 16, maxHeight: 50, font: 19).height
        headingView.backgroundColor = UIColor.white
        
        
        headingView.addSubview(instTitle)
        instTitle.leadingAnchor.constraint(equalTo: headingView.leadingAnchor, constant: 8).isActive = true
        instTitle.trailingAnchor.constraint(equalTo: headingView.trailingAnchor, constant: -8).isActive = true
        instTitle.topAnchor.constraint(equalTo: headingView.topAnchor, constant: 8).isActive = true
        instTitleHeight = instTitle.heightAnchor.constraint(equalToConstant: estHeight)
        instTitleHeight.isActive = true
        instTitle.numberOfLines = 2
        instTitle.text = providerInfo.instName
        instTitle.textAlignment = .center
        instTitle.font = instTitle.font.withSize(19)
        instTitle.textColor = LoginSignUpViewController.themeColor
        
        
        let addStr = "\(providerInfo.address) \(providerInfo.city), \(providerInfo.stateZip)"
        let estHeight2 = addStr.estimateFrameForText(maxWidth: self.view.frame.width - 16, maxHeight: 40, font: 15).height
        headingView.addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: instTitle.bottomAnchor, constant: 5).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: headingView.leadingAnchor, constant: 8).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: headingView.trailingAnchor, constant: -8).isActive = true
        addressLabelHeight = addressLabel.heightAnchor.constraint(equalToConstant: estHeight2)
        addressLabelHeight.isActive = true
        addressLabel.numberOfLines = 2
        addressLabel.text = addStr
        addressLabel.textAlignment = .center
        addressLabel.font = addressLabel.font.withSize(15)
        
        
        let hourLabel = UILabel()
        hourLabel.translatesAutoresizingMaskIntoConstraints = false
        headingView.addSubview(hourLabel)
        hourLabel.leadingAnchor.constraint(equalTo: headingView.leadingAnchor, constant: 8).isActive = true
        hourLabel.trailingAnchor.constraint(equalTo: headingView.trailingAnchor, constant: -8).isActive = true
        hourLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5).isActive = true
        hourLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        hourLabel.text = "Hours:  \(providerInfo.hours)"
        hourLabel.textAlignment = .center
        hourLabel.font = hourLabel.font.withSize(15)
        
        headingView.bottomAnchor.constraint(equalTo: hourLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func setUpMapView(){
        
        contentView.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: headingView.bottomAnchor, constant: 1).isActive = true
        mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        let orient = UIDevice.current.orientation
        switch orient {
        case .landscapeLeft, .landscapeRight:
            mapViewHeight = mapView.heightAnchor.constraint(equalToConstant: 235)
        default:
            mapViewHeight = mapView.heightAnchor.constraint(equalToConstant: 265)
        }
        mapViewHeight.isActive = true
        
        if providerInfo.lat != -1 && providerInfo.long != -1 {
            location = CLLocation(latitude: providerInfo.lat, longitude: providerInfo.long)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, 1600, 1600)
            mapView.setRegion(coordinateRegion, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = (location?.coordinate)!
            annotation.title = providerInfo.instName
            mapView.addAnnotation(annotation)
        }
    }
    
    func setUpMidView(){

        contentView.addSubview(midViewLeft)
        midViewLeft.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        midViewLeft.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 1).isActive = true
        midViewLeft.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -1).isActive = true
        midViewLeft.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        contentView.addSubview(midViewRight)
        midViewRight.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 1).isActive = true
        midViewRight.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        midViewRight.topAnchor.constraint(equalTo: midViewLeft.topAnchor).isActive = true
        midViewRight.heightAnchor.constraint(equalTo: midViewLeft.heightAnchor).isActive = true
        
        midViewLeft.backgroundColor = UIColor.white
        midViewRight.backgroundColor = UIColor.white
        
        let midViewDivider = UIView()
        midViewDivider.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(midViewDivider)
        midViewDivider.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        midViewDivider.widthAnchor.constraint(equalToConstant: 2).isActive = true
        midViewDivider.centerYAnchor.constraint(equalTo: midViewLeft.centerYAnchor).isActive = true
        midViewDivider.heightAnchor.constraint(equalTo: midViewLeft.heightAnchor).isActive = true
        midViewDivider.backgroundColor = UIColor.darkGray
        
        /******** Old **********
        let callIcon = UIImageView(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        callIcon.image = UIImage(named: "Phone Icon")
        let oneQuarter = callIcon.frame.maxX + (midView.center.x - callIcon.frame.maxX)/2
        let callButton = UIButton(frame: CGRect(x: oneQuarter - 70, y: 5, width: 140, height: 30))
        if providerInfo.telephone != "" {
            callButton.setTitle("Call \(providerInfo.telephone)", for: .normal)
            callButton.addTarget(self, action: #selector(callButtonClicked), for: .touchUpInside)
        } else {
            callButton.setTitle("N/A", for: .normal)
        }
        **************/
        
        let callIcon = UIImageView()
        callIcon.translatesAutoresizingMaskIntoConstraints = false
        midViewLeft.addSubview(callIcon)
        callIcon.leadingAnchor.constraint(equalTo: midViewLeft.leadingAnchor, constant: 5).isActive = true
        callIcon.centerYAnchor.constraint(equalTo: midViewLeft.centerYAnchor).isActive = true
        callIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        callIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        callIcon.image = UIImage(named: "Phone Icon")
        
        let callButton = UIButton()
        callButton.translatesAutoresizingMaskIntoConstraints = false
        midViewLeft.addSubview(callButton)
        callButton.centerYAnchor.constraint(equalTo: midViewLeft.centerYAnchor).isActive = true
        callButton.centerXAnchor.constraint(equalTo: midViewLeft.centerXAnchor).isActive = true
        callButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        callButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        if providerInfo.telephone != "" {
            callButton.setTitle("Call \(providerInfo.telephone)", for: .normal)
            callButton.addTarget(self, action: #selector(callButtonClicked), for: .touchUpInside)
        } else {
            callButton.setTitle("N/A", for: .normal)
        }
        callButton.setTitleColor(UIColor.lightGray, for: .normal)
        callButton.titleLabel?.font = callButton.titleLabel?.font.withSize(15)

        
        let mapIcon = UIImageView()
        mapIcon.translatesAutoresizingMaskIntoConstraints = false
        midViewRight.addSubview(mapIcon)
        mapIcon.leadingAnchor.constraint(equalTo: midViewRight.leadingAnchor, constant: 5).isActive = true
        mapIcon.centerYAnchor.constraint(equalTo: midViewRight.centerYAnchor).isActive = true
        mapIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        mapIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        mapIcon.image = UIImage(named: "Map Icon")
        
        let directionsButton = UIButton()
        directionsButton.translatesAutoresizingMaskIntoConstraints = false
        midViewRight.addSubview(directionsButton)
        directionsButton.centerXAnchor.constraint(equalTo: midViewRight.centerXAnchor).isActive = true
        directionsButton.centerYAnchor.constraint(equalTo: midViewRight.centerYAnchor).isActive = true
        directionsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        directionsButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        directionsButton.setTitle("Get Directions", for: .normal)
        directionsButton.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        directionsButton.titleLabel?.textColor = UIColor.lightGray
        directionsButton.setTitleColor(UIColor.lightGray, for: .normal)
        directionsButton.titleLabel?.font = directionsButton.titleLabel?.font.withSize(15)

    }
    
    func setUpBottomView(){
        
        let infoHeading = UILabel()
        contentView.addSubview(infoHeading)
        infoHeading.translatesAutoresizingMaskIntoConstraints = false
        infoHeading.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        infoHeading.topAnchor.constraint(equalTo: midViewLeft.bottomAnchor, constant: 8).isActive = true
        infoHeading.widthAnchor.constraint(equalToConstant: 60).isActive = true
        infoHeading.heightAnchor.constraint(equalToConstant: 20).isActive = true
        infoHeading.text = "Info"
        infoHeading.font = UIFont.boldSystemFont(ofSize: 17)
        
        
        let languagesLabel = UILabel()
        contentView.addSubview(languagesLabel)
        languagesLabel.translatesAutoresizingMaskIntoConstraints = false
        languagesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        languagesLabel.topAnchor.constraint(equalTo: infoHeading.bottomAnchor, constant: 5).isActive = true
        languagesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8).isActive = true
        languagesLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        if providerInfo.languages != "" {
            languagesLabel.text = "Languages: \(providerInfo.languages)"
        } else {
            languagesLabel.text = "Languages not specified"
        }
        languagesLabel.font = languagesLabel.font.withSize(15)
        
        
        let websiteLabel = UILabel()
        contentView.addSubview(websiteLabel)
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteLabel.leadingAnchor.constraint(equalTo: languagesLabel.leadingAnchor).isActive = true
        websiteLabel.topAnchor.constraint(equalTo: languagesLabel.bottomAnchor, constant: 5).isActive = true
        websiteLabel.trailingAnchor.constraint(equalTo: languagesLabel.trailingAnchor).isActive = true
        websiteLabel.heightAnchor.constraint(equalTo: languagesLabel.heightAnchor).isActive = true
        if providerInfo.webAddress != "" {
            websiteLabel.text = "Website: \(providerInfo.webAddress)"
        } else {
            websiteLabel.text = "Website: Not Available"
        }
        websiteLabel.font = websiteLabel.font.withSize(15)

        
        contentView.addSubview(handicapLabel)
        handicapLabel.leadingAnchor.constraint(equalTo: websiteLabel.leadingAnchor).isActive = true
        handicapLabel.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 5).isActive = true
        handicapLabel.trailingAnchor.constraint(equalTo: websiteLabel.trailingAnchor).isActive = true
        handicapLabel.heightAnchor.constraint(equalTo: websiteLabel.heightAnchor).isActive = true
        handicapLabel.text = "Handidap Access: \(providerInfo.handicapAccess)"
        handicapLabel.font = handicapLabel.font.withSize(15)
        
        initProviderLabel()
        
    }
    
    func initProviderLabel() {
        var credentialText = "PROVIDERS:"
        var necessaryLines = 1
        for doctor in providerInfo.doctors {
            credentialText += "\n\t\(doctor.name) - \(doctor.specialty)\n\t\t\(doctor.school) - \(doctor.graduationDate)"
            necessaryLines += 2
        }
        let estRect = credentialText.estimateFrameForText(maxWidth: self.view.frame.width, maxHeight: 1000, font: 15.0)
        
        
        contentView.addSubview(providerLabel)
        providerLabel.topAnchor.constraint(equalTo: handicapLabel.bottomAnchor, constant: 5).isActive = true
        providerLabel.leadingAnchor.constraint(equalTo: handicapLabel.leadingAnchor).isActive = true
        providerLabel.trailingAnchor.constraint(equalTo: handicapLabel.trailingAnchor).isActive = true
        providerLabel.heightAnchor.constraint(equalToConstant: estRect.height).isActive = true
        providerLabel.text = credentialText
        providerLabel.numberOfLines = necessaryLines
        providerLabel.font = providerLabel.font.withSize(15)
    }
    
    /************************************* Map related fuctions *****************************/

    
    /************************************* UIButton functions *******************************/
    
    func callButtonClicked(){
        let callAlert = UIAlertController(title: "Call \(providerInfo.telephone)?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        callAlert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action: UIAlertAction) in
            let phoneString = self.providerInfo.telephone.seperateNumbers()
            guard let number = URL(string: "tel://\(phoneString)") else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
            self.promptAlertWithDelay("Calling \(self.providerInfo.telephone)", inmessage: "This won't work in the simulator, but should work in the device", indelay: 5.0)
        }))
        callAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
            callAlert.dismiss(animated: true, completion: nil)
        }))
        present(callAlert, animated: true, completion: nil)
    }
    
    func getDirections(){
        let directionsAlert = UIAlertController(title: "Get Directions", message: "This action will route you to Maps.", preferredStyle: UIAlertControllerStyle.alert)
        directionsAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction) in
            if self.location != nil {
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: (self.location?.coordinate)!))
                mapItem.name = "\(self.providerInfo.address)"
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            } else {
                self.promptAlertWithDelay("No location found", inmessage: "unable to find the providers location", indelay: 5.0)
            }
        }))
        directionsAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
            directionsAlert.dismiss(animated: true, completion: nil)
        }))
        
        present(directionsAlert, animated: true, completion: nil)
    }
    
    
    
    
}
