//
//  retrievePasswordViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/26/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation

class retrievePasswordView: UIView, XMLParserDelegate {
    
    /******* views **********/
    var topBarView = UIView()
    private var userNameTextField = UITextField()
    var retrieveQsBtn = UIButton()
    var closeBtn = UIButton()
    var secQLabelOne = UILabel()
    var secQLabelTwo = UILabel()
    private var answerTextFieldOne = UITextField()
    private var answerTextFieldTwo = UITextField()
    var submitBtn = UIButton()

    
    
    var question1Height : NSLayoutConstraint!
    var question2Height : NSLayoutConstraint!
    
    /******** XMLParser related variables ************/
    var parser = XMLParser()
    var statusSuccess: Bool = false
    var errorMsg = ""
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUpView()
    }
    
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
        
        let barTitle = UILabel()
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
    }
    
    func setUpInputFields(){
        let userNameLabel = UILabel()
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 25).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        userNameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        userNameLabel.text = "Username: "
        
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userNameTextField)
        userNameTextField.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 2).isActive = true
        userNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        userNameTextField.topAnchor.constraint(equalTo: userNameLabel.topAnchor).isActive = true
        
        retrieveQsBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(retrieveQsBtn)
        retrieveQsBtn.widthAnchor.constraint(equalToConstant: 300).isActive = true
        retrieveQsBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        retrieveQsBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        retrieveQsBtn.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 20).isActive = true
        retrieveQsBtn.setUpDefaultType(title: "Click to Retrieve Security Questions")
        
        
        secQLabelOne.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(secQLabelOne)
        secQLabelOne.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        secQLabelOne.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        secQLabelOne.topAnchor.constraint(equalTo: retrieveQsBtn.topAnchor).isActive = true
        question1Height = secQLabelOne.heightAnchor.constraint(equalToConstant: 20)
        question1Height.isActive = true
        secQLabelOne.text = "Temp Input"
        secQLabelOne.textAlignment = .center
        secQLabelOne.isHidden = true
        
        answerTextFieldOne.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(answerTextFieldOne)
        answerTextFieldOne.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        answerTextFieldOne.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        answerTextFieldOne.topAnchor.constraint(equalTo: secQLabelOne.bottomAnchor, constant: 8).isActive = true
        answerTextFieldOne.heightAnchor.constraint(equalToConstant: 30).isActive = true
        answerTextFieldOne.isHidden = true
        

        secQLabelTwo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(secQLabelTwo)
        secQLabelTwo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        secQLabelTwo.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        secQLabelTwo.topAnchor.constraint(equalTo: answerTextFieldOne.bottomAnchor, constant: 8).isActive = true
        question2Height = secQLabelTwo.heightAnchor.constraint(equalToConstant: 20)
        question2Height.isActive = true
        secQLabelTwo.text = "Temp Input"
        secQLabelTwo.textAlignment = .center
        secQLabelTwo.isHidden = true
        
        answerTextFieldTwo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(answerTextFieldTwo)
        answerTextFieldTwo.topAnchor.constraint(equalTo: secQLabelTwo.bottomAnchor, constant: 8).isActive = true
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
            question1Height = secQLabelOne.heightAnchor.constraint(equalToConstant: estHeight)
            secQLabelOne.text = titleText
            secQLabelOne.numberOfLines = Int(numLines)
            question1Height.isActive = true
        case 2:
            question2Height.isActive = false
            question2Height = secQLabelTwo.heightAnchor.constraint(equalToConstant: estHeight)
            secQLabelTwo.text = titleText
            secQLabelTwo.numberOfLines = Int(numLines)
            question2Height.isActive = true
        default:
            break
        }
    }
    
    /************************** UIButton Actions *********************/
    func getQuestions(completion: @escaping (_ result: String?) -> Void){
        if let name = userNameTextField.text {
            let activityIndicator = setUpActivityIndicator()
            DispatchQueue.global(qos: .background).async {
                AppDelegate().makeHTTPPostRequestToGetQuestions(urlString: "https://edi.asonet.com/httpserver.ashx?obj=retrieveUserSecurityQ", username: name, completion: {
                    (data: Data?) in
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
                            self.retrieveQsBtn.isHidden = true
                            self.secQLabelOne.isHidden = false
                            self.secQLabelTwo.isHidden = false
                            self.answerTextFieldTwo.isHidden = false
                            self.answerTextFieldOne.isHidden = false
                            self.submitBtn.isHidden = false
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
        guard let name = userNameTextField.text,
              let answerToQ1 = answerTextFieldOne.text,
              let answerToQ2 = answerTextFieldTwo.text
            else {
                completion("please make sure all input fields are filled")
                return
        }
        let activityIndicator = setUpActivityIndicator()
        DispatchQueue.global(qos: .background).async {
            AppDelegate().makeHTTPPostRequestToEmailPassword(urlString: "https://edi.asonet.com/httpserver.ashx?obj=submitUserSecurityQ", username: name, answer1: answerToQ1, answer2: answerToQ2, completion: { (data: Data?) in

                if data != nil {
                    if let dataString = String(data: data!, encoding: .utf8){
                        print("\(dataString)")
                    }
                    self.parser = XMLParser(data: data!)
                    self.parser.delegate = self
                    self.parser.parse()
                    DispatchQueue.main.async {
                        //print("\(self.statusSuccess)")
                        activityIndicator.stopAnimating()
                        guard self.errorMsg == "Password Emailed." else {
                            completion(self.errorMsg)
                            return
                        }
                        completion("success")
                        return
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        completion("Could not access data from www.asonet.com. We apologize for the inconvenience")
                    }
                }
            })
        }
        
    }

    
    
    func didDismissView(){
        retrieveQsBtn.isHidden = false
        secQLabelOne.isHidden = true
        secQLabelTwo.isHidden = true
        answerTextFieldTwo.isHidden = true
        answerTextFieldOne.isHidden = true
        submitBtn.isHidden = true
    }
    
    
    /********************** XMLParser Delegate ************************/
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "response" {
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




/*class retrievePasswordViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var formTableView : UITableView!
    var userNameLabel : UILabel!
    private var userNameTextField : userInputField!
    var securityQuestion1: UILabel?
    private var security1TextField : userInputField?
    var securityQuestion2: UILabel?
    private var security2TextField: userInputField?
    var initSecondaryView : Bool = false
    let getQuestionsButton = UIButton(frame: CGRect(x: 67, y: 310, width: 240, height: 44))
    let tempPasswordButton = UIButton(frame: CGRect(x: 55, y: 500, width: 265, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Retrieve Password"
        view.backgroundColor = UIColor.white
        self.hideKeyBoardWhenTappedAround()
        setUpTableView()
        setUpButtons()
    }
    
    
    func setUpTableView(){
        formTableView = UITableView(frame: CGRect(x: 37, y: 120, width: 300, height: 340))
        formTableView.dataSource = self
        formTableView.delegate = self
        formTableView.register(formTableViewCell.self, forCellReuseIdentifier: "formCell")
        formTableView.alwaysBounceVertical = false
        formTableView.separatorStyle = .none
        self.view.addSubview(formTableView)
    }
    
    func setUpButtons(){
        getQuestionsButton.addTarget(self, action: #selector(getQuestions), for: .touchUpInside)
        getQuestionsButton.setUpDefaultType(title: "Answer Security Questions")
        self.view.addSubview(getQuestionsButton)
    }
    
    func setUpSecondaryView(){
        getQuestionsButton.isHidden = true
        
        tempPasswordButton.addTarget(self, action: #selector(sendEmailTempPasswordRequest), for: .touchUpInside)
        tempPasswordButton.setUpDefaultType(title: "")
        tempPasswordButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        let nsTitle = NSMutableAttributedString(string: "send temp password to\nLarrySachs@gmail.com")
        tempPasswordButton.setAttributedTitle(nsTitle, for: .normal)
        self.view.addSubview(tempPasswordButton)
        
    }
    
    func getQuestions(){
        if (userNameTextField.text?.isEmpty)! {
            promptAlertWithDelay("Could not fetch questions", inmessage: "Username must not be empty", indelay: 5.0)
            return
        }
        initSecondaryView = true
        setUpSecondaryView()
        
        formTableView.reloadData()
    }
    
    func sendEmailTempPasswordRequest(){
        print("this does not do anything right now")
    }
    
    /************************************************ tableView functions ****************************************/
    func numberOfSections(in tableView: UITableView) -> Int {
        if initSecondaryView {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 45))
        headerView.backgroundColor = UIColor.clear
        if section == 0 {
            userNameLabel = UILabel(frame: CGRect(x: 4, y: 17, width: headerView.frame.size.width-4, height: 25))
            userNameLabel.text = "Username: "
            headerView.addSubview(userNameLabel)
        }
        if section == 1 {
            securityQuestion1 = UILabel(frame: CGRect(x: 4, y: 17, width: headerView.frame.size.width-4, height: 25))
            securityQuestion1?.text = "What was your first car model?"
            headerView.addSubview(securityQuestion1!)
        }
        if section == 2 {
           securityQuestion2 = UILabel(frame: CGRect(x: 4, y: 17, width: headerView.frame.size.width-4, height: 25))
            securityQuestion2?.text = "What is your mothers maiden name?"
            headerView.addSubview(securityQuestion2!)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "formCell", for: indexPath) as! formTableViewCell
        if indexPath.section == 0 {
            userNameTextField = cell.formTextField
        }
        if indexPath.section == 1 {
            security1TextField = cell.formTextField
        }
        if indexPath.section == 2 {
            security2TextField = cell.formTextField
        }
        return cell
    }
 
}*/
