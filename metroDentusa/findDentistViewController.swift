//
//  findDentistViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 1/7/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation
import MapKit

class findDentistViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, XMLParserDelegate {

    var menuButton : UIBarButtonItem!
    //var mapView  = MKMapView(frame: CGRect(x: 0, y: 105, width: 375, height: 325))
    var scrollView : UIScrollView!
    var tableView: UITableView!
    var divider : UIView!
    var rollTableViewButton : UIButton!
    var heightOfTable: CGFloat!
    var addressTextField = UITextField(frame: CGRect(x: 8, y: 31, width: 360, height: 30))
    var dentistNameTextField = UITextField(frame: CGRect(x: 8, y: 276, width: 360, height: 30))
    var newPickerPop : popUpPickerViewView!
    var tableRolledDown : Bool = true
    
    //instead of a pickerView here, perhaps open a window from the bottom.
    
    var dentistPickerTrigger = UIButton()
    var distancePickerTrigger = UIButton()
    var statePickerTrigger = UIButton()

    
    private var dentistTypeArray = ["All Dentists", "General Practitioners",
                                    "Periodontists","Endodontists",
                                    "Orthodontists","Oral Surgeons",
                                    "Prosthodontists","Pediatric Dentists"]
    
    private var distanceArray = ["Any",
                                 "3 miles", "5 miles",
                                 "10 miles", "20 miles",
                                 "30 miles", "50 miles"]
    
    private var stateArray = ["All States",
                              "Arizona", "California",
                              "Connecticut", "Florida",
                              "Maryland", "New Jersey",
                              "New Mexico","New York",
                              "Nevada", "Pennsylania",
                              "Virginia"]

    var selectedTriggerNum = -1
    private var selectedDentistType = 0
    private var selectedDistance = 0
    private var selectedState = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardWhenTappedAround()
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = menuButton
        self.navigationItem.title = "ASO Benifit Plan"
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //centerMapView(pos: nil, regionRadius: 16000)
        heightOfTable = self.view.frame.height
        setUpScrollView()
        setUpSearchFields()
        setUpNonTriggerButtons()
        setUpTableView()
        newPickerPop = popUpPickerViewView(frame: CGRect(x: 0, y: scrollView.frame.height, width: self.view.frame.width, height: 0))
        scrollView.addSubview(self.newPickerPop)
    }
    
   /* func centerMapView(pos: CLLocationCoordinate2D?, regionRadius: CLLocationDistance){
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
    }*/
    
    func setUpSearchFields(){
        scrollView.addSubview(addressTextField)
        scrollView.addSubview(dentistNameTextField)
        addressTextField.attributedPlaceholder = NSAttributedString(string: "(Optional) full address or zipcode", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        dentistNameTextField.attributedPlaceholder = NSAttributedString(string: "(Optional) Dentist Name", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        for case let textField as UITextField in scrollView.subviews {
            textField.backgroundColor = UIColor(red: 229/255, green: 226/255, blue: 233/255, alpha: 1)
            textField.borderStyle = UITextBorderStyle.roundedRect
            textField.clearButtonMode = .whileEditing
        }
        
        setUpPickerTriggers()
    }
    
    func setUpPickerTriggers(){
        var componentPosition = 71
        for index in 0...2 {
            let label = UILabel(frame: CGRect(x: 123, y: componentPosition, width: 130, height: 20))
            let triggerFrame =  CGRect(x: 16, y: componentPosition + 25, width: 344, height: 35)
            if index == 0 {
                dentistPickerTrigger.frame = triggerFrame
                dentistPickerTrigger.setTitle(dentistTypeArray[0], for: .normal)
                dentistPickerTrigger.layer.borderWidth = 1
                label.text = "Dentist Specialty"
                scrollView.addSubview(dentistPickerTrigger)
            } else if index == 1 {
                distancePickerTrigger.frame = triggerFrame
                distancePickerTrigger.setTitle(distanceArray[0], for: .normal)
                distancePickerTrigger.layer.borderWidth = 1
                label.text = "Distance"
                scrollView.addSubview(distancePickerTrigger)
            } else if index == 2 {
                statePickerTrigger.frame = triggerFrame
                statePickerTrigger.setTitle(stateArray[0], for: .normal)
                statePickerTrigger.layer.borderWidth = 1
                label.text = "State"
                scrollView.addSubview(statePickerTrigger)
            }
            label.textColor = UIColor.lightGray
            label.textAlignment = .center
            scrollView.addSubview(label)
            componentPosition += 65
        }
        
        for case let trigger as UIButton in scrollView.subviews {
            trigger.setTitleColor(UIColor(red: 60/255, green: 136/255, blue: 255/255, alpha: 1), for: .normal)
            trigger.addTarget(self, action: #selector(presentPopUpPickerView), for: .touchUpInside)
            
        }
    }
    
    func setUpScrollView(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        scrollView.backgroundColor = UIColor.clear
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: heightOfTable)
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
        self.view.addSubview(scrollView)
    }
    
    
    func setUpTableView(){
        divider = UIView(frame: CGRect(x: 0, y: 386, width: scrollView.frame.size.width, height: 30))
        divider.backgroundColor = UIColor(red: 206/255, green: 205/255, blue: 212/255, alpha: 1)
        rollTableViewButton = UIButton(frame: CGRect(x: 167, y: 0, width: 20, height: 30))
        rollTableViewButton.setTitle("\u{25B2}", for: .normal)
        rollTableViewButton.setTitleColor(UIColor(red: 60/255, green: 136/255, blue: 255/255, alpha: 1), for: .normal)
        rollTableViewButton.addTarget(self, action: #selector(rollUpTable), for: .touchUpInside)
        divider.addSubview(rollTableViewButton)
        
        scrollView.addSubview(divider)
        tableView = UITableView(frame: CGRect(x: 0, y: 416, width: scrollView.frame.size.width, height: scrollView.frame.size.height-416))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(dentistInfoTableCell.self, forCellReuseIdentifier: "infoCell")
        tableView.alwaysBounceVertical = false
        tableView.tableFooterView = UIView()
        scrollView.addSubview(tableView)
    }
    
    func setUpNonTriggerButtons(){
        let findDentistButton = UIButton(frame: CGRect(x: 88, y: 326, width: 200, height: 40))
        findDentistButton.setUpDefaultType(title: "Find Dentists")
        findDentistButton.addTarget(self, action: #selector(findDentists), for: .touchUpInside)
        scrollView.addSubview(findDentistButton)
    }
    
    func findDentists(){
        print("clicked findDentist!")
        dismissPopUpPicker()
        let params = setUpSearchParams()
        DispatchQueue.global(qos: .background).async {
            let start = DispatchTime.now()
            AppDelegate().searchDentists(urlstring: "https://www.asonet.com/httpserver.ashx?obj=getPPOjson", parameters: params, completion: {
                (error: Error?, jsonResult: [[String: Any]]?) in
    
                if jsonResult != nil {
                    print("\(jsonResult)")
                    /*for result in jsonResult! {
                        let providerInfo = result["practicename"]
                        let state = result["state"]
                        print("\(state),\(providerInfo)")
                    }*/
                    let end = DispatchTime.now()
                    let nanotime = end.uptimeNanoseconds - start.uptimeNanoseconds
                    let timeInterval = Double(nanotime)/1000000000
                    print("time to complete is \(timeInterval)")
                }
                DispatchQueue.main.async {
                    print("done\n\n\n\n")
                }
            })
        }
    }
    
    /*This function basically finds the appropriate values to set to strings"*/
    func setUpSearchParams() -> dentSearchParams {
        var currType = ""
        var currDistance = ""
        var currState = ""
        var patientZip = ""
        var practitionName = ""
        switch selectedDentistType {
            case 1:
                currType = "GP"
            case 5:
                currType = "ORS"
            default:
                break
        }
        switch selectedDistance {
            case 1:
                currDistance = "3"
            case 2:
                currDistance = "5"
            case 3:
                currDistance = "10"
            case 4:
                currDistance = "20"
            case 5:
                currDistance = "30"
            case 6:
                currDistance = "50"
            default:
                break
        }
        switch selectedState {
            case 1:
                currState = "AZ"
            case 2:
                currState = "CA"
            case 3:
                currState = "CT"
            case 4:
                currState = "FL"
            case 5:
                currState = "MA"
            case 6:
                currState = "NJ"
            case 7:
                currState = "NM"
            case 8:
                currState = "NY"
            case 9:
                currState = "NV"
            case 10:
                currState = "PA"
            case 11:
                currState = "VA"
            default:
                break
        }
        if let address = addressTextField.text {
            patientZip = address
        }
        if let name = dentistNameTextField.text {
            practitionName = name
        }
        return dentSearchParams(patientzip: patientZip, distance: currDistance, specialty: currType, state: currState, dentName: practitionName)
    }
    
    
    /********************************** tableView functions ***************************************/
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! dentistInfoTableCell
        cell.dentistNameLabel.text = "DR ANA SCOPU"
        cell.addressLabel1.text = "62-22 Myrtle Ave "
        cell.addressLabel2.text = "Glendale , NY 11385"
        cell.phoneNumLabel.text = "718-821-7432"
        cell.handicapAccLabel.text = "Handicap Access: Yes"
        cell.credentialLabel.text = "ANA SCOPU - NYU (2007) - General Dentistry"
        cell.distanceLabel.text = "(0.16 miles) away"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightOfTable = heightOfTable + tableView.rowHeight
        return 180
    }
    
    func rollUpTable(){
        if tableRolledDown {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.divider.frame.origin.y = 71
                self.tableView.frame.origin.y = 101
                self.tableView.frame.size.height = self.scrollView.frame.height - 101
                self.rollTableViewButton.setTitle("\u{25BC}", for: .normal)
                self.tableRolledDown = false
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.divider.frame.origin.y = 386
                self.tableView.frame.origin.y = 416
                self.tableView.frame.size.height = self.scrollView.frame.height - 416
                self.rollTableViewButton.setTitle("\u{25B2}", for: .normal)
                self.tableRolledDown = true
            }, completion: nil)
        }
    }
    
    /************************************** pickerView functions **********************************/
    func presentPopUpPickerView(sender: UIButton){
        switch sender {
        case dentistPickerTrigger:
            selectedTriggerNum = 0
        case distancePickerTrigger:
            selectedTriggerNum = 1
        case statePickerTrigger:
            selectedTriggerNum = 2
        default:
            break
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.newPickerPop.frame.origin.y = 386
            self.newPickerPop.frame.size.height = self.scrollView.frame.height - 386
        }, completion: nil)
        newPickerPop.updatePickerView()
        newPickerPop.pickerView.delegate = self
        newPickerPop.pickerView.dataSource = self
        
        switch selectedTriggerNum {
        case 0:
            newPickerPop.barLabel.text = "Change Dentist Specialty"
        case 1:
            newPickerPop.barLabel.text = "Change Distance"
        case 2:
            newPickerPop.barLabel.text = "Change State"
        default:
            break
        }
        
        newPickerPop.closeButton.addTarget(self, action: #selector(dismissPopUpPicker), for: .touchUpInside)
    }
    
    func dismissPopUpPicker(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.newPickerPop.frame.origin.y = self.scrollView.frame.height
            self.newPickerPop.frame.size.height = 0
        }, completion: nil)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch selectedTriggerNum {
            case 0:
                return dentistTypeArray.count
            case 1:
                return distanceArray.count
            case 2:
                return stateArray.count
            default:
                return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch selectedTriggerNum {
        case 0:
            return dentistTypeArray[row]
        case 1:
            return distanceArray[row]
        case 2:
            return stateArray[row]
        default:
            return "None"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch selectedTriggerNum {
        case 0:
            dentistPickerTrigger.setTitle(dentistTypeArray[row], for: .normal)
            selectedDentistType = row
        case 1:
            distancePickerTrigger.setTitle(distanceArray[row], for: .normal)
            selectedDistance = row
        case 2:
            statePickerTrigger.setTitle(stateArray[row], for: .normal)
            selectedState = row
        default:
            break
        }
    }
    
    /***************************************** xmlParserDelegate functions **************************/
   /* func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "pposearch"{
            dentistCount += 1
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        return
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        return
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("\(dentistCount)")
    }*/
    

}
