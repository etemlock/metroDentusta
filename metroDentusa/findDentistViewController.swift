//
//  findDentistViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 1/7/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation
import MapKit

class findDentistViewController : UIViewController {
    var menuButton : UIBarButtonItem!
    var mapView  = MKMapView(frame: CGRect(x: 0, y: 105, width: 375, height: 325))
    var scrollView : UIScrollView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardWhenTappedAround()
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = menuButton
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        centerMapView(pos: nil, regionRadius: 16000)
        setUpScrollView()
    }
    
    func centerMapView(pos: CLLocationCoordinate2D?, regionRadius: CLLocationDistance){
        var coordinateRegion : MKCoordinateRegion!
        if pos != nil {
            let location = CLLocation(latitude: (pos?.latitude)!, longitude: (pos?.longitude)!)
            coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        } else {
            let initLocation = CLLocation(latitude: 40.6691088, longitude: -73.5566163)
            coordinateRegion = MKCoordinateRegionMakeWithDistance(initLocation.coordinate, regionRadius, regionRadius)
        }
        mapView.setRegion(coordinateRegion, animated: true)
        self.view.addSubview(mapView)
    }
    
    func setUpScrollView(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 430, width: self.view.frame.size.width, height: self.view.frame.size.height-430))
        scrollView.backgroundColor = RootViewController.themeColor
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 600)
        scrollView.alwaysBounceVertical = false
        self.view.addSubview(scrollView)
    }
}
