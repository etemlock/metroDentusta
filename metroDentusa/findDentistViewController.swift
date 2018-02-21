//
//  findDentistViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 1/7/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation
import MapKit

/***
 Contents:
 1. Functions to set up view
 2. Tableview delegate functions
 3. Function trigger by buttons
 4. Pickerview delegate and pickerview related functions
 5. scrollView delegate functions
 6. xmlParser delegate functions
 **/

class findDentistViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate, XMLParserDelegate, setRowDelegate {

    var menuButton : UIBarButtonItem!
    //var mapView  = MKMapView(frame: CGRect(x: 0, y: 105, width: 375, height: 325))
    var scrollView : UIScrollView!
    var tableView: UITableView!
    
    var divider : UIView!
    var resultsCountLabel : UILabel!
    var rollTableViewButton : UIButton!
    var addressTextField = UITextField(frame: CGRect(x: 8, y: 31, width: 360, height: 30))
    var dentistNameTextField = UITextField(frame: CGRect(x: 8, y: 276, width: 360, height: 30))
    var newPickerPop : popUpPickerViewView!
    var tableRolledDown : Bool = true
    
    //instead of a pickerView here, perhaps open a window from the bottom.
    var numResults = 0
    var providerModelArray : [providerModel] = []
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
        self.navigationItem.title = "Find Your Dentist"
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //centerMapView(pos: nil, regionRadius: 16000)
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
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.height)
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
        self.view.addSubview(scrollView)
    }
    
    
    func setUpTableView(){
        //divider with roll up button
        divider = UIView(frame: CGRect(x: 0, y: 386, width: scrollView.frame.size.width, height: 30))
        divider.backgroundColor = UIColor(red: 206/255, green: 205/255, blue: 212/255, alpha: 1)
        rollTableViewButton = UIButton(frame: CGRect(x: 167, y: 0, width: 20, height: 30))
        rollTableViewButton.setTitle("\u{25B2}", for: .normal)
        rollTableViewButton.setTitleColor(UIColor(red: 60/255, green: 136/255, blue: 255/255, alpha: 1), for: .normal)
        rollTableViewButton.addTarget(self, action: #selector(rollUpTable), for: .touchUpInside)
        divider.addSubview(rollTableViewButton)
        scrollView.addSubview(divider)
        
        //tableView
        tableView = UITableView(frame: CGRect(x: 0, y: 416, width: scrollView.frame.size.width, height: scrollView.frame.size.height-416))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "headingCell")
        tableView.register(dentistInfoTableCell.self, forCellReuseIdentifier: "infoCell")
        tableView.alwaysBounceVertical = false
        tableView.tableFooterView = UIView()
        scrollView.addSubview(tableView)
        
        //the label that is to be added later to a dequed headerCell
        resultsCountLabel = UILabel(frame: CGRect(x: tableView.center.x - 130, y: 5, width: 260, height: 20))
        resultsCountLabel.font = resultsCountLabel.font.withSize(15)
        resultsCountLabel.textAlignment = .center
        resultsCountLabel.textColor = UIColor.darkGray
    }
    
    func setUpNonTriggerButtons(){
        let findDentistButton = UIButton(frame: CGRect(x: 88, y: 326, width: 200, height: 40))
        findDentistButton.setUpDefaultType(title: "Find Dentists")
        findDentistButton.addTarget(self, action: #selector(findDentists), for: .touchUpInside)
        scrollView.addSubview(findDentistButton)
    }
    
    
    /*This function basically finds the appropriate values to set to query string"*/
    func setUpSearchParams() -> dentSearchParams {
        var currType = ""
        var currDistance = ""
        var currState = ""
        var patientZip = ""
        var practitionName = ""
        switch selectedDentistType {
            case 1:
                currType = "GP"
            case 2:
                currType = "PER"
            case 3:
                currType = "END"
            case 4:
                currType = "ORT"
            case 5:
                currType = "ORS"
            case 6:
                currType = "PRO"
            case 7:
                currType = "PED"
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
    
    
    
    /************************************ tableView functions ***************************************/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return numResults
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headingCell", for: indexPath)
            cell.contentView.addSubview(resultsCountLabel)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! dentistInfoTableCell
            cell.row = indexPath.row
            cell.setRowdelegate = self
            let providerForCell = providerModelArray[indexPath.row]
            cell.dentistNameLabel.text = providerForCell.instName
            cell.addressLabel1.text = providerForCell.address
            cell.addressLabel2.text = providerForCell.city + ", " + providerForCell.stateZip
            cell.specialtiesLabel.text = ""
            cell.officeProfile.addTarget(self, action: #selector(loadProviderProfile), for: .touchUpInside)
            cell.officeProfile.addTarget(cell, action: #selector(cell.setRowTrigger), for: .touchUpInside)
            var specialties : [String] = []
            for doctor in providerForCell.doctors {
                if specialties.count == 0 {
                    cell.specialtiesLabel.text = doctor.specialty
                    specialties.append(doctor.specialty)
                } else if !specialties.contains(doctor.specialty) {
                    cell.specialtiesLabel.text = cell.specialtiesLabel.text! + ", \(doctor.specialty)"
                    specialties.append(doctor.specialty)
                }
            }
            //cell.phoneNumLabel.text = providerForCell.telephone
            //cell.handicapAccLabel.text = "Handicap Access: \(providerForCell.handicapAccess)"
            /*cell.credentialLabel.text = ""
            for doctor in providerForCell.doctors {
                if doctor.school != "" {
                    cell.credentialLabel.text = cell.credentialLabel.text! + "\(doctor.name.uppercased()) - \(doctor.school) (\(doctor.graduationDate)) - \(doctor.specialty)\n"
                } else {
                    cell.credentialLabel.text = cell.credentialLabel.text! + "\(doctor.name.uppercased()) - \(doctor.specialty)\n"
                }
            }*/
            cell.distanceLabel.text = "\(providerForCell.distance) miles away"
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 30
        }
        return 130
    }
    
    /****************************************** UIButton functions *************************************/
    
    func findDentists(){
        print("clicked findDentist!")
        dismissPopUpPicker()
        let params = setUpSearchParams()
        DispatchQueue.global(qos: .background).async {
            let start = DispatchTime.now()
            AppDelegate().makeHTTPPostRequestToSearchDentists(urlstring: "https://www.asonet.com/httpserver.ashx?obj=getPPOjson", parameters: params, completion: {
                (error: Error?, jsonResult: [[String: Any]]?) in
                
                if jsonResult != nil {
                    self.numResults = (jsonResult?.count)!
                    self.providerModelArray.removeAll()
                    
                    //print("\(jsonResult!)")
                    for result in jsonResult! {
                        var newProvider = providerModel(instName: "", provName: "", languages: "", address: "", city: "", stateZip: "", lat: -1, long: -1, distance: -1, telephone: "", hours: "", handicapAccess: "", webAddress: "", doctors: [])
                        
                        
                        newProvider.instName = String(describing: (result["practicename"])!)
                        newProvider.provName = String(describing: (result["uftpracticename"])!)
                        newProvider.languages = String(describing: (result["languages"])!)
                        newProvider.address = String(describing: (result["address"])!) + String(describing: (result["address2"])!)
                        newProvider.city = String(describing: (result["city"])!)
                        newProvider.stateZip = String(describing: (result["state"])!) + " " + String(describing: (result["zip"])!)
                        if let latitude = Double(String(describing: (result["lattitude"])!)){
                            newProvider.lat = latitude
                        }
                        if let longitude = Double(String(describing: (result["longitude"])!)){
                            newProvider.long = longitude
                        }
                        if let distance = Double(String(describing: (result["distance"])!)){
                            newProvider.distance = distance
                        }
                        newProvider.telephone = String(describing: (result["telephone"])!)
                        newProvider.hours = String(describing: (result["eveninghours"])!) + " " + String(describing: (result["weekendhours"])!)
                        newProvider.handicapAccess = String(describing: (result["handicapaccess"])!).uppercased()
                        if newProvider.handicapAccess != "YES" {
                            newProvider.handicapAccess = "NO"
                        }
                        newProvider.webAddress = String(describing: (result["webaddress"])!)
                        if let providerInfoArray = result["providers"] as? [[String:Any]] {
                            for providerInfo in providerInfoArray {
                                var doctor : (name: String, specialty: String, school: String, graduationDate: String) = ("","","","")
                                doctor.name = String(describing: (providerInfo["providerfirstname"])!) + " " + String(describing: (providerInfo["providerlastname"])!)
                                doctor.specialty = String(describing: (providerInfo["specialtydescription"])!)
                                doctor.school = String(describing: (providerInfo["providerschool"])!)
                                doctor.graduationDate = String(describing: (providerInfo["provideryeargraduated"])!)
                                newProvider.doctors.append(doctor)
                            }
                        }
                        self.providerModelArray.append(newProvider)
                    }
                } else {
                    self.numResults = 0
                }
                self.resultsCountLabel.text = String(self.numResults) + " providers matched your search"
                self.rollUpTable()
                self.tableView.reloadData()
                
                let end = DispatchTime.now()
                let nanotime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let timeInterval = Double(nanotime)/1000000000
                print("time to complete is \(timeInterval)")
                
                DispatchQueue.main.async {
                    print("done\n\n\n")
                }
            })
        }
    }
    
    func rollUpTable(){
        if tableRolledDown {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.divider.frame.origin.y = 61
                self.tableView.frame.origin.y = 91
                self.tableView.frame.size.height = self.scrollView.frame.height - 91
                self.rollTableViewButton.setTitle("\u{25BC}", for: .normal)
                self.tableRolledDown = false
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.divider.frame.origin.y = 386
                //self.divider2.frame.origin.y = 416
                self.tableView.frame.origin.y = 416
                self.tableView.frame.size.height = self.scrollView.frame.height - 426
                self.rollTableViewButton.setTitle("\u{25B2}", for: .normal)
                self.tableRolledDown = true
            }, completion: nil)
        }
    }
    
    
    
    func loadProviderProfile(sender: UIButton){
        
        let nextVC = providerProfileViewController()
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func setRow(row: Int) {
        expProvider.setSingleton(toSetModel: providerModelArray[row])
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
