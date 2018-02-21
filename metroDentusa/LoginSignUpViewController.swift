//
//  LoginSignUpViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/14/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation


class LoginSignUpViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, userInputFieldDelegate , XMLParserDelegate {
    
    //views and subviews
    private var segmentIndexFlag = 0
    var loginInputs : [String] = ["",""]
    var createInputs : [String] = ["","",""]
    var menuButton : UIBarButtonItem!
    var formTableView : UITableView!
    let continueButton  = UIButton(frame: CGRect(x: 92, y: 395, width: 190, height: 44))
    let forgotPasswordBtn = UIButton(frame: CGRect(x: 25, y: 460, width: 320, height: 44))
    let segmentController : UISegmentedControl = UISegmentedControl(items: ["Login", "Create Username"])
    
    
    //********** XMLParser testing related stuff **********/
    var parser = XMLParser()
    var statusSuccess : Bool = false
    var tempUser : member?
    var foundcharacters = ""
    //var loginUserArray : [LoginMember] = []
    //var tempMember : LoginMember!
    //var foundCharacters = ""
    //var countryInfoItem : countryInfo!
    //var countryInfoArray : [countryInfo] = []
    //var countryWantedFound = "Czechia"
    //var countryWantedFoundId = Int32(3077311)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardWhenTappedAround()
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = menuButton
        self.navigationItem.title = "Sign Up or Login!"
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        setUpSegmentController()
        setUpTableView()
        setUpButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpSegmentController(){
        segmentController.frame = CGRect(x: 47, y: 196, width: 280, height: 30)
        segmentController.tintColor = UIColor.black
        segmentController.addTarget(self, action: #selector(changeIndex(sender:)), for: .valueChanged)
        segmentController.selectedSegmentIndex = 0
        self.view.addSubview(segmentController)
    }
    
    func setUpTableView(){
        formTableView = UITableView(frame: CGRect(x: 47, y: 250, width: 280, height: 200))
        formTableView.dataSource = self
        formTableView.delegate = self
        formTableView.register(formTableViewCell.self, forCellReuseIdentifier: "formCell")
        formTableView.alwaysBounceVertical = false
        self.view.addSubview(formTableView)
    }
    
    func setUpButtons(){
        continueButton.addTarget(self, action: #selector(continueClick), for: .touchUpInside)
        continueButton.setUpDefaultType(title: "Sign In")
        
        forgotPasswordBtn.addTarget(self, action: #selector(retrievePasswordClick), for: .touchUpInside)
        forgotPasswordBtn.setUpDefaultType(title: "Forgot Password? Click to Retrieve")
        forgotPasswordBtn.isHidden = false
        self.view.addSubview(continueButton)
        self.view.addSubview(forgotPasswordBtn)
    }
    
    func changeIndex(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            segmentIndexFlag = 0
            continueButton.setTitle("Sign In", for: .normal)
            continueButton.frame.origin.y -= 60
            forgotPasswordBtn.isHidden = false
            formTableView.reloadData()
            break
        case 1:
            segmentIndexFlag = 1
            continueButton.setTitle("Create Username", for: .normal)
            continueButton.frame.origin.y += 60
            forgotPasswordBtn.isHidden = true
            formTableView.reloadData()
            break
        default:
            break
        }
    }
    
    /*****************************************UIButton functions***********************************/
    
    func continueClick(){
        if segmentIndexFlag == 0{
            let isLoginValid = validateLogin()
            if isLoginValid {
                DispatchQueue.global(qos: .background).async {
                    AppDelegate().makeHTTPPOSTRequestToGetUser(urlstring: "https://edi.asonet.com/httpserver.ashx?obj=LOGINMEMBER", loginInputs: self.loginInputs, completion: {
                        (error: Error?, data: Data?) in
                        if data != nil {
                            print("there was data")
                            if let dataString = String(data: data!, encoding: .utf8){
                                let start = dataString.startIndex
                                let end = dataString.index(start, offsetBy: 7)
                                let range1 = Range(uncheckedBounds: (start, end))
                                let range2 = Range(uncheckedBounds: (end,dataString.endIndex))
                                let parseString = dataString[range1] + " status" + dataString[range2]
                                print("\(parseString)")
                                let newData = parseString.data(using: .utf8)
                                self.parser = XMLParser(data: newData!)
                                self.parser.delegate = self
                                let parseDidSucceed = self.parser.parse()
                                DispatchQueue.main.async {
                                    print("\(parseDidSucceed)")
                                    if self.statusSuccess && self.tempUser != nil {
                                        let nextVC = welcomeUserViewController()
                                        let backItem = UIBarButtonItem()
                                        backItem.title = "Back"
                                        self.navigationItem.backBarButtonItem = backItem
                                        self.navigationController?.pushViewController(nextVC, animated: true)
                                    } else {
                                        self.promptAlertWithDelay("Error logging in", inmessage: "Username or password incorrect. Please try a different combination", indelay: 5.0)
                                    }
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.promptAlertWithDelay("Error logging in", inmessage: "Could not access data from www.asonet.com. We apologize for the inconvenience", indelay: 5.0)
                            }
                        }
                    })
                }
            }
        } else {
            validateRegistration()
        }
    }
    
    func retrievePasswordClick(){
        let nextVC = retrievePasswordViewController()
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    
    /******************************************************** tableView functions **************************************/
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentIndexFlag == 0 {
            return 2
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "formCell", for: indexPath) as! formTableViewCell
        cell.formTextField?.userInputdelegate = self
        if indexPath.section == 0 {
            if segmentIndexFlag == 0 {
                cell.formTextField?.placeholder = "Enter Username"
                cell.formTextField?.setVal(val: 0)
            } else {
                cell.formTextField?.placeholder = "Last 4 Digits of Social Security"
                cell.formTextField?.setVal(val: 2)
            }
        }
        if indexPath.section == 1 {
            if segmentIndexFlag == 0 {
                cell.formTextField?.placeholder = "Enter Password"
                cell.formTextField?.isSecureTextEntry = true
                cell.formTextField?.setVal(val: 1)
            } else {
                cell.formTextField?.placeholder = "Members birthday MM/DD/YYYY"
                cell.formTextField?.isSecureTextEntry = false
                cell.formTextField?.setVal(val: 3)
            }
        }
        if indexPath.section == 2 {
            cell.formTextField?.placeholder = "Members ZipCode"
            cell.formTextField?.setVal(val: 4)
        }
        
        if segmentIndexFlag == 0{
            cell.formTextField?.text = loginInputs[indexPath.section]
        } else {
            cell.formTextField?.text = createInputs[indexPath.section]
        }
        return cell
    }
    
    /*************************************************** textField functions *****************************************/
    func userInputFieldDidChange(userInputField: userInputField) {
        if let inputTypeInt = userInputField.getVal(){
            switch inputTypeInt {
            case 0:
                loginInputs[0] = userInputField.text!
                break
            case 1:
                loginInputs[1] = userInputField.text!
                break
            case 2:
                createInputs[0] = userInputField.text!
            case 3:
                createInputs[1] = userInputField.text!
            case 4:
                createInputs[2] = userInputField.text!
            default:
                break
            }
        }
    }
    
    /************************************************* form Validations ***********************************************/
    func validateLogin() -> Bool{
        if loginInputs[0].isEmpty || loginInputs[1].isEmpty {
            promptAlertWithDelay("Login Failed", inmessage: "all inputs must be filled", indelay: 5.0)
            return false
        }
        return true
    }
    
    func validateRegistration(){
        let socialRegEx = "^[0-9]{4}$"
        let birthDateRegEx = "(0[1-9]|1[0-2])[/](0[1-9]|[1-2][0-9]|3[0-1])[/]((19([0-9]{2}))|20([0-1][0-9]))"
        let zipCodeRegEx = "^[0-9]{5}(-([0-9]{4}))?"
        for input in createInputs{
            if input.isEmpty {
                promptAlertWithDelay("Create Username failed", inmessage: "all inputs must be filled", indelay: 5.0)
                return
            }
        }
        if !createInputs[0].validatePredicate(regex: socialRegEx){
            promptAlertWithDelay("Create Username failed", inmessage: "social security input requires exactly 4 digits", indelay: 5.0)
        } else if !createInputs[2].validatePredicate(regex: zipCodeRegEx){
            promptAlertWithDelay("Create Username failed", inmessage: "zipcode input  requires format XXXXX or XXXXX-XXXX", indelay: 5.0)
        } else if !createInputs[1].validatePredicate(regex: birthDateRegEx){
            promptAlertWithDelay("Create Username failed", inmessage: "birthdate input requires format MM/DD/YYYY and must be a valid calendar date between 1900-2019", indelay: 5.0)
        } else {
            print("all inputs successful")
        }
    }
    
    /********************************************** xmlParserDelegate functions **************************************/
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "status"{
            if let status = attributeDict["status"]{
                if status == "SUCCESSFUL" {
                    statusSuccess = true
                } else {
                    statusSuccess = false
                }
            }
            if let id = attributeDict["memberid"]{
                tempUser = member(id: id, usrname: loginInputs[0], pssword: loginInputs[1], ssId: "")
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        /*if elementName == "geoname"{
            if countryInfoItem?.countryName == countryWantedFound && countryInfoItem?.geoId == countryWantedFoundId {
                print("found the country!!")
            }
            countryInfoArray.append(countryInfoItem)
            countryInfoItem.clear()
        } else {
            foundCharacters = foundCharacters.trimmingCharacters(in: .newlines)
            if elementName == "toponymName"{
                countryInfoItem?.topoName = foundCharacters
            }
            if elementName == "name"{
                countryInfoItem?.name = foundCharacters
            }
            if elementName == "lat"{
                let s = foundCharacters as NSString
                countryInfoItem?.lat = s.floatValue
            }
            if elementName == "lng"{
                let s = foundCharacters as NSString
                countryInfoItem?.long = s.floatValue
            }
            if elementName == "geonameId"{
                let s = foundCharacters as NSString
                countryInfoItem?.geoId = s.intValue
            }
            if elementName == "countryCode"{
                countryInfoItem?.countryCode = foundCharacters
            }
            if elementName == "countryName"{
                countryInfoItem?.countryName = foundCharacters
            }
        }*/
        self.foundcharacters = ""
        
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundcharacters += string
        print("\(self.foundcharacters)")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        /*for item in loginUserArray {
            print("\(item.username), \(item.password), \(item.StyleSheet), \(item.SectionId)")
        }*/
        /*for counrty in countryInfoArray {
            print("\(counrty)\n")
        }*/
        if tempUser != nil {
            expUser.setCurrUser(toSetModel: tempUser!)
        }
        print("\(expUser.getCurrUser())")
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure Error: \(parseError)")
    }
    
    
    
}
