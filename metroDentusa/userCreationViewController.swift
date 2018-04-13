//
//  userCreationViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 4/3/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class userCreationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, userInputFieldDelegate, XMLParserDelegate {
    /******* views *******/
    var scrollView = UIScrollView()
    var contentView = UIView()
    var formTableView = UITableView()
    var securityQTableView = UITableView()
    var saveUserButton = UIButton()
    
    /********* data **********/
    var formCellId = "formCell"
    private var saveParams = SaveUserParams()
    var user : member!
    
    /*************** XMLParser related variables ************/
    var parser = XMLParser()
    var statusSuccess : Bool = false
    var errorMsg = ""
    
    
    
    
    init(user: member){
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "User Creation"
        self.navigationController?.view.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        self.hideKeyBoardWhenTappedAround()
        edgesForExtendedLayout = []
        self.setUpScrollViewAndContentView(scrollView: self.scrollView, contentView: self.contentView)
        setUpTableView()
        //setUpTextFields()
        //setUpSecurityQsFields()
        setUpButton()
        contentView.bottomAnchor.constraint(equalTo: saveUserButton.bottomAnchor, constant: 30).isActive = true
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    func setUpTableView(){
        formTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(formTableView)
        formTableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        formTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        formTableView.heightAnchor.constraint(equalToConstant: 354).isActive = true
        formTableView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        formTableView.backgroundColor = LoginSignUpViewController.themeColor
        formTableView.delegate = self
        formTableView.dataSource = self
        formTableView.register(formTableViewCell.self, forCellReuseIdentifier: formCellId)
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white
        formTableView.tableFooterView = whiteView
        formTableView.alwaysBounceVertical = false
        
        securityQTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(securityQTableView)
        securityQTableView.topAnchor.constraint(equalTo: formTableView.bottomAnchor, constant: 20).isActive = true
        securityQTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        securityQTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        securityQTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        securityQTableView.backgroundColor = LoginSignUpViewController.themeColor
        securityQTableView.delegate = self
        securityQTableView.dataSource = self
        securityQTableView.register(formTableViewCell.self, forCellReuseIdentifier: formCellId)
        securityQTableView.alwaysBounceVertical = false
        
    }
    
    
    func setUpButton(){
        saveUserButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(saveUserButton)
        saveUserButton.topAnchor.constraint(equalTo: securityQTableView.bottomAnchor, constant: 40).isActive = true
        saveUserButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        saveUserButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        saveUserButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        saveUserButton.setUpDefaultType(title: "Save User")
        saveUserButton.addTarget(self, action: #selector(saveWasClicked), for: .touchUpInside)
        
    }
    
    
    /****************************************** UITableView Delegate *********************************/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == formTableView {
            return 6
        } else if tableView == securityQTableView {
            return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        /*if tableView == formTableView {
            if (section != 2 && section != 4) {
                return 15
            }
        }*/
        if tableView == formTableView {
            return 22
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 250).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        if tableView == formTableView {
            headerView.frame.size.height = 24
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
            switch section {
            case 0:
                label.text = "New Username"
            case 1:
                label.text = "Confirm Username"
            case 2:
                label.text = "New Password"
            case 3:
                label.text = "Confirm Password"
            case 4:
                label.text = "Enter Email Address"
            case 5:
                label.text = "Confirm Email Address"
            default:
                break
            }
        } else if tableView == securityQTableView {
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20).isActive = true
            switch section {
            case 0:
                label.text = "Enter Security Question 1"
            case 1:
                label.text = "Answer to Question 1"
            case 2:
                label.text = "Enter Security Question 2"
            case 3:
                label.text = "Answer to Question 2"
            default:
                break
            }
        }
        
       
        label.textColor = UIColor.white
        label.textAlignment = .center
    

        //let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        /*if tableView == formTableView {
            if section == 2 || section == 4 {
                headerView.frame.size.height = 40
            }
        } else if tableView == securityQTableView {
            headerView.frame.size.height = 40
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(label)
            label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: 250).isActive = true
            label.heightAnchor.constraint(equalToConstant: 20).isActive = true
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20).isActive = true
            label.textColor = UIColor.white
            label.textAlignment = .center
            switch section {
            case 0:
                label.text = "Enter Security Question 1"
            case 1:
                label.text = "Answer to Question 1"
            case 2:
                label.text = "Enter Security Question 2"
            case 3:
                label.text = "Answer to Question 2"
            default:
                break
            }
        }*/
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: formCellId, for: indexPath) as! formTableViewCell
        cell.contentView.layoutIfNeeded()
        cell.setUpFormTextField()
        cell.formTextField.userInputdelegate = self
        
        
        if tableView == formTableView {
            if indexPath.section == 0 {
                //cell.formTextField.placeholder = "New Username"
                cell.formTextField.setVal(val: 0)
            }
            if indexPath.section == 1 {
                //cell.formTextField.placeholder = "Confirm Username"
                cell.formTextField.setVal(val: 1)
            }
            if indexPath.section == 2 {
                //cell.formTextField.placeholder = "New Password"
                cell.formTextField.setVal(val: 2)
            }
            if indexPath.section == 3 {
                //cell.formTextField.placeholder = "Confirm Password"
                cell.formTextField.setVal(val: 3)
            }
            if indexPath.section == 4 {
                //cell.formTextField.placeholder = "Enter Email Address"
                cell.formTextField.setVal(val: 4)
            }
            if indexPath.section == 5 {
                //cell.formTextField.placeholder = "Confirm Email Address"
                cell.formTextField.setVal(val: 5)
            }
        } else if tableView == securityQTableView {
            if indexPath.section == 0 {
                cell.formTextField.setVal(val: 6)
            }
            if indexPath.section == 1 {
                cell.formTextField.setVal(val: 7)
            }
            if indexPath.section == 2 {
                cell.formTextField.setVal(val: 8)
            }
            if indexPath.section == 3{
                cell.formTextField.setVal(val: 9)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    /************************************************* textField delegate functions **********************************************/
    
    func userInputFieldDidChange(userInputField: userInputField) {
        if let inputTypeInt = userInputField.getVal() {
            switch inputTypeInt {
            case 0:
                saveParams.setName(name: userInputField.text!)
            case 1:
                saveParams.setNameCfrm(name: userInputField.text!)
            case 2:
                saveParams.setPass(pass: userInputField.text!)
            case 3:
                saveParams.setPassCfrm(pass: userInputField.text!)
            case 4:
                saveParams.setMail(newMail: userInputField.text!)
            case 5:
                saveParams.setMailCfrm(newMail: userInputField.text!)
            case 6:
                saveParams.setSecurityQuestion1(question: userInputField.text!)
            case 7:
                saveParams.setAnswer1(answer: userInputField.text!)
            case 8:
                saveParams.setSecurityQuestion2(question: userInputField.text!)
            case 9:
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
                AppDelegate().makeHTTPPostRequestToSaveUser(urlString: "https://edi.asonet.com/httpserver.ashx?obj=saveUserProfile", params: self.saveParams, completion: { (data: Data?) in
                    if data != nil {
                        if let dataString = String(data: data!, encoding: .utf8){
                            print("\(dataString)")
                        }
                        self.parser = XMLParser(data: data!)
                        self.parser.delegate = self
                        self.parser.parse()
                        DispatchQueue.main.async {
                            if self.statusSuccess {
                                if let parentVC = self.parent as? LoginSignUpViewController {
                                    if parentVC.revealViewController() != nil {
                                        let navBar = parentVC.revealViewController().rearViewController as? navBarController
                                        navBar?.setUser(member: self.user)
                                    }
                                } else {
                                    self.promptAlertWithDelay("Error creating user account", inmessage: self.errorMsg, indelay: 5.0)
                                }
                            }
                            self.statusSuccess = false
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
        for case let textField as UITextField in contentView.subviews {
            if textField.text == "" {
                promptAlertWithDelay("Saving user failed", inmessage: "All inputs must be filled", indelay: 5.0)
                return false
            }
        }
        
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

