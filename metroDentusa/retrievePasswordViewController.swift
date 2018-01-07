//
//  retrievePasswordViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/26/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation

class retrievePasswordViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    
    

}
