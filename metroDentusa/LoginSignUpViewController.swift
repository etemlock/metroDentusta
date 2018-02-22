//
//  LoginSignUpViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/14/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation

class BenefitCardView: UIView {
    private var user: member!
    private var session: URLSession!
    var innerView: UIView!
    private var CardFrame = CGRect(x: 8, y: 110, width: 359, height: 458)
    var dismissButton : UIButton!

    init(user: member, session: URLSession){
        super.init(frame: CardFrame)
        self.user = user
        self.session = session
        self.backgroundColor = UIColor(red: 238/255, green: 236/255, blue: 246/255, alpha: 1)
        self.backgroundColor?.withAlphaComponent(0.5)
        setUpInnerView()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
    func setUpInnerView(){
        innerView = UIView(frame: CGRect(x: 4, y: 4, width: 351, height: 450))
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
        
        let groupLabel = UILabel(frame: CGRect(x: innerView.frame.maxX - 108, y: divider.frame.maxY + 5, width: 100, height: 20))
        groupLabel.text = "Group: #V190"
        
        let idLabel = UILabel(frame: CGRect(x: 8, y: nameLabel.frame.maxY + 5, width: 150, height: 20))
        idLabel.text = "ID#:\(user.getId())"
        
        let activeLabel = UILabel(frame: CGRect(x: innerView.frame.maxX - 108, y: groupLabel.frame.maxY + 5, width: 100, height: 20))
        activeLabel.text = "Level: ACTIVE"
        
        dismissButton = UIButton(frame: CGRect(x: self.center.x - 50 , y: idLabel.frame.maxY + 10, width: 100, height: 40))
        dismissButton.setUpDefaultType(title: "Dismiss")
        
        let disclaimer = UILabel(frame: CGRect(x: 8, y: 208, width: innerView.frame.width-16, height: 230))
        disclaimer.text = "You may receive care from any licensed dentist.\n\nThis plan is subject to maximums and frequency limitations. You are responsible to your dentist for all amounts not covered by the Plan.\n\nYour plan is subject to certain limitations and exclusions. Predeterminations are recommended in order to verify coverage for major work including surgical, periodontal, orthodontia, bridges and implants.\n\nClaim forms should be submitted within 30 days of treatment to:\n\n \tElectronic Claims: Payer ID# CX076\n\tpaper Claims: ASO, PO Box 9005, Lynbrook, NY 11559"
        disclaimer.numberOfLines = 16
        disclaimer.font = disclaimer.font.withSize(12)
        //dismissButton.addTarget(self, action: #selector(hideBenefitCard), for: .touchUpInside)
        
        innerView.addSubview(header)
        innerView.addSubview(logo)
        innerView.addSubview(divider)
        innerView.addSubview(nameLabel)
        innerView.addSubview(groupLabel)
        innerView.addSubview(idLabel)
        innerView.addSubview(activeLabel)
        innerView.addSubview(dismissButton)
        
        for case let label as UILabel in innerView.subviews {
            label.font = label.font.withSize(15)
        }
        
        innerView.addSubview(disclaimer)
        
        self.addSubview(innerView)
    }
    
}


class LoginSignUpViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, userInputFieldDelegate , XMLParserDelegate {
    


    //views and subviews
    var scrollView : UIScrollView!
    private var segmentIndexFlag = 0
    static var themeColor = UIColor(red: 26/255, green: 122/255, blue: 1, alpha: 1)
    var logoView : UIImageView!
    var homePic: UIImageView!
    var menuButton : UIBarButtonItem!
    var subPicLabel: UILabel!
    var loginInputs : [String] = ["",""]
    var createInputs : [String] = ["","",""]
    var formTableView : UITableView!
    var continueButton : UIButton!
    var forgotPasswordBtn : UIButton!
    let segmentController : UISegmentedControl = UISegmentedControl(items: ["Login", "Create Username"])
    var benefitCard: BenefitCardView?
    
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
        self.navigationItem.title = "Welcome to ASO Data Services!"
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        setUpScrollView()
        setUpImages()
        setUpLabel()
        setUpSegmentController()
        setUpTableView()
        setUpButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpScrollView(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scrollView.backgroundColor = UIColor.clear
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 800)
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
        self.view.addSubview(scrollView)
    }
    
    func setUpImages(){
        logoView = UIImageView(frame: CGRect(x: scrollView.center.x - 70, y: 15, width: 140, height: 40))
        logoView.image = UIImage(named: "Logo Icon")
        logoView.contentMode = .scaleAspectFit
        
        homePic = UIImageView(frame: CGRect(x: 0, y: logoView.frame.maxY + 25, width: scrollView.frame.width, height: 200))
        homePic.image = UIImage(named: "HomePic")
        homePic.contentMode = .scaleAspectFill
        
        scrollView.addSubview(logoView)
        scrollView.addSubview(homePic)
    }
    
    func setUpLabel(){
        let otherLabel = UILabel(frame: CGRect(x: 50, y: homePic.frame.minY + 50, width: 220, height: 40))
        otherLabel.font = UIFont.boldSystemFont(ofSize: 15)
        otherLabel.numberOfLines = 2
        otherLabel.text = "Serving members and their families since 1970"
        
        subPicLabel = UILabel(frame: CGRect(x: scrollView.center.x - 125, y: homePic.frame.maxY + 5, width: 250, height: 40))
        subPicLabel.textColor = UIColor.lightGray
        subPicLabel.numberOfLines = 2
        subPicLabel.font = subPicLabel.font.withSize(13)
        subPicLabel.text = "Login below for more details about plans and benefits"
        scrollView.addSubview(subPicLabel)
        scrollView.addSubview(otherLabel)
        scrollView.bringSubview(toFront: otherLabel)
    }
    
    func setUpSegmentController(){
        //segmentController.frame = CGRect(x: scrollView.center.x - 140, y: 196, width: 280, height: 30)
        segmentController.frame = CGRect(x: scrollView.center.x - 140, y: subPicLabel.frame.maxY + 45, width: 280, height: 30)
        segmentController.tintColor = UIColor.black
        segmentController.addTarget(self, action: #selector(changeIndex(sender:)), for: .valueChanged)
        segmentController.selectedSegmentIndex = 0
        scrollView.addSubview(segmentController)
    }
    
    func setUpTableView(){
        //formTableView = UITableView(frame: CGRect(x: 47, y: 250, width: 280, height: 200))
        formTableView = UITableView(frame: CGRect(x: scrollView.center.x - 140, y: segmentController.frame.maxY + 25, width: 280, height: 200))
        formTableView.dataSource = self
        formTableView.delegate = self
        formTableView.register(formTableViewCell.self, forCellReuseIdentifier: "formCell")
        formTableView.alwaysBounceVertical = false
        scrollView.addSubview(formTableView)
    }
    
    func setUpButtons(){
        
       // = UIButton(frame: CGRect(x: 92, y: 395, width: 190, height: 44))
      //    = UIButton(frame: CGRect(x: 25, y: 460, width: 320, height: 44))
        
        continueButton = UIButton(frame: CGRect(x: scrollView.center.x - 95, y: formTableView.frame.minY + 145, width: 190, height: 44))
        continueButton.addTarget(self, action: #selector(continueClick), for: .touchUpInside)
        continueButton.setUpDefaultType(title: "Sign In")
        
        forgotPasswordBtn = UIButton(frame: CGRect(x: scrollView.center.x - 160, y: continueButton.frame.maxY + 20, width: 320, height: 44))
        forgotPasswordBtn.addTarget(self, action: #selector(retrievePasswordClick), for: .touchUpInside)
        forgotPasswordBtn.setUpDefaultType(title: "Forgot Password? Click to Retrieve")
        forgotPasswordBtn.isHidden = false
        scrollView.addSubview(continueButton)
        scrollView.addSubview(forgotPasswordBtn)
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
                                        self.presentBenefitCard()
                                        //self.clearLoginInputsandText()
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
    
    func presentBenefitCard(){
        let alert = UIAlertController(title: "", message: "Would you like to view your benefit Card", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "View", style: .default, handler: { (action: UIAlertAction) in
            if self.tempUser != nil {
                if self.benefitCard != nil {
                    self.benefitCard?.isHidden = false
                } else {
                    self.benefitCard = BenefitCardView(user: self.tempUser!, session: URLSession.shared)
                    self.benefitCard?.dismissButton.addTarget(self, action: #selector(self.dismissCard), for: .touchUpInside)
                    self.view.addSubview(self.benefitCard!)
                }
            } else {
                self.promptAlertWithDelay("Unable to display Benefit Card", inmessage: "we're experiencing problems retrieving your information. Try logging in again", indelay: 5.0)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func dismissCard(){
        benefitCard?.isHidden = true
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
    
    func clearLoginInputsandText(){
        for row in formTableView.visibleCells{
            let cell = row as! formTableViewCell
            cell.formTextField?.text = ""
        }
        loginInputs[0] = ""
        loginInputs[1] = ""
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
        self.foundcharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundcharacters += string
        print("\(self.foundcharacters)")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("\(tempUser)")
        //print("\(expUser.getCurrUser())")
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure Error: \(parseError)")
    }
    
    
    
}
