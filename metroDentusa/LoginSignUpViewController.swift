//
//  LoginSignUpViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/14/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation

class LoginSignUpViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, userInputFieldDelegate {
    private var segmentIndexFlag = 0
    var loginInputs : [String] = ["",""]
    var createInputs : [String] = ["","",""]
    var menuButton : UIBarButtonItem!
    var formTableView : UITableView!
    let continueButton  = UIButton(frame: CGRect(x: 92, y: 395, width: 190, height: 44))
    let forgotPasswordBtn = UIButton(frame: CGRect(x: 25, y: 460, width: 320, height: 44))
    let segmentController : UISegmentedControl = UISegmentedControl(items: ["Login", "Create Username"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func continueClick(){
        print("ole ole ole ole!! We fight!")
    }
    
    func retrievePasswordClick(){
        print("not gonna retrive your password haha!")
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
                cell.formTextField?.setVal(val: 1)
            } else {
                cell.formTextField?.placeholder = "Members birthday MM/DD/YYYY"
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
    func userInputFieldDidEndEditing(userInputField: userInputField) {
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
    
}
