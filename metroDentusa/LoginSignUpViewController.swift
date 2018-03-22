//
//  LoginSignUpViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/14/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation



class LoginSignUpViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, userInputFieldDelegate , XMLParserDelegate {
    

    var menuButton : UIBarButtonItem!
    
    //views and subviews
    var scrollView = UIScrollView()
    var contentView = UIView()
    private var segmentIndexFlag = 0
    static var themeColor = UIColor(red: 26/255, green: 122/255, blue: 1, alpha: 1)
    var logoView = UIImageView()
    var homePic =  UIImageView()
    var homePicConstraints : [String: NSLayoutConstraint?] = ["x": nil, "y": nil, "width" : nil, "height": nil] //left, top, width, height
    var subPicLabel = UILabel()
    var loginInputs : [String] = ["",""]
    var createInputs : [String] = ["","",""]
    var formTableView = UITableView()
    var continueButton = UIButton()
    var continueTop : NSLayoutConstraint!
    var forgotPasswordBtn = UIButton()
    let segmentController : UISegmentedControl = UISegmentedControl(items: ["Login", "Create Username"])
    //var benefitCard: BenefitCardView?
    
    //********** XMLParser testing related stuff **********/
    var parser = XMLParser()
    var statusSuccess : Bool = false
    var currUser : member?
    var currSession: URLSession?
    var foundcharacters = ""
    
    init(user: member?, session: URLSession?){
        super.init(nibName: nil, bundle: nil)
        self.currUser = user
        self.currSession = session
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(currUser)")
        self.hideKeyBoardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.navigationItem.title = "Welcome to ASO Data Services!"
        self.toggleMenuButton(menuButton: menuButton)
        setUpScrollAndContentView()
        setUpImages()
        setUpLabel()
        setUpSegmentController()
        setUpTableView()
        setUpButtons()
        
        contentView.bottomAnchor.constraint(equalTo: forgotPasswordBtn.bottomAnchor, constant: 30).isActive = true
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setUpScrollAndContentView(){
        //scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        //scrollView.contentSize = CGSize(width: self.view.frame.width, height: 800)
        //self.view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        scrollView.backgroundColor = UIColor.clear

        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
        
    }
    
    func setUpImages(){
        //logoView = UIImageView(frame: CGRect(x: scrollView.center.x - 70, y: 15, width: 140, height: 40))
        
        //homePic = UIImageView(frame: CGRect(x: 0, y: logoView.frame.maxY + 25, width: scrollView.frame.width, height: 200))
        //scrollView.addSubview(logoView)
        //scrollView.addSubview(homePic)
        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoView)
        logoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        logoView.image = UIImage(named: "Logo Icon")
        logoView.contentMode = .scaleAspectFit
        
        homePic.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(homePic)
        homePic.image = UIImage(named: "HomePic")
        
        
        let orient = UIDevice.current.orientation
        switch orient {
        case .portrait:
           setHomePicPotrait()
        case .landscapeLeft, .landscapeRight:
            setHomePicLandScape()
        default:
            break
        }
    }
    
    func setHomePicPotrait(){
        homePicConstraints["x"] = homePic.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        homePicConstraints["x"]??.isActive = true
        homePicConstraints["y"] = homePic.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 25)
        homePicConstraints["y"]??.isActive = true
        homePicConstraints["width"] = homePic.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        homePicConstraints["width"]??.isActive = true
        homePicConstraints["height"] = homePic.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
        homePicConstraints["height"]??.isActive = true
        homePic.contentMode = .scaleAspectFill
    }
    
    func setHomePicLandScape(){
        homePicConstraints["x"] = homePic.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        homePicConstraints["x"]??.isActive = true
        homePicConstraints["y"] = homePic.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 25)
        homePicConstraints["y"]??.isActive = true
        homePicConstraints["width"] = homePic.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75)
        homePicConstraints["width"]??.isActive = true
        homePicConstraints["height"] = homePic.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5)
        homePicConstraints["height"]??.isActive = true
        homePic.contentMode = .scaleAspectFit
    }
    

    
    func setUpLabel(){
       // let otherLabel = UILabel(frame: CGRect(x: 50, y: homePic.frame.minY + 50, width: 220, height: 40))
        //subPicLabel = UILabel(frame: CGRect(x: scrollView.center.x - 125, y: homePic.frame.maxY + 5, width: 250, height: 40))
        /*scrollView.addSubview(subPicLabel)
         scrollView.addSubview(otherLabel)*/
        
        let otherLabel = UILabel()
        otherLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(otherLabel)
        otherLabel.leadingAnchor.constraint(equalTo: homePic.leadingAnchor, constant: 50).isActive = true
        otherLabel.topAnchor.constraint(equalTo: homePic.bottomAnchor, constant: -50).isActive = true
        otherLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        otherLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
        
        otherLabel.font = UIFont.boldSystemFont(ofSize: 15)
        otherLabel.numberOfLines = 2
        otherLabel.text = "Serving members and their families since 1970"
        contentView.bringSubview(toFront: otherLabel)
        
        subPicLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subPicLabel)
        subPicLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        subPicLabel.topAnchor.constraint(equalTo: homePic.bottomAnchor, constant: 5).isActive = true
        subPicLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        subPicLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        subPicLabel.textColor = UIColor.lightGray
        subPicLabel.numberOfLines = 2
        subPicLabel.font = subPicLabel.font.withSize(13)
        subPicLabel.text = "Login below for more details about plans and benefits"

        
    }
    
    func setUpSegmentController(){
        //segmentController.frame = CGRect(x: scrollView.center.x - 140, y: 196, width: 280, height: 30)
        //scrollView.addSubview(segmentController)
        
        segmentController.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(segmentController)
        segmentController.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        segmentController.topAnchor.constraint(equalTo: subPicLabel.bottomAnchor, constant: 30).isActive = true
        segmentController.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75).isActive = true
        segmentController.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentController.tintColor = UIColor.black
        segmentController.addTarget(self, action: #selector(changeIndex(sender:)), for: .valueChanged)
        segmentController.selectedSegmentIndex = 0
        
    }
    
    func setUpTableView(){
        //formTableView = UITableView(frame: CGRect(x: 47, y: 250, width: 280, height: 200))
        //formTableView = UITableView(frame: CGRect(x: scrollView.center.x - 140, y: segmentController.frame.maxY + 25, width: 280, height: 200))
        formTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(formTableView)
        formTableView.leadingAnchor.constraint(equalTo: segmentController.leadingAnchor).isActive = true
        formTableView.trailingAnchor.constraint(equalTo: segmentController.trailingAnchor).isActive = true
        formTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        formTableView.topAnchor.constraint(equalTo: segmentController.bottomAnchor, constant: 25).isActive = true
        formTableView.dataSource = self
        formTableView.delegate = self
        formTableView.register(formTableViewCell.self, forCellReuseIdentifier: "formCell")
        formTableView.alwaysBounceVertical = false

    }
    
    func setUpButtons(){
        
       // = UIButton(frame: CGRect(x: 92, y: 395, width: 190, height: 44))
      //    = UIButton(frame: CGRect(x: 25, y: 460, width: 320, height: 44))
        //scrollView.addSubview(continueButton)
        //scrollView.addSubview(forgotPasswordBtn)
        //continueButton = UIButton(frame: CGRect(x: scrollView.center.x - 95, y: formTableView.frame.minY + 145, width: 190, height: 44))
        //forgotPasswordBtn = UIButton(frame: CGRect(x: scrollView.center.x - 160, y: continueButton.frame.maxY + 20, width: 320, height: 44))
        
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(continueButton)
        continueTop = continueButton.topAnchor.constraint(equalTo: formTableView.topAnchor, constant: 145)
        continueTop.isActive = true
        continueButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        continueButton.addTarget(self, action: #selector(continueClick), for: .touchUpInside)
        continueButton.setUpDefaultType(title: "Sign In")
        
        
        forgotPasswordBtn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(forgotPasswordBtn)
        
        forgotPasswordBtn.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 20).isActive = true
        forgotPasswordBtn.leadingAnchor.constraint(equalTo: segmentController.leadingAnchor).isActive = true
        forgotPasswordBtn.trailingAnchor.constraint(equalTo: segmentController.trailingAnchor).isActive = true
        forgotPasswordBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        forgotPasswordBtn.addTarget(self, action: #selector(retrievePasswordClick), for: .touchUpInside)
        forgotPasswordBtn.setUpDefaultType(title: "Forgot Password? Click to Retrieve")
        forgotPasswordBtn.isHidden = false
    }
    
    
    func changeIndex(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            segmentIndexFlag = 0
            continueButton.setTitle("Sign In", for: .normal)
            //continueButton.frame.origin.y -= 60
            continueTop.constant -= 60
            forgotPasswordBtn.isHidden = false
            formTableView.reloadData()
            break
        case 1:
            segmentIndexFlag = 1
            continueButton.setTitle("Create Username", for: .normal)
            //continueButton.frame.origin.y += 60
            continueTop.constant += 60
            forgotPasswordBtn.isHidden = true
            formTableView.reloadData()
            break
        default:
            break
        }
        continueButton.layoutIfNeeded()
    }
    
    /*****************************************UIButton functions***********************************/
    
    func continueClick(){
        if segmentIndexFlag == 0{
            let isLoginValid = validateLogin()
            if isLoginValid {
                let activityIndicator = setUpActivityIndicator()
                DispatchQueue.global(qos: .background).async {
                    activityIndicator.startAnimating()
                    AppDelegate().makeHTTPPOSTRequestToGetUser(urlstring: "https://edi.asonet.com/httpserver.ashx?obj=LOGINMEMBER", loginInputs: self.loginInputs, completion: {
                        (/*error: Error?,*/ data: Data?) in
                        if data != nil {
                            print("there was data")
                            if let dataString = String(data: data!, encoding: .utf8){
                                print("\(dataString)")
                                self.parser = XMLParser(data: data!)
                                self.parser.delegate = self
                                let parseDidSucceed = self.parser.parse()
                                DispatchQueue.main.async {
                                    activityIndicator.stopAnimating()
                                    print("\(parseDidSucceed)")
                                    if self.statusSuccess && self.currUser != nil {
                                        if let navBar = self.revealViewController().rearViewController as? navBarController {
                                            navBar.setUser(member: self.currUser!)
                                            navBar.tableView.reloadData()
                                        }
                                        self.promptAlertWithDelay("Welcome Back", inmessage: "Welcome back \((self.currUser?.getUsername())!)", indelay: 1000)
                                        //self.presentBenefitCard()
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
        self.setUpBackBarButton(title: "Back to Login")
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
        cell.contentView.layoutIfNeeded()
        cell.setUpFormTextField()
        cell.formTextField.userInputdelegate = self
        if indexPath.section == 0 {
            if segmentIndexFlag == 0 {
                cell.formTextField.placeholder = "Enter Username"
                cell.formTextField.setVal(val: 0)
            } else {
                cell.formTextField.placeholder = "Last 4 Digits of Social Security"
                cell.formTextField.setVal(val: 2)
            }
        }
        if indexPath.section == 1 {
            if segmentIndexFlag == 0 {
                cell.formTextField.placeholder = "Enter Password"
                cell.formTextField.isSecureTextEntry = true
                cell.formTextField.setVal(val: 1)
            } else {
                cell.formTextField.placeholder = "Members birthday MM/DD/YYYY"
                cell.formTextField.isSecureTextEntry = false
                cell.formTextField.setVal(val: 3)
            }
        }
        if indexPath.section == 2 {
            cell.formTextField.placeholder = "Members ZipCode"
            cell.formTextField.setVal(val: 4)
        }
        
        if segmentIndexFlag == 0{
            cell.formTextField.text = loginInputs[indexPath.section]
        } else {
            cell.formTextField.text = createInputs[indexPath.section]
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
        if elementName == "response"{
            if let status = attributeDict["status"]{
                if status == "SUCCESSFUL" {
                    statusSuccess = true
                } else {
                    statusSuccess = false
                }
            }
            if let id = attributeDict["memberid"]{
                if statusSuccess {
                    currUser = member(id: id, usrname: loginInputs[0], pssword: loginInputs[1], ssId: "")
                }
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
        //print("\(currUser)")
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure Error: \(parseError)")
    }
    
    
}
