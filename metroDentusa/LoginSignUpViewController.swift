//
//  LoginSignUpViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/14/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation


class LoginSignUpViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, userInputFieldDelegate , XMLParserDelegate {
    

    //var menuButton : UIBarButtonItem!
    
    //views and subviews
    var scrollView = UIScrollView()
    var contentView = UIView()
    var contentViewBottom : NSLayoutConstraint!
    var retrieveView = retrievePasswordView()
    var retrieveViewTop : NSLayoutConstraint!
    private var segmentIndexFlag = 0
    var logoView = UIImageView()
    var homePic =  UIImageView()
    var homePicConstraints : [String: NSLayoutConstraint?] = ["x": nil, "y": nil, "width" : nil, "height": nil] //left, top, width, height
    var subPicLabel = UILabel()
    var formTableView = UITableView()
    var continueButton = UIButton()
    var continueTop : NSLayoutConstraint!
    var forgotPasswordBtn = UIButton()
    let segmentController : UISegmentedControl = UISegmentedControl(items: ["Login", "Create Username"])
    
    /*********** colors **********/
    static var themeColor = UIColor(red: 26/255, green: 122/255, blue: 1, alpha: 1)
    static var defaultGray = UIColor(red: 229/255, green: 226/255, blue: 233/255, alpha: 1)
    static var defaultButtonTextColor = UIColor(red: 22/255, green: 118/255, blue: 1, alpha: 1)
    //var benefitCard: BenefitCardView?
    
    /*********** data *********/
    private var loginInputW = loginInputWrapper()
    private var createInputW = createInputWrapper()
    var segueId = "goSegue"
    
    //********** XMLParser testing related variables **********/
    var parser = XMLParser()
    var statusSuccess : Bool = false
    var errorMsg = ""
    var currUser : member?
    var newUser: member?
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
        self.hideKeyBoardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Welcome to ASO!"
        self.setUpScrollViewAndContentView(scrollView: self.scrollView, contentView: self.contentView)
        setUpImages()
        setUpLabel()
        setUpSegmentController()
        setUpTableView()
        setUpButtons()
        
        
        
        if getAnchorYPositionDiff(anchorTop: contentView.topAnchor, anchorBottom: self.view.bottomAnchor) > getAnchorYPositionDiff(anchorTop: contentView.topAnchor, anchorBottom: forgotPasswordBtn.bottomAnchor){
            contentViewBottom = contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30)
        } else {
            contentViewBottom = contentView.bottomAnchor.constraint(equalTo: forgotPasswordBtn.bottomAnchor, constant: 90)
        }

        contentViewBottom.isActive = true
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        
        initRetrieveView()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orient = UIDevice.current.orientation
        for constraint in homePicConstraints {
            constraint.value?.isActive = false
        }
        switch orient {
        case .landscapeLeft, .landscapeRight:
            setHomePicLandScape()
        default:
            setHomePicPotrait()
        }
        super.viewWillTransition(to: size, with: coordinator)
        resizeScrollViewForLoginViewAfterTransition(coordinator: coordinator)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId {
            if let navBarView = self.revealViewController().rearViewController as? navBarController {
                navBarView.setUser(member: self.currUser!)
                //navBarView.tableView.reloadData()
            }
        }
    }
    
    
    
    func setUpImages(){
        //logoView = UIImageView(frame: CGRect(x: scrollView.center.x - 70, y: 15, width: 140, height: 40))
        
        //homePic = UIImageView(frame: CGRect(x: 0, y: logoView.frame.maxY + 25, width: scrollView.frame.width, height: 200))
        //scrollView.addSubview(logoView)
        //scrollView.addSubview(homePic)
        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoView)
        logoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        logoView.image = UIImage(named: "Logo Icon")
        logoView.contentMode = .scaleAspectFit
        
        homePic.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(homePic)
        homePic.image = UIImage(named: "HomePic")
        
        let orient = UIDevice.current.orientation
        switch orient {
        case .landscapeLeft, .landscapeRight:
            setHomePicLandScape()
        default:
            setHomePicPotrait()
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
    
    func initRetrieveView(){
         retrieveView.translatesAutoresizingMaskIntoConstraints = false
         contentView.addSubview(retrieveView)
         retrieveViewTop = retrieveView.topAnchor.constraint(equalTo: contentView.bottomAnchor)
         retrieveViewTop.isActive = true
         retrieveView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
         retrieveView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
         retrieveView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
         retrieveView.setUpView()
    }
    
    func resizeScrollViewForLoginViewAfterTransition(coordinator: UIViewControllerTransitionCoordinator){
        coordinator.animate(alongsideTransition: nil, completion: {
            (context) -> Void in
            self.contentViewBottom.isActive = false
            if self.getAnchorYPositionDiff(anchorTop: self.contentView.topAnchor, anchorBottom: self.view.bottomAnchor) > self.getAnchorYPositionDiff(anchorTop: self.contentView.topAnchor, anchorBottom: self.forgotPasswordBtn.bottomAnchor){
                self.contentViewBottom = self.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30)
            } else {
                self.contentViewBottom = self.contentView.bottomAnchor.constraint(equalTo: self.forgotPasswordBtn.bottomAnchor, constant: 90)
            }
            self.contentViewBottom.isActive = true
            self.contentView.layoutIfNeeded()
            self.scrollView.contentSize = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height)
        })
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
            performLoginRequest()
        } else {
            performRegisterRequest()
        }
    }
    

    
    func performLoginRequest(){
        let isLoginValid = validateLogin()
        if isLoginValid {
            let activityIndicator = setUpActivityIndicator()
            DispatchQueue.global(qos: .background).async {
                activityIndicator.startAnimating()
                var loginParams = ["",""]
                for pos in 0...1 {
                    loginParams[pos] = self.loginInputW.getInput(pos: pos)
                }
                AppDelegate().makeHTTPPOSTRequestToGetUser(urlstring: "https://edi.asonet.com/httpserver.ashx?obj=LOGINMEMBER", loginInputs: loginParams, completion: {
                    ( data: Data?, errorDesc: String?) in
                    if data != nil {
                        print("there was data")
                        if let dataString = String(data: data!, encoding: .utf8){
                            print("\(dataString)")
                            self.parser = XMLParser(data: data!)
                            self.parser.delegate = self
                            self.parser.parse()
                            DispatchQueue.main.async {
                                activityIndicator.stopAnimating()
                                if self.statusSuccess && self.currUser != nil {
                                    self.performSegue(withIdentifier: self.segueId, sender: self)
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
    }
    
 
    func performRegisterRequest(){
        let registrationValid = validateRegistration()
        if registrationValid {
            let activityIndicator = setUpActivityIndicator()
            DispatchQueue.global(qos: .background).async {
                activityIndicator.startAnimating()
                var createParams = ["","",""]
                for pos in 0...2 {
                    createParams[pos] = self.createInputW.getInput(pos: pos)
                }
                AppDelegate().makeHTTPPostRequestToCreateUser(urlString: "https://edi.asonet.com/httpserver.ashx?obj=saveNewUserProfile", createInputs: createParams, completion: {
                    (data: Data?, errorDesc: String?) in
                    if data != nil {
                        if let dataString = String(data: data!, encoding: .utf8){
                            print("\(dataString)")
                        }
                        print("there was data")
                        self.parser = XMLParser(data: data!)
                        self.parser.delegate = self
                        self.parser.parse()
                        
                        //probably could use a feature that ensures that parser finishes before it completes.
                        DispatchQueue.main.async {
                            activityIndicator.stopAnimating()
                            if self.statusSuccess && self.newUser != nil {
                                let nextVC = userCreationEditViewController(user: self.newUser!, isNewUser: true)
                                    
                                    
                                    //userCreationViewController(user: self.newUser!, isNewUser: true)
                                self.setUpBackBarButton(title: "Back")
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            } else {
                                self.promptAlertWithDelay("Error Registering", inmessage: self.errorMsg, indelay: 5.0)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.promptAlertWithDelay("Error Registering", inmessage: "Can not proceed with user creation with the inputs provided", indelay: 5.0)
                        }
                    }
                })
                
            }
        }
    }
    
    /****************************** retrieve Password View **************************/
    
    func retrievePasswordClick(){
        retrieveViewTop.isActive = false
        retrieveViewTop = retrieveView.topAnchor.constraint(equalTo: formTableView.topAnchor)
        retrieveViewTop.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        retrieveView.closeBtn.addTarget(self, action: #selector(dismissRetrieveView), for: .touchUpInside)
        retrieveView.barViewBackBtn.addTarget(self, action: #selector(getPreviousRetrieveScreen), for: .touchUpInside)
        
        retrieveView.retrieveQsBtn.addTarget(self, action: #selector(getQuestions), for: .touchUpInside)
        retrieveView.submitBtn.addTarget(self, action: #selector(retrieveOrResetPassword), for: .touchUpInside)
        
        /*let nextVC = retrievePasswordViewController()
        self.setUpBackBarButton(title: "Back to Login")
        self.navigationController?.pushViewController(nextVC, animated: true)*/
    }
    
    func dismissRetrieveView(){
        retrieveViewTop.isActive = false
        retrieveViewTop = retrieveView.topAnchor.constraint(equalTo: contentView.bottomAnchor)
        retrieveViewTop.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        //retrieveView.didDismissView()
    }
    
    func getPreviousRetrieveScreen(){
        if retrieveView.currViewMode == retrieveMode.fetchP.rawValue {
            retrieveView.activateFetchQMode()
        } else if retrieveView.currViewMode == retrieveMode.resetP.rawValue {
            retrieveView.activateFetchPMode()
        }
    }
    
    
    func getQuestions(){
        retrieveView.getQuestions(completion: { (result: String?) in
            if result != "" && result != nil {
                self.promptAlertWithDelay("Error", inmessage: result!, indelay: 5.0)
            }
        })
    }
    
    func retrieveOrResetPassword(){
        if retrieveView.currViewMode == retrieveMode.fetchP.rawValue {
            retrieveView.submitQuestions(completion: { (result: String?) in
                
                guard result != nil && result != "" else {
                    return
                }
                
                if result! == "success" {
                    self.promptAlertWithDelay(result!, inmessage: "Your password should be sent to the email you provided shortly", indelay: 5.0)
                } else {
                    self.promptAlertWithDelay("Error", inmessage: result!, indelay: 5.0)
                }
            })
        } else if retrieveView.currViewMode == retrieveMode.resetP.rawValue {
            retrieveView.changePassword(completion: { (result: String?) in
                guard result != nil && result != "" else {
                    return
                }
                
                if result == "successfully changed password" {
                    self.promptAlertWithDelay("success", inmessage: result!, indelay: 5.0)
                    self.dismissRetrieveView()
                } else {
                    self.promptAlertWithDelay("Error", inmessage: result!, indelay: 5.0)
                }
                
            })
        }
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
            cell.formTextField.text = loginInputW.getInput(pos: indexPath.row)
            //loginInputs[indexPath.section]
        } else {
            cell.formTextField.text = createInputW.getInput(pos: indexPath.row)
            //createInputs[indexPath.section]
        }
        return cell
    }
    
    
    /*************************************************** textField functions *****************************************/
    func userInputFieldDidChange(userInputField: userInputField) {
        if let inputTypeInt = userInputField.getVal(){
            switch inputTypeInt {
            case 0:
                loginInputW.setInput(input: userInputField.text!, pos: 0)
                break
            case 1:
                loginInputW.setInput(input: userInputField.text!, pos: 1)
                break
            case 2:
                createInputW.setInput(input: userInputField.text!, pos: 0)
            case 3:
                createInputW.setInput(input: userInputField.text!, pos: 1)
            case 4:
                createInputW.setInput(input: userInputField.text!, pos: 2)
            default:
                break
            }
        }
    }
    
    /************************************************* form Validations ***********************************************/
    func validateLogin() -> Bool{
        //if loginInputs[0].isEmpty || loginInputs[1].isEmpty {
        let userName = loginInputW.getInput(pos: 0)
        let passWrd = loginInputW.getInput(pos: 1)
        if userName.isEmpty || passWrd.isEmpty {
            promptAlertWithDelay("Login Failed", inmessage: "all inputs must be filled", indelay: 5.0)
            return false
        }
        return true
    }
    
    func validateRegistration() -> Bool {
        let socialRegEx = "^[0-9]{4}$"
        let birthDateRegEx = "(0[1-9]|1[0-2])[/](0[1-9]|[1-2][0-9]|3[0-1])[/]((19([0-9]{2}))|20([0-1][0-9]))"
        let zipCodeRegEx = "^[0-9]{5}(-([0-9]{4}))?"
        //for input in createInputs{
        for x in 0...2{
            let input = createInputW.getInput(pos: x)
            if input.isEmpty {
                promptAlertWithDelay("Create Username failed", inmessage: "all inputs must be filled", indelay: 5.0)
                return false
            }
        }
        if !createInputW.getInput(pos: 0).validatePredicate(regex: socialRegEx) {
            promptAlertWithDelay("Create Username failed", inmessage: "social security input requires exactly 4 digits", indelay: 5.0)
            return false
        }
        if !createInputW.getInput(pos: 2).validatePredicate(regex: zipCodeRegEx) {
            promptAlertWithDelay("Create Username failed", inmessage: "zipcode input  requires format XXXXX or XXXXX-XXXX", indelay: 5.0)
            return false
        }
        if !createInputW.getInput(pos: 1).validatePredicate(regex: birthDateRegEx){
            promptAlertWithDelay("Create Username failed", inmessage: "birthdate input requires format MM/DD/YYYY and must be a valid calendar date between 1900-2019", indelay: 5.0)
            return false
        }
        return true
    }
    
    /********************************************** xmlParserDelegate functions **************************************/
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "response"{
            if let status = attributeDict["status"]{
                if status == "SUCCESSFUL" {
                    statusSuccess = true
                } else {
                    statusSuccess = false
                    if let msg = attributeDict["message"]{
                        errorMsg = msg
                    }
                }
            }
            if let id = attributeDict["userid"]{
                if statusSuccess {
                    newUser = member(id: id, usrname: "", name: "", pssword: "", memId: "", group: "",  ssId: "")
                }
            }
            if let memId = attributeDict["memberid"]{
                if statusSuccess {
                    if segmentIndexFlag == 0 {
                        currUser = member(id: "", usrname: loginInputW.getInput(pos: 0), name: "", pssword: loginInputW.getInput(pos: 1), memId: memId, group: "", ssId: "")
                    } else {
                        newUser?.setMemberId(memId: memId)
                    }
                }
            }
            if let memName = attributeDict["name"]{
                if statusSuccess {
                    currUser?.setName(name: memName)
                }
            }
            if let client = attributeDict["client"]{
                if statusSuccess && currUser != nil {
                    currUser?.setClientId(group: client)
                }
            }
            if let sessionId = attributeDict["sessionguid"] {
                if statusSuccess  {
                    if segmentIndexFlag == 0 && currUser != nil {
                        currUser?.setSessionId(ssId: sessionId)
                    }
                    else if segmentIndexFlag == 1 && newUser != nil {
                        newUser?.setSessionId(ssId: sessionId)
                    }
                }
                
            }
        }
    }
    
    /*func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.foundcharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundcharacters += string
        print("\(self.foundcharacters)")
    }*/
    
    func parserDidEndDocument(_ parser: XMLParser) {
        //print("\(currUser)")
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure Error: \(parseError)")
    }
    
}

class loginInputWrapper {
    private var loginInputs : [String] = ["",""]

    func setInput(input: String, pos: Int){
        if 0...1 ~= pos {
            loginInputs[pos] = input
        }
    }
    
    func getInput(pos: Int) -> String {
        if 0...1 ~= pos {
            return loginInputs[pos]
        }
        return ""
    }
}

class createInputWrapper {
    private var createInputs: [String] = ["","",""]
    
    func setInput(input: String, pos: Int){
        if 0...2 ~= pos {
            createInputs[pos] = input
        }
    }
    
    func getInput(pos: Int) -> String {
        if 0...2 ~= pos {
            return createInputs[pos]
        }
        return ""
    }
}
