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

class findDentistViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource,  XMLParserDelegate, setRowDelegate {

    var menuButton : UIBarButtonItem!
    
    
    
    /******** views ***********/
    //var mapView  = MKMapView(frame: CGRect(x: 0, y: 105, width: 375, height: 325))
    var scrollView = UIScrollView()
    var contentView = UIView()
    var contentViewBottom : NSLayoutConstraint!
    var stackView = UIStackView()
    var tableView = UITableView()
    var divider = UIView()
    var dividerTop : NSLayoutConstraint!
    var resultsCountLabel = UILabel()
    var findDentistButton = UIButton()
    var rollTableViewButton = UIButton()
    var addressTextField = UITextField()
    var dentistNameTextField = UITextField()
    var newPickerPop = popUpPickerViewView()
    var newPickerPopTop : NSLayoutConstraint!
    var newPickerPopBottom: NSLayoutConstraint!
    var dentistPickerTrigger : UIButton!
    var distancePickerTrigger : UIButton!
    var statePickerTrigger : UIButton!

    /******** data ***********/
    var numResults = 0
    var providerModelArray : [providerModel] = []
    var tableRolledDown : Bool = true
    var viewIsLarge: Bool = false
    
    //note that this is not good, because the lists are not necessarily static.
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
        self.navigationItem.title = "Find Your Dentist"
        self.toggleMenuButton(menuButton: menuButton)
        self.navigationController?.view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
        self.setUpScrollViewAndContentView(scrollView: self.scrollView, contentView: self.contentView)
        setUpStackView()
        setUpNonTriggerButtons()
        
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            if getAnchorYPositionDiff(anchorTop: contentView.topAnchor, anchorBottom: self.view.bottomAnchor) > getAnchorYPositionDiff(anchorTop: contentView.topAnchor, anchorBottom: findDentistButton.bottomAnchor) {
                contentViewBottom = contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                viewIsLarge = true
            } else {
                contentViewBottom = contentView.bottomAnchor.constraint(equalTo: findDentistButton.bottomAnchor, constant: 250)
            }
        default:
            contentViewBottom = contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30)
        }
        contentViewBottom.isActive = true
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        
        setUpTableView()
        initPickerPop()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orient = UIDevice.current.orientation
        
        
        newPickerPopTop.isActive = false
        newPickerPopBottom.isActive = false
        contentViewBottom.isActive = false
        dividerTop.isActive = false
        switch orient {
        case .portrait:
            contentViewBottom = contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30)
            if newPickerPopTop.constant != 0 {
                newPickerPopTop = newPickerPop.topAnchor.constraint(equalTo: findDentistButton.bottomAnchor, constant: 10)
                newPickerPopBottom = newPickerPop.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            }
            if !tableRolledDown {
                dividerTop = divider.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 5)
            }
        case .landscapeLeft, .landscapeRight:
            contentViewBottom = contentView.bottomAnchor.constraint(equalTo: findDentistButton.bottomAnchor, constant: 250)
            if newPickerPopTop.constant != 0 {
                newPickerPopTop = newPickerPop.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200)
                newPickerPopBottom = newPickerPop.bottomAnchor.constraint(equalTo: newPickerPop.topAnchor, constant: 200)
            }
            if !tableRolledDown {
                dividerTop = divider.topAnchor.constraint(equalTo: dentistPickerTrigger.bottomAnchor, constant: 5)
            }
        default:
            break
        }
        contentViewBottom.isActive = true
        newPickerPopTop.isActive = true
        newPickerPopBottom.isActive = true
        dividerTop.isActive = true
        
        self.resizeScrollViewAfterTransition(coordinator: coordinator, scrollView: self.scrollView, contentView: self.contentView)
    }
    

    func setUpStackView(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 281).isActive = true
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 8.0
        setUpSearchFields()
        
    }
    
    func setUpSearchFields(){
        
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(addressTextField)
        addressTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addressTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        addressTextField.attributedPlaceholder = NSAttributedString(string: "(Optional) full address or zipcode", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        
        setUpPickerTriggers()
        
        let fillerView = UIView()
        fillerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(fillerView)
        fillerView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        fillerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        fillerView.backgroundColor = UIColor.clear
        
        dentistNameTextField.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(dentistNameTextField)
        dentistNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dentistNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        dentistNameTextField.attributedPlaceholder = NSAttributedString(string: "(Optional) Dentist Name", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        for case let textField as UITextField in stackView.arrangedSubviews {
            textField.backgroundColor = LoginSignUpViewController.defaultGray
            textField.borderStyle = UITextBorderStyle.roundedRect
            textField.clearButtonMode = .whileEditing
        }
        
    }
    
    func setUpPickerTriggers(){
        for index in 0...2 {
            let searchCapsule = UIView()
            searchCapsule.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(searchCapsule)
            searchCapsule.heightAnchor.constraint(equalToConstant: 60).isActive = true
            searchCapsule.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            searchCapsule.backgroundColor = UIColor.clear
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            searchCapsule.addSubview(label)
            label.centerXAnchor.constraint(equalTo: searchCapsule.centerXAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: 150).isActive = true
            label.heightAnchor.constraint(equalToConstant: 20).isActive = true
            label.topAnchor.constraint(equalTo: searchCapsule.topAnchor).isActive = true
            label.textColor = UIColor.lightGray
            label.textAlignment = .center
            
            let triggerButton = UIButton()
            triggerButton.translatesAutoresizingMaskIntoConstraints = false
            searchCapsule.addSubview(triggerButton)
            triggerButton.widthAnchor.constraint(equalTo: searchCapsule.widthAnchor).isActive = true
            triggerButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
            triggerButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
            triggerButton.centerXAnchor.constraint(equalTo: searchCapsule.centerXAnchor).isActive = true
            triggerButton.setTitleColor(UIColor(red: 60/255, green: 136/255, blue: 255/255, alpha: 1), for: .normal)
            triggerButton.addTarget(self, action: #selector(presentPopUpPickerView), for: .touchUpInside)
            
            if index == 0 {
                dentistPickerTrigger = triggerButton
                dentistPickerTrigger.setTitle(dentistTypeArray[0], for: .normal)
                dentistPickerTrigger.layer.borderWidth = 1
                label.text = "Dentist Specialty"
            } else if index == 1 {
                distancePickerTrigger = triggerButton
                distancePickerTrigger.setTitle(distanceArray[0], for: .normal)
                distancePickerTrigger.layer.borderWidth = 1
                label.text = "Distance"
            } else if index == 2 {
                statePickerTrigger = triggerButton
                statePickerTrigger.setTitle(stateArray[0], for: .normal)
                statePickerTrigger.layer.borderWidth = 1
                label.text = "State"
            }
        }
    }
    
    func setUpNonTriggerButtons(){
        findDentistButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(findDentistButton)
        findDentistButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 35).isActive = true
        findDentistButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        findDentistButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        findDentistButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        findDentistButton.setUpDefaultType(title: "Find Dentists")
        findDentistButton.addTarget(self, action: #selector(findDentists), for: .touchUpInside)
    }

    
    
    func setUpTableView(){
        //divider with roll up button
        divider.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(divider)
        dividerTop = divider.topAnchor.constraint(equalTo: findDentistButton.bottomAnchor, constant: 10)
        dividerTop.isActive = true
        divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        divider.backgroundColor = UIColor(red: 206/255, green: 205/255, blue: 212/255, alpha: 1)
        
        rollTableViewButton.translatesAutoresizingMaskIntoConstraints = false
        divider.addSubview(rollTableViewButton)
        rollTableViewButton.centerXAnchor.constraint(equalTo: divider.centerXAnchor).isActive = true
        rollTableViewButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        rollTableViewButton.heightAnchor.constraint(equalTo: divider.heightAnchor).isActive = true
        rollTableViewButton.centerYAnchor.constraint(equalTo: divider.centerYAnchor).isActive = true
        rollTableViewButton.setTitle("\u{25B2}", for: .normal)
        rollTableViewButton.setTitleColor(LoginSignUpViewController.themeColor, for: .normal)
        rollTableViewButton.addTarget(self, action: #selector(rollUpTable), for: .touchUpInside)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: divider.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: divider.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: divider.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "headingCell")
        tableView.register(dentistInfoTableCell.self, forCellReuseIdentifier: "infoCell")
        tableView.alwaysBounceVertical = false
        tableView.tableFooterView = UIView()
        
    }
    
    func initPickerPop(){
        newPickerPop.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newPickerPop)
        newPickerPopTop = newPickerPop.topAnchor.constraint(equalTo: contentView.bottomAnchor)
        newPickerPopTop.isActive = true
        newPickerPop.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        newPickerPop.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        newPickerPopBottom = newPickerPop.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        newPickerPopBottom.isActive = true
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
    
    func setUpResultCountLabel(cellContentView: UIView){
        /*resultsCountLabel = UILabel(frame: CGRect(x: tableView.center.x - 130, y: 5, width: 260, height: 20))
        resultsCountLabel.font = resultsCountLabel.font.withSize(15)
        resultsCountLabel.textAlignment = .center
        resultsCountLabel.textColor = UIColor.darkGray*/
        
        resultsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        cellContentView.addSubview(resultsCountLabel)
        resultsCountLabel.leadingAnchor.constraint(equalTo: cellContentView.leadingAnchor, constant: 16).isActive = true
        resultsCountLabel.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor, constant: -16).isActive = true
        resultsCountLabel.centerYAnchor.constraint(equalTo: cellContentView.centerYAnchor).isActive = true
        resultsCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        resultsCountLabel.textAlignment = .center
        resultsCountLabel.textColor = UIColor.darkGray
        
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
            setUpResultCountLabel(cellContentView: cell.contentView)
            //cell.contentView.addSubview(resultsCountLabel)
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
            if addressTextField.text != "" {
                cell.distanceLabel.text = "\(providerForCell.distance) miles away"
            }
            /*else {
                cell.distanceLabel.text = "Info not available"
            }*/
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
                (jsonResult: [[String: Any]]?, errorDesc: String?) in
                self.providerModelArray.removeAll()
                if jsonResult != nil {
                    self.numResults = (jsonResult?.count)!
                    //self.providerModelArray.removeAll()
                    
                    for result in jsonResult! {
                        //print("\(result)")
                        var newProvider = providerModel(instName: "" /*, provName: ""*/, languages: "", address: "", city: "", stateZip: "", lat: -1, long: -1, distance: -1, telephone: "", hours: "", handicapAccess: "", webAddress: "", doctors: [])
                        
                        if let resultName = result["practicename"] {
                            newProvider.instName = String(describing: resultName)
                        }
                        if let resultLang = result["languages"] {
                            newProvider.languages = String(describing: resultLang)
                        }
                        if let resultAdd1 = result["address"]{
                            newProvider.address = String(describing: resultAdd1)
                        }
                        if let resultAdd2 = result["address2"]{
                            newProvider.address += " \(String(describing: resultAdd2))"
                        }
                        if let resultCity = result["city"]{
                            newProvider.city = String(describing: resultCity)
                        }
                        if let resultState = result["state"]{
                            newProvider.stateZip = String(describing: resultState)
                        }
                        if let resultZip = result["zip"]{
                            newProvider.stateZip += " \(String(describing: resultZip))"
                        }
                        if let resultLat = result["lattitude"], let latitude = Double(String(describing: resultLat))  {
                              newProvider.lat = latitude
                        }
                        if let resultLong = result["longitude"], let longitude = Double(String(describing: resultLong)) {
                            newProvider.long = Double(String(describing: longitude))!
                        }
                        if let resultDist = result["distance"], let distance = Double(String(describing: resultDist)){
                            newProvider.distance = distance
                        }
                        if let resultPhone = result["telephone"]{
                            newProvider.telephone = String(describing: resultPhone)
                        }
                        if let resultEHours = result["eveninghours"]{
                            newProvider.hours = String(describing: resultEHours)
                        }
                        if let resultWHours = result["weekendhours"]{
                            newProvider.hours += " \(String(describing: resultWHours))"
                        }
                        if let resultHandicap = result["handicapaccess"]{
                            newProvider.handicapAccess = String(describing: resultHandicap).uppercased()
                            if newProvider.handicapAccess != "YES" {
                                newProvider.handicapAccess = "NO"
                            }
                        }
                        if let resultWeb = result["webaddress"]{
                            newProvider.webAddress = String(describing: resultWeb)
                        }
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
                    if errorDesc != nil {
                        self.promptAlertWithDelay("Error", inmessage: errorDesc!, indelay: 5.0)
                    } else {
                        self.promptAlertWithDelay("Error", inmessage: "Could not access data from www.asonet.com", indelay: 5.0)
                    }
                }
                self.resultsCountLabel.text = String(self.numResults) + " providers matched your search"
               
                if self.tableView.numberOfRows(inSection: 0) > 0 {
                   self.tableView.scrollToFirstRow(sectionNum: 0)
                }
                self.tableView.reloadData()
                self.rollUpTable()
                self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
                
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
            dividerTop.isActive = false
            switch UIDevice.current.orientation {
            case .landscapeRight, .landscapeLeft:
                dividerTop = divider.topAnchor.constraint(equalTo: dentistPickerTrigger.bottomAnchor, constant: 5)
            default:
                dividerTop = divider.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 5)
            }
            dividerTop.isActive = true
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.view.layoutIfNeeded()
                self.rollTableViewButton.setTitle("\u{25BC}", for: .normal)
                self.tableRolledDown = false
            }, completion: nil)
        } else {
            dividerTop.isActive = false
            dividerTop = divider.topAnchor.constraint(equalTo: findDentistButton.bottomAnchor, constant: 10)
            dividerTop.isActive = true
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.view.layoutIfNeeded()
                self.rollTableViewButton.setTitle("\u{25B2}", for: .normal)
                self.tableRolledDown = true
            }, completion: nil)
        }
    }
    

    
    
    func loadProviderProfile(sender: UIButton){
        
        let nextVC = providerProfileViewController()
        self.setUpBackBarButton(title: "Find Dentists")
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
        
        newPickerPopTop.isActive = false
        newPickerPopBottom.isActive = false
        switch UIDevice.current.orientation {
        case .landscapeRight, .landscapeLeft:
            newPickerPopTop = newPickerPop.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200)
            newPickerPopBottom = newPickerPop.bottomAnchor.constraint(equalTo: newPickerPop.topAnchor, constant: 200)
        default:
            newPickerPopTop = newPickerPop.topAnchor.constraint(equalTo: findDentistButton.bottomAnchor, constant: 10)
        }
        newPickerPopTop.isActive = true
        newPickerPopBottom.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
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
        newPickerPop.pickerView.delegate = self
        newPickerPop.pickerView.dataSource = self
        
        newPickerPop.closeButton.addTarget(self, action: #selector(dismissPopUpPicker), for: .touchUpInside)
    }
    
    func dismissPopUpPicker(){
        newPickerPopTop.isActive = false
        newPickerPopBottom.isActive = false
        newPickerPopTop = newPickerPop.topAnchor.constraint(equalTo: contentView.bottomAnchor)
        newPickerPopBottom = newPickerPop.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        newPickerPopBottom.isActive = true
        newPickerPopTop.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.view.layoutIfNeeded()
            //self.newPickerPop.frame.origin.y = self.scrollView.frame.height
            //self.newPickerPop.frame.size.height = 0
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
