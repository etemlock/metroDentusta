//
//  providerProfileViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 2/8/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation
import MapKit

class providerProfileViewController : UIViewController {
    var menuButton : UIBarButtonItem!
    var headingView: UIView!
    var mapView: MKMapView!
    var midView: UIView!
    var scrollView: UIScrollView!
    var location : CLLocation?
    var providerInfo : providerModel!
    
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
 
        self.hideKeyBoardWhenTappedAround()
        providerInfo = expProvider.getSingleton()
        
        setUpScrollView()
        setUpHeader()
        setUpMapView()
        setUpMidView()
        setUpBottomView()
    }
    
    /********************************** functions to set up view *******************************/
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
       let estRect = providerInfo.instName.estimateFrameForText(maxWidth: 359, maxHeight: 50, font: 19)
       if estRect.height < 25 {
            headingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90))
       } else {
            headingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 115))
       }
       headingView.backgroundColor = UIColor.white
       let instTitle = UILabel(frame: CGRect(x: headingView.center.x - estRect.width/2, y: 8, width: estRect.width, height: estRect.height))
       instTitle.numberOfLines = 2
       instTitle.text = providerInfo.instName
       instTitle.textAlignment = .center
       instTitle.font = instTitle.font.withSize(19)
       instTitle.textColor = RootViewController.themeColor
        
       let addStr = "\(providerInfo.address) \(providerInfo.city), \(providerInfo.stateZip)"
       let estRect2 = addStr.estimateFrameForText(maxWidth: 359, maxHeight: 40, font: 15)
       let addressLabel = UILabel(frame: CGRect(x: 8, y: instTitle.frame.maxY + 5, width: 359, height: estRect2.height))
       addressLabel.numberOfLines = 2
       addressLabel.text = addStr
       addressLabel.textAlignment = .center
       addressLabel.font = addressLabel.font.withSize(15)
       if estRect2.height > 20 {
           headingView.frame.size.height += 20
       }
       

        
     /*  let addressLabel = UILabel(frame: CGRect(x: 8, y: instTitle.frame.maxY + 5, width: 359, height: 20))
       addressLabel.text = "\(providerInfo.address) \(providerInfo.city), \(providerInfo.stateZip)"
       addressLabel.textAlignment = .center
       addressLabel.font = addressLabel.font.withSize(15)*/
        
       let hourLabel = UILabel(frame: CGRect(x: 8, y: addressLabel.frame.maxY + 5, width: 359, height: 20))
       hourLabel.text = "Hours:  \(providerInfo.hours)"
       hourLabel.textAlignment = .center
       hourLabel.font = hourLabel.font.withSize(15)
        
       headingView.addSubview(instTitle)
       headingView.addSubview(addressLabel)
       headingView.addSubview(hourLabel)
       scrollView.addSubview(headingView)
    }
    
    func setUpMapView(){
        mapView = MKMapView(frame: CGRect(x: 0, y: headingView.frame.maxY+1, width: self.view.frame.width, height: 265))
        if providerInfo.lat != -1 && providerInfo.long != -1 {
            location = CLLocation(latitude: providerInfo.lat, longitude: providerInfo.long)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance((location?.coordinate)!, 1600, 1600)
            mapView.setRegion(coordinateRegion, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = (location?.coordinate)!
            annotation.title = providerInfo.instName
            mapView.addAnnotation(annotation)
        }
        scrollView.addSubview(mapView)
    }
    
    func setUpMidView(){
        midView = UIView(frame: CGRect(x: 0, y: mapView.frame.maxY+1, width: self.view.frame.width, height: 40))
        midView.backgroundColor = UIColor.white
        let midViewDivider = UIView(frame: CGRect(x: midView.center.x-1, y: 0, width: 2, height: midView.frame.height))
        midViewDivider.backgroundColor = UIColor.darkGray
        
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
        //callButton.setTitleColor(UIColor.lightGray, for: .normal)
        //callButton.titleLabel?.textColor = UIColor.lightGray
        
        let mapIcon = UIImageView(frame: CGRect(x: midViewDivider.frame.maxX+5, y: 5, width: 30, height: 30))
        mapIcon.image = UIImage(named: "Map Icon")
        let threeQuarters = mapIcon.frame.maxX + (self.view.frame.width - mapIcon.frame.maxX)/2
        let directionsButton = UIButton(frame: CGRect(x: threeQuarters - 50, y: 5, width: 100, height: 30))
        directionsButton.setTitle("Get Directions", for: .normal)
        directionsButton.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        directionsButton.titleLabel?.textColor = UIColor.lightGray
        
        midView.addSubview(callIcon)
        midView.addSubview(callButton)
        midView.addSubview(mapIcon)
        midView.addSubview(directionsButton)
        midView.addSubview(midViewDivider)
        
        for case let button as UIButton in midView.subviews {
            button.setTitleColor(UIColor.lightGray, for: .normal)
            button.titleLabel?.font = button.titleLabel?.font.withSize(15)
        }
        scrollView.addSubview(midView)
    }
    
    func setUpBottomView(){
        let infoHeading = UILabel(frame: CGRect(x: 8, y: midView.frame.maxY+8, width: 60, height: 20))
        infoHeading.text = "Info"
        infoHeading.font = UIFont.boldSystemFont(ofSize: 17)
        let languagesLabel = UILabel(frame: CGRect(x: 16, y: infoHeading.frame.maxY+5, width: 341, height: 20))
        languagesLabel.text = "Languages: \(providerInfo.languages)"
        let websiteLabel = UILabel(frame: CGRect(x: 16, y: languagesLabel.frame.maxY+5, width: 341, height: 20))
        if providerInfo.webAddress != "" {
            websiteLabel.text = "Website: \(providerInfo.webAddress)"
        } else {
            websiteLabel.text = "Website: Not Available"
        }
        let handicapLabel = UILabel(frame: CGRect(x: 16, y: websiteLabel.frame.maxY+5, width: 341, height: 20))
        handicapLabel.text = "Handidap Access: \(providerInfo.handicapAccess)"
        let providersLabel = estimateDoctorLabel(topY: handicapLabel.frame.maxY+5)
        scrollView.addSubview(languagesLabel)
        scrollView.addSubview(websiteLabel)
        scrollView.addSubview(handicapLabel)
        scrollView.addSubview(providersLabel)
        for case let label as UILabel in scrollView.subviews {
            label.font = label.font.withSize(15)
        }
        scrollView.addSubview(infoHeading)
    }
    
    func estimateDoctorLabel(topY: CGFloat) -> UILabel {
        var credentialText = "PROVIDERS:"
        var necessaryLines = 1
        for doctor in providerInfo.doctors {
            credentialText += "\n\t\(doctor.name) - \(doctor.specialty)\n\t\t\(doctor.school) - \(doctor.graduationDate)"
            necessaryLines += 2
        }
        let estRect = credentialText.estimateFrameForText(maxWidth: 341, maxHeight: 1000, font: 15.0)
        if estRect.height + topY > self.view.frame.height {
            scrollView.contentSize.height += (estRect.height - (self.view.frame.height - topY))
        }
        let credLabel = UILabel(frame: CGRect(x: 16, y: topY, width: 341, height: estRect.height))
        credLabel.text = credentialText
        credLabel.numberOfLines = necessaryLines
        return credLabel
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
