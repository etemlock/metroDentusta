//
//  retrievePasswordViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/26/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation

//call retrieveResetPasswordView
class retrievePasswordView: UIView, XMLParserDelegate {
    
    /******* views **********/
    var topBarView = UIView()
    private var topTextField = UITextField()
    var retrieveQsBtn = UIButton()
    var closeBtn = UIButton()
    var barTitle = UILabel()
    var topLabel = UILabel()
    var answerLabelOne = UILabel()
    var answerLabelTwo = UILabel()
    private var answerTextFieldOne = UITextField()
    private var answerTextFieldTwo = UITextField()
    var submitBtn = UIButton()
    var barViewBackBtn = UIButton()


    
    var topLabelWidth : NSLayoutConstraint!
    var question1Height : NSLayoutConstraint!
    var question2Height : NSLayoutConstraint!
    
    
    /********* data **************/
    //var resetModeOn : Bool = false
    var currViewMode = ""
    private var userName = ""
   
    
    /******** XMLParser related variables ************/
    var parser = XMLParser()
    var statusSuccess: Bool = false
    var errorMsg = ""
    
    
    func setUpView(){
        self.backgroundColor = UIColor.white
        setUpBarView()
        setUpInputFields()
        setUpSubmitButton()
    }
    
    func setUpBarView(){
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topBarView)
        topBarView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topBarView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topBarView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        topBarView.backgroundColor = LoginSignUpViewController.themeColor
        
        barTitle.translatesAutoresizingMaskIntoConstraints = false
        topBarView.addSubview(barTitle)
        barTitle.centerXAnchor.constraint(equalTo: topBarView.centerXAnchor).isActive = true
        barTitle.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor).isActive = true
        barTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        barTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        barTitle.text = "Retrieve Password"
        barTitle.textAlignment = .center
        barTitle.textColor = UIColor.white
        
        
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        topBarView.addSubview(closeBtn)
        closeBtn.trailingAnchor.constraint(equalTo: topBarView.trailingAnchor, constant: -8).isActive = true
        closeBtn.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor).isActive = true
        closeBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeBtn.setTitle("X", for: .normal)
        closeBtn.setTitleColor(UIColor.white, for: .normal)
        
        barViewBackBtn.translatesAutoresizingMaskIntoConstraints = false
        topBarView.addSubview(barViewBackBtn)
        barViewBackBtn.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor, constant: 8).isActive = true
        barViewBackBtn.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor).isActive = true
        barViewBackBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        barViewBackBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        barViewBackBtn.setTitle("< Back", for: .normal)
        barViewBackBtn.setTitleColor(UIColor.white, for: .normal)
        barViewBackBtn.isHidden = true
    }
    
    func setUpInputFields(){
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topLabel)
        topLabel.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 25).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        topLabelWidth = topLabel.widthAnchor.constraint(equalToConstant: 100)
        topLabelWidth.isActive = true
        topLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        topLabel.text = "Username: "
        
        topTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topTextField)
        topTextField.leadingAnchor.constraint(equalTo: topLabel.trailingAnchor, constant: 2).isActive = true
        topTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        topTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        topTextField.topAnchor.constraint(equalTo: topLabel.topAnchor).isActive = true
        
        retrieveQsBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(retrieveQsBtn)
        retrieveQsBtn.widthAnchor.constraint(equalToConstant: 300).isActive = true
        retrieveQsBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        retrieveQsBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        retrieveQsBtn.topAnchor.constraint(equalTo: topTextField.bottomAnchor, constant: 20).isActive = true
        retrieveQsBtn.setUpDefaultType(title: "Click to Retrieve Security Questions")
        
        
        answerLabelOne.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(answerLabelOne)
        answerLabelOne.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        answerLabelOne.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        answerLabelOne.topAnchor.constraint(equalTo: retrieveQsBtn.topAnchor).isActive = true
        question1Height = answerLabelOne.heightAnchor.constraint(equalToConstant: 20)
        question1Height.isActive = true
        answerLabelOne.text = "Question1 "
        answerLabelOne.textAlignment = .center
        answerLabelOne.isHidden = true
        
        answerTextFieldOne.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(answerTextFieldOne)
        answerTextFieldOne.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        answerTextFieldOne.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        answerTextFieldOne.topAnchor.constraint(equalTo: answerLabelOne.bottomAnchor, constant: 8).isActive = true
        answerTextFieldOne.heightAnchor.constraint(equalToConstant: 30).isActive = true
        answerTextFieldOne.isHidden = true
        

        answerLabelTwo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(answerLabelTwo)
        answerLabelTwo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        answerLabelTwo.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        answerLabelTwo.topAnchor.constraint(equalTo: answerTextFieldOne.bottomAnchor, constant: 8).isActive = true
        question2Height = answerLabelTwo.heightAnchor.constraint(equalToConstant: 20)
        question2Height.isActive = true
        answerLabelTwo.text = "Question 2"
        answerLabelTwo.textAlignment = .center
        answerLabelTwo.isHidden = true
        
        answerTextFieldTwo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(answerTextFieldTwo)
        answerTextFieldTwo.topAnchor.constraint(equalTo: answerLabelTwo.bottomAnchor, constant: 8).isActive = true
        answerTextFieldTwo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        answerTextFieldTwo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        answerTextFieldTwo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        answerTextFieldTwo.isHidden = true
        
        for case let textField as UITextField in self.subviews {
            textField.borderStyle = UITextBorderStyle.roundedRect
            //textField.layer.borderWidth = 1.0
            textField.clearButtonMode = .whileEditing
        }
        
    }
    
    func setUpSubmitButton(){
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(submitBtn)
        submitBtn.topAnchor.constraint(equalTo: answerTextFieldTwo.bottomAnchor, constant: 20).isActive = true
        submitBtn.widthAnchor.constraint(equalToConstant: 300).isActive = true
        submitBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        submitBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitBtn.setUpDefaultType(title: "Have Password Emailed to User")
        submitBtn.titleLabel?.lineBreakMode = .byWordWrapping
        submitBtn.isHidden = true
        
    }
    
    func setLabelTitleAndHeight(labelNum: Int, titleText: String){
        let estHeight = titleText.estimateFrameForText(maxWidth: self.frame.width * 0.8, maxHeight: 50, font: 15).height + 10
        let numLines = (estHeight/18) + 1
        switch labelNum {
        case 1:
            question1Height.isActive = false
            question1Height = answerLabelOne.heightAnchor.constraint(equalToConstant: estHeight)
            answerLabelOne.text = titleText
            answerLabelOne.numberOfLines = Int(numLines)
            question1Height.isActive = true
        case 2:
            question2Height.isActive = false
            question2Height = answerLabelTwo.heightAnchor.constraint(equalToConstant: estHeight)
            answerLabelTwo.text = titleText
            answerLabelTwo.numberOfLines = Int(numLines)
            question2Height.isActive = true
        default:
            break
        }
    }
    
    func activateFetchQMode(){
        currViewMode = retrieveMode.fetchQ.rawValue
        retrieveQsBtn.isHidden = false
        answerLabelOne.isHidden = true
        answerLabelTwo.isHidden = true
        answerTextFieldTwo.isHidden = true
        answerTextFieldOne.isHidden = true
        barViewBackBtn.isHidden = true
        submitBtn.isHidden = true
    }
    
    func activateFetchPMode(){
        currViewMode = retrieveMode.fetchP.rawValue
        retrieveQsBtn.isHidden = true
        answerLabelOne.isHidden = false
        answerLabelTwo.isHidden = false
        answerTextFieldTwo.isHidden = false
        answerTextFieldOne.isHidden = false
        barViewBackBtn.isHidden = false
        submitBtn.isHidden = false
        topLabelWidth.isActive = false
        topLabelWidth = topLabel.widthAnchor.constraint(equalToConstant: 100)
        topLabelWidth.isActive = true
        topLabel.text = "Username: "
        answerTextFieldOne.isSecureTextEntry = false
        answerTextFieldTwo.isSecureTextEntry = false
        submitBtn.setTitle("Have Password Emailed to User", for: .normal)
    }
    
    func activateResetPMode(){
        currViewMode = retrieveMode.resetP.rawValue
        print("\(currViewMode)")
        barTitle.text = "Change Password"
        topLabelWidth.isActive = false
        topLabelWidth = topLabel.widthAnchor.constraint(equalToConstant: 180)
        topLabelWidth.isActive = true
        topLabel.text = "Temporary Password: "
        answerLabelOne.text = "New Password"
        answerLabelTwo.text = "Confirm New Password"
        answerTextFieldOne.text?.removeAll()
        answerTextFieldTwo.text?.removeAll()
        answerTextFieldOne.isSecureTextEntry = true
        answerTextFieldTwo.isSecureTextEntry = true
        submitBtn.setTitle("Change Password", for: .normal)
    }
    
    /*func activateResetMode(){
        resetModeOn = true
        barTitle.text = "Change Password"
        topLabelWidth.isActive = false
        topLabelWidth = topLabel.widthAnchor.constraint(equalToConstant: 180)
        topLabelWidth.isActive = true
        topLabel.text = "Temporary Password: "
        answerLabelOne.text = "New Password"
        answerLabelTwo.text = "Confirm New Password"
        answerTextFieldOne.text?.removeAll()
        answerTextFieldTwo.text?.removeAll()
        answerTextFieldOne.isSecureTextEntry = true
        answerTextFieldTwo.isSecureTextEntry = true
        submitBtn.setTitle("Change Password", for: .normal)
    }
    
    func deactivateResetMode(){
        resetModeOn = false
        barTitle.text = "Retrieve Password"
        topLabelWidth.isActive = false
        topLabelWidth = topLabel.widthAnchor.constraint(equalToConstant: 100)
        topLabelWidth.isActive = true
        topLabel.text = "Username: "
        answerLabelOne.text = "Question1"
        answerLabelTwo.text = "Question2"
        answerTextFieldOne.isSecureTextEntry = false
        answerTextFieldTwo.isSecureTextEntry = false
        submitBtn.setTitle("Have Password Emailed to User", for: .normal)
    }*/
    
    /************************** UIButton Actions *********************/
    func getQuestions(completion: @escaping (_ result: String?) -> Void){
        if let name = topTextField.text {
            let activityIndicator = setUpActivityIndicator()
            DispatchQueue.global(qos: .background).async {
                AppDelegate().makeHTTPPostRequestToGetQuestions(urlString: "https://edi.asonet.com/httpserver.ashx?obj=retrieveUserSecurityQ", username: name, completion: {
                    (data: Data?, errorDesc: String?) in
                    if data != nil {
                        self.parser = XMLParser(data: data!)
                        self.parser.delegate = self
                        self.parser.parse()
                        
                        DispatchQueue.main.async {
                            activityIndicator.stopAnimating()
                            guard self.statusSuccess else {
                                completion(self.errorMsg)
                                return
                            }
                            self.activateFetchPMode()
                            self.userName = name
                            self.statusSuccess = false
                            
                            //completion(nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion("Cannot get any data with the username provided")
                        }
                    }
                })
            }
            
        } else {
            completion("Please Input Username")
        }
    }
    
    func submitQuestions(completion: @escaping (_ result: String?) -> Void){
 
        
       /* guard name != nil && answerToQ1 != nil &&
              answerToQ2 != nil && name != "" &&
               answerToQ2 != "" && answerToQ2 != ""*/
        guard let name = topTextField.text,
              let answerToQ1 = answerTextFieldOne.text,
              let answerToQ2 = answerTextFieldTwo.text
        else {
            completion("please make sure all input fields are filled")
            return
        }
        
        guard name != "" && answerToQ1 != "" && answerToQ2 != ""
            else {
                completion("please make sure all input fields are filled")
                return
        }
        

        let activityIndicator = setUpActivityIndicator()
        DispatchQueue.global(qos: .background).async {
            AppDelegate().makeHTTPPostRequestToEmailPassword(urlString: "https://edi.asonet.com/httpserver.ashx?obj=submitUserSecurityQ", username: name, answer1: answerToQ1, answer2: answerToQ2, completion: { (data: Data?, errorDesc: String?) in

                guard errorDesc == nil else {
                    DispatchQueue.main.async {
                        completion(errorDesc!)
                    }
                    return
                }
                if data != nil {
                    if let dataString = String(data: data!, encoding: .utf8){
                        print("\(dataString)")
                    }
                    self.parser = XMLParser(data: data!)
                    self.parser.delegate = self
                    self.parser.parse()
                    DispatchQueue.main.async {
                        activityIndicator.stopAnimating()
                        guard self.statusSuccess else {
                            completion(self.errorMsg)
                            return
                        }
                        
                        self.statusSuccess = false
                        self.activateResetPMode()
                        
                        completion("success")
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        completion("Could not access data from www.asonet.com. We apologize for the inconvenience")
                    }
                }
            })
            
        }
        
    }
    
    func changePassword(completion: @escaping (_ result: String?)->Void){
        guard let tempPass = topTextField.text,
              let newPass = answerTextFieldOne.text,
              let newPassCfrm = answerTextFieldTwo.text
            else {
                completion("Please make sure all input fields are filled")
                return
        }
        
        guard tempPass != "" && newPass != "" && newPassCfrm != "" else {
            completion("Please make sure all input fields are filled")
            return
        }
        
        let activityIndicator = setUpActivityIndicator()
        DispatchQueue.global(qos: .background).async {
            AppDelegate().makeHTTPPostRequestToChangePassword(urlString: "https://edi.asonet.com/httpserver.ashx?obj=UserUpdateFromTemp", userName: self.userName, tempPass: tempPass, newPassword: newPass, confirmPassword: newPassCfrm, completion: { (data: Data?, errorDesc: String?) in
                if data != nil {
                    if let dataString = String(data: data!, encoding: .utf8){
                        print("\(dataString)")
                    }
                    self.parser = XMLParser(data: data!)
                    self.parser.parse()
                    
                    DispatchQueue.main.async {
                        print("\(self.statusSuccess)")
                        activityIndicator.stopAnimating()
                        guard self.statusSuccess else {
                            completion(self.errorMsg)
                            return
                        }
                        completion("successfully changed password")
                        self.statusSuccess = false
                    }
                } else {
                    DispatchQueue.main.async {
                        completion("Could not access data from www.asonet.com. We apologize for the inconvenience")
                    }
                }
                
            })
        }
        
    }

    
    
    
    
    /********************** XMLParser Delegate ************************/
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "response" {
            if let status = attributeDict["status"]{
                if status.contains("SUCCESSFUL") {
                    print("status successful parsed")
                    statusSuccess = true
                }
            }
            if let msg = attributeDict["message"]{
                errorMsg = msg
            }
            if let question1 = attributeDict["securityquestion1"]{
                statusSuccess = true
                setLabelTitleAndHeight(labelNum: 1, titleText: question1)
            }
            if let question2 = attributeDict["securityquestion2"]{
                setLabelTitleAndHeight(labelNum: 2, titleText: question2)
            }
            if let email = attributeDict["emailaddress"]{
                submitBtn.setTitle("Have Password Emailed to \(email)", for: .normal)
            }
        }
    }
    
    
}

public enum retrieveMode : String {
    case fetchQ = "fetchQuestions"
    case fetchP = "fetchPassword"
    case resetP = "resetPassword"
}


