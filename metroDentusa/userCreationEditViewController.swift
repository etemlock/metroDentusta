//
//  userCreationEditViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 4/18/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class userCreationEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, userInputFieldDelegate , XMLParserDelegate {
    
    var menuButton : UIBarButtonItem!
    /******* views *******/
    var scrollView = UIScrollView()
    var contentView = UIView()
    var newUserNameTxtFld = UITextField()
    var confirmUserNameTxtFld = UITextField()
    var newPasswordTxtFld = UITextField()
    var confirmPasswordTxtFld = UITextField()
    var emailTableView = UITableView()
    var securityQATableView = UITableView()
    var saveUserButton = UIButton()
    
    /********* data **********/
    var labelCellId = ""
    var formCellId = "formCell"
    private var saveParams = SaveUserParams()
    var user : member!
    var isNewMember: Bool!
    
    /*************** XMLParser related variables ************/
    var parser = XMLParser()
    var statusSuccess : Bool = false
    var errorMsg = ""
    
    
    
    
    init(user: member, isNewUser: Bool){
        super.init(nibName: nil, bundle: nil)
        self.user = user
        self.isNewMember = isNewUser
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isNewMember! {
            self.navigationItem.title = "User Creation"
        } else {
            self.navigationItem.title = "Edit User Profile"
        }
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.toggleMenuButton(menuButton: menuButton)
        self.navigationController?.view.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        self.hideKeyBoardWhenTappedAround()
        edgesForExtendedLayout = []
        self.setUpScrollViewAndContentView(scrollView: self.scrollView, contentView: self.contentView)
        setUpUserNamePasswordFields()
        setUpTableViews()
        setUpButton()
        contentView.bottomAnchor.constraint(equalTo: saveUserButton.bottomAnchor, constant: 250).isActive = true
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.resizeScrollViewAfterTransition(coordinator: coordinator, scrollView: self.scrollView, contentView: self.contentView)
    }
    
    
    func setUpUserNamePasswordFields(){
        let newUserLabel = UILabel()
        let cfrmUserLabel = UILabel()
        let newPassLabel = UILabel()
        let cfrmPassLabel = UILabel()
        
        /***************** first row **********************/
        newUserLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newUserLabel)
        newUserLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        newUserLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        newUserLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -2).isActive = true
        newUserLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        newUserLabel.text = "New Username"

        
        cfrmUserLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cfrmUserLabel)
        cfrmUserLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 2).isActive = true
        cfrmUserLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        cfrmUserLabel.topAnchor.constraint(equalTo: newUserLabel.topAnchor).isActive = true
        cfrmUserLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cfrmUserLabel.text = "Confirm Username"
        
        newUserNameTxtFld.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newUserNameTxtFld)
        newUserNameTxtFld.topAnchor.constraint(equalTo: newUserLabel.bottomAnchor, constant: 2).isActive = true
        newUserNameTxtFld.leadingAnchor.constraint(equalTo: newUserLabel.leadingAnchor).isActive = true
        newUserNameTxtFld.trailingAnchor.constraint(equalTo: newUserLabel.trailingAnchor).isActive = true
        newUserNameTxtFld.heightAnchor.constraint(equalToConstant: 30).isActive = true
        newUserNameTxtFld.text = self.user.getUsername()
        
        confirmUserNameTxtFld.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(confirmUserNameTxtFld)
        confirmUserNameTxtFld.topAnchor.constraint(equalTo: newUserNameTxtFld.topAnchor).isActive = true
        //confirmUserNameTxtFld.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 2).isActive = true
        confirmUserNameTxtFld.leadingAnchor.constraint(equalTo: cfrmUserLabel.leadingAnchor).isActive = true
        confirmUserNameTxtFld.trailingAnchor.constraint(equalTo: cfrmUserLabel.trailingAnchor).isActive = true
        confirmUserNameTxtFld.heightAnchor.constraint(equalToConstant: 30).isActive = true
        confirmUserNameTxtFld.text = self.user.getUsername()
        
        /******************** second row *************************/
        newPassLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newPassLabel)
        newPassLabel.topAnchor.constraint(equalTo: newUserNameTxtFld.bottomAnchor, constant: 20).isActive = true
        newPassLabel.leadingAnchor.constraint(equalTo: newUserLabel.leadingAnchor).isActive = true
        newPassLabel.trailingAnchor.constraint(equalTo: newUserLabel.trailingAnchor).isActive = true
        newPassLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        newPassLabel.text = "New Password"
        
        cfrmPassLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cfrmPassLabel)
        cfrmPassLabel.topAnchor.constraint(equalTo: newPassLabel.topAnchor).isActive = true
        cfrmPassLabel.leadingAnchor.constraint(equalTo: cfrmUserLabel.leadingAnchor).isActive = true
        cfrmPassLabel.trailingAnchor.constraint(equalTo: cfrmUserLabel.trailingAnchor).isActive = true
        cfrmPassLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cfrmPassLabel.text = "Confirm Password"
        
        newPasswordTxtFld.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newPasswordTxtFld)
        newPasswordTxtFld.topAnchor.constraint(equalTo: newPassLabel.bottomAnchor, constant: 2).isActive = true
        newPasswordTxtFld.leadingAnchor.constraint(equalTo: newUserNameTxtFld.leadingAnchor).isActive = true
        newPasswordTxtFld.trailingAnchor.constraint(equalTo: newUserNameTxtFld.trailingAnchor).isActive = true
        newPasswordTxtFld.heightAnchor.constraint(equalToConstant: 30).isActive = true
        newPasswordTxtFld.isSecureTextEntry = true
        newPasswordTxtFld.text = self.user.getPassword()
        
        confirmPasswordTxtFld.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(confirmPasswordTxtFld)
        confirmPasswordTxtFld.topAnchor.constraint(equalTo: newPasswordTxtFld.topAnchor).isActive = true
        confirmPasswordTxtFld.leadingAnchor.constraint(equalTo: confirmUserNameTxtFld.leadingAnchor).isActive = true
        confirmPasswordTxtFld.trailingAnchor.constraint(equalTo: confirmUserNameTxtFld.trailingAnchor).isActive = true
        confirmPasswordTxtFld.heightAnchor.constraint(equalToConstant: 30).isActive = true
        confirmPasswordTxtFld.isSecureTextEntry = true
        confirmPasswordTxtFld.text = self.user.getPassword()
        
        
        
        for case let label as UILabel in contentView.subviews {
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.backgroundColor = LoginSignUpViewController.themeColor
        }
        
        for case let textField as UITextField in contentView.subviews {
            textField.borderStyle = UITextBorderStyle.roundedRect
            textField.clearButtonMode = .whileEditing
        }
        
        
    }
    
    func setUpTableViews(){
        emailTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailTableView)
        emailTableView.topAnchor.constraint(equalTo: newPasswordTxtFld.bottomAnchor, constant: 30).isActive = true
        emailTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        emailTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        emailTableView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        emailTableView.register(cellClass: labelCell.self)
        emailTableView.register(formTableViewCell.self, forCellReuseIdentifier: formCellId)
        emailTableView.delegate = self
        emailTableView.dataSource = self
        emailTableView.alwaysBounceVertical = false
        
        securityQATableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(securityQATableView)
        securityQATableView.topAnchor.constraint(equalTo: emailTableView.bottomAnchor, constant: 50).isActive = true
        securityQATableView.leadingAnchor.constraint(equalTo: emailTableView.leadingAnchor).isActive = true
        securityQATableView.trailingAnchor.constraint(equalTo: emailTableView.trailingAnchor).isActive = true
        securityQATableView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        securityQATableView.register(cellClass: labelCell.self)
        securityQATableView.register(formTableViewCell.self, forCellReuseIdentifier: formCellId)
        securityQATableView.delegate = self
        securityQATableView.dataSource = self
        securityQATableView.alwaysBounceVertical = false
    }
    
    func setUpButton(){
        saveUserButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(saveUserButton)
        saveUserButton.topAnchor.constraint(equalTo: securityQATableView.bottomAnchor, constant: 40).isActive = true
        saveUserButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        saveUserButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        saveUserButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        saveUserButton.setUpDefaultType(title: "Save User")
        saveUserButton.addTarget(self, action: #selector(saveWasClicked), for: .touchUpInside)
        
    }
    
    
    /****************************************** UITableView Delegate *********************************/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        /*if tableView == formTableView {
            return 6
        } else if tableView == securityQATableView {
            return 4
        }
        return 0*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == emailTableView {
            return 4
        } else if tableView == securityQATableView {
            return 8
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if(indexPath.row % 2 == 0){
            let blueCell = tableView.dequeueReusableCell(ofType: labelCell.self, for: indexPath)
            blueCell.contentView.backgroundColor = LoginSignUpViewController.themeColor
            blueCell.setUpDefaultcellLabel()
            if tableView == emailTableView {
                switch indexPath.row {
                case 0:
                   blueCell.cellLabel.text = "Email Address"
                case 2:
                   blueCell.cellLabel.text = "Confirm Email Address"
                default:
                    break
                }
            } else if tableView == securityQATableView {
                switch indexPath.row {
                case 0:
                    blueCell.cellLabel.text = "Change/Add Security Question 1"
                case 2:
                    blueCell.cellLabel.text = "Answer to Security Question 1"
                case 4:
                    blueCell.cellLabel.text = "Change/Add Security Question 2"
                case 6:
                    blueCell.cellLabel.text = "Answer to Security Question 2"
                default:
                    break
                }
            }
            blueCell.selectionStyle = .none
            cell = blueCell
        } else {
            let whiteCell = tableView.dequeueReusableCell(withIdentifier: formCellId, for: indexPath) as! formTableViewCell
            whiteCell.setUpFormTextField()
            whiteCell.formTextField.backgroundColor = UIColor.white
            whiteCell.formTextField.userInputdelegate = self
            
            //Hey, instead of all these ambigious setVal functions why don't you just have a protocol. You'd have to create a protocol however.
            if tableView == emailTableView {
                switch indexPath.row {
                case 1:
                    whiteCell.formTextField.setVal(val: 0)
                case 3:
                    whiteCell.formTextField.setVal(val: 1)
                default:
                    break
                }
            } else if tableView == securityQATableView {
                switch indexPath.row {
                case 1:
                    whiteCell.formTextField.setVal(val: 2)
                case 3:
                    whiteCell.formTextField.setVal(val: 3)
                case 5:
                    whiteCell.formTextField.setVal(val: 4)
                case 7:
                    whiteCell.formTextField.setVal(val: 5)
                default:
                    break
                }
            }
            whiteCell.selectionStyle = .none
            cell = whiteCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    /************************************************* textField delegate functions **********************************************/
    
    func userInputFieldDidChange(userInputField: userInputField) {
        if let inputTypeInt = userInputField.getVal() {
            switch inputTypeInt {
            case 0:
                saveParams.setMail(newMail: userInputField.text!)
            case 1:
                saveParams.setMailCfrm(newMail: userInputField.text!)
            case 2:
                saveParams.setSecurityQuestion1(question: userInputField.text!)
            case 3:
                saveParams.setAnswer1(answer: userInputField.text!)
            case 4:
                saveParams.setSecurityQuestion2(question: userInputField.text!)
            case 5:
                saveParams.setAnswer2(answer: userInputField.text!)
            default:
                break
            }
        }
    }
    
    /**************************************** UIButton Action ******************************************/
    
    func saveWasClicked(){
        let inputsValid = validateAndSetInputs()
        if inputsValid {
            let activityIndicator = setUpActivityIndicator()
            DispatchQueue.global(qos: .background).async {
                activityIndicator.startAnimating()
                self.saveParams.setSessionID(sessId: self.user.getSessionId())
                self.saveParams.setSuID(suId: self.user.getId())
                AppDelegate().makeHTTPPostRequestToSaveUser(urlString: "https://edi.asonet.com/httpserver.ashx?obj=saveUserProfile", params: self.saveParams, completion: { (data: Data?, errorDesc: String?) in
                    if data != nil {
                        if let dataString = String(data: data!, encoding: .utf8){
                            print("\(dataString)")
                        }
                        self.parser = XMLParser(data: data!)
                        self.parser.delegate = self
                        self.parser.parse()
                        DispatchQueue.main.async {
                            if self.statusSuccess {
                                var revealVC : SWRevealViewController? = nil
                                let newName = self.saveParams.getName(getConfirmField: false)
                                let newPass = self.saveParams.getPass(getConfirmField: false)
                                self.user.setUsername(name: newName)
                                self.user.setPassword(pass: newPass)
                                
                                //set revealVC appropriately
                                if self.isNewMember == true {
                                    if let parentVC = self.parent as? LoginSignUpViewController {
                                        revealVC = parentVC.revealViewController()
                                    }
                                } else {
                                    if self.revealViewController() != nil {
                                        print("hey I have a reveal view controller")
                                        revealVC = self.revealViewController()
                                    }
                                }
                        
                                //check if revealVC was set
                                guard revealVC != nil else {
                                    self.promptAlertWithDelay("Sorry", inmessage: "User has been changed but not modified in front", indelay: 5.0)
                                    self.statusSuccess = false
                                    return
                                }
                                
                                //save changed fields into the temporary user
                                if let navBar = revealVC?.rearViewController as? navBarController {
                                    navBar.setUser(member: self.user)
                                }
                                self.promptAlertWithDelay("User successfully updated", inmessage: "User has been updated", indelay: 5.0)
                                
                                //if is a newMember proceed to go to menu.
                                if self.isNewMember == true {
                                    //might need to instantiate from storyboard
                                    if let navController = self.navigationController {
                                        let nextVC = menuViewController()
                                        navController.pushViewController(nextVC, animated: true)
                                    }
                                }
                                self.statusSuccess = false
                            } else {
                                self.promptAlertWithDelay("Unable to submit request", inmessage: self.errorMsg, indelay: 5.0)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.promptAlertWithDelay("Connection Error", inmessage: "We apologize, we're having difficulty registering your data", indelay: 5.0)
                        }
                    }
                })
            }
        }
        
    }
    
    func validateAndSetInputs() -> Bool {
        
        /**** is this check necessary? ****/
        for case let textfield as UITextField in contentView.subviews {
            guard textfield.text != nil else {
                promptAlertWithDelay("Saving user failed", inmessage: "All inputs must be filled", indelay: 5.0)
                return false
            }
            guard textfield.text != "" else {
                promptAlertWithDelay("Saving user failed", inmessage: "All inputs must be filled", indelay: 5.0)
                return false
            }
        }
        
        saveParams.setName(name: newUserNameTxtFld.text!)
        saveParams.setNameCfrm(name: confirmUserNameTxtFld.text!)
        saveParams.setPass(pass: newPasswordTxtFld.text!)
        saveParams.setPassCfrm(pass: confirmPasswordTxtFld.text!)
        

        let mail = saveParams.getMail(getConfirmField: false)
        let mailCfrm = saveParams.getMail(getConfirmField: true)
        let mailRegEx = "^[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}$"
        if mail != mailCfrm {
            promptAlertWithDelay("Something went wrong!", inmessage: "Please check if passwords match", indelay: 5.0)
            return false
        }
        if !mail.validatePredicate(regex: mailRegEx){
            promptAlertWithDelay("Saving user failed", inmessage: "Please provide a valid email", indelay: 5.0)
            return false
        }
        
        return true
        
    }
    

    
    /*********************************** XMLParser Delegation ******************************/
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "response"{
            if let status = attributeDict["status"] {
                if status == "SUCCESSFUL" {
                    statusSuccess = true
                } else {
                    statusSuccess = false
                    if let msg = attributeDict["message"] {
                        errorMsg = msg
                    }
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure Error: \(parseError)")
    }
    
    

}
