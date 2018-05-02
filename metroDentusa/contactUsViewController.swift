//
//  contactUsViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 3/7/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation
import MessageUI


class contactUsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, userInputFieldDelegate, MFMailComposeViewControllerDelegate {
    var menuButton : UIBarButtonItem!
    var contactUsLabel = UILabel()
    //var byEmail: UILabel!
    var scrollView = UIScrollView()
    var contentView = UIView()
    var invisibleTopView = UIView()
    var messageBox = UITextView()
    var formTableView =  UITableView()
    var submitButton =  UIButton()
    var formInputs : [String] = ["","",""]
    var messagePlaceHolder = "Enter Message (Required)"
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.hideKeyBoardWhenTappedAround()
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.navigationItem.title = "By Email"
        self.view.backgroundColor = UIColor.white
        self.toggleMenuButton(menuButton: menuButton)
        self.navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
        self.navigationItem.rightBarButtonItem = menuButton
        
        self.setUpScrollViewAndContentView(scrollView: self.scrollView, contentView: self.contentView)
        setUpView()
        contentView.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 30).isActive = true
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    func setUpView(){
        invisibleTopView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(invisibleTopView)
        invisibleTopView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        invisibleTopView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        invisibleTopView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        invisibleTopView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        invisibleTopView.backgroundColor = UIColor.clear
        contentView.sendSubview(toBack: invisibleTopView)
        
        
        contactUsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contactUsLabel)
        contactUsLabel.topAnchor.constraint(equalTo: invisibleTopView.bottomAnchor).isActive = true
        contactUsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        contactUsLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        contactUsLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        contactUsLabel.text = "Contact Us"
        contactUsLabel.textColor = LoginSignUpViewController.themeColor
        contactUsLabel.textAlignment = .center
        contactUsLabel.font = UIFont.systemFont(ofSize: 19)
        
        
        setUpTables()
    }
    
    
    func setUpTables(){
        //formTableView = UITableView(frame: CGRect(x: self.view.center.x - 140, y: byEmail.frame.maxY + 25, width: 280, height: 120))
        formTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(formTableView)
        formTableView.topAnchor.constraint(equalTo: contactUsLabel.bottomAnchor, constant: 25).isActive = true
        formTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        formTableView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75).isActive = true
        formTableView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        formTableView.delegate = self
        formTableView.dataSource = self
        formTableView.register(formTableViewCell.self, forCellReuseIdentifier: "formCells")
        formTableView.alwaysBounceVertical = false
        
        setUpMessageView()
        setUpButton()
        
    }
    
    func setUpMessageView(){
        //messageBox = UITextView(frame: CGRect(x: formTableView.frame.minX, y: formTableView.frame.maxY+1, width: formTableView.frame.width, height: 100))
        messageBox.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(messageBox)
        messageBox.topAnchor.constraint(equalTo: formTableView.bottomAnchor, constant: 1).isActive = true
        messageBox.leadingAnchor.constraint(equalTo: formTableView.leadingAnchor).isActive = true
        messageBox.trailingAnchor.constraint(equalTo: formTableView.trailingAnchor).isActive = true
        messageBox.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.17).isActive = true
        messageBox.backgroundColor = LoginSignUpViewController.defaultGray
        messageBox.layer.cornerRadius = 5
        messageBox.layer.borderWidth = 1
        messageBox.layer.borderColor = UIColor.lightGray.cgColor
        messageBox.font = .systemFont(ofSize: 17)
        messageBox.text = messagePlaceHolder
        messageBox.textColor = UIColor.lightGray
        messageBox.delegate = self
    }
    
    func setUpButton(){
        //submitButton = UIButton(frame: CGRect(x: self.view.center.x - 50, y: messageBox.frame.maxY + 30, width: 100, height: 40))
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(submitButton)
        submitButton.topAnchor.constraint(equalTo: messageBox.bottomAnchor, constant: 30).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.27).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        submitButton.setUpDefaultType(title: "Submit")
        submitButton.addTarget(self, action: #selector(submitMessage), for: .touchUpInside)
    }
    
    /********************************** tableView functions *********************************/
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == formTableView {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == formTableView {
            return 1
        }
        return 0
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
        if tableView == formTableView {
            return 45
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "formCells", for: indexPath) as! formTableViewCell
        cell.layoutIfNeeded()
        cell.setUpFormTextField()
        cell.formTextField.userInputdelegate = self
        if indexPath.section == 0 {
            cell.formTextField.placeholder = "First and Last Name"
            cell.formTextField.setVal(val: 0)
        }
        if indexPath.section == 1 {
            cell.formTextField.placeholder = "Subject (Optional)"
            cell.formTextField.setVal(val: 1)
        }
        if indexPath.section == 2 {
            cell.formTextField.placeholder = "Phone Number (Optional)"
            cell.formTextField.setVal(val: 2)
        }
        return cell
    }
    
    
    /***************************************** textField and textView functions *****************************/
    func userInputFieldDidChange(userInputField: userInputField) {
        if let inputTypeInt = userInputField.getVal(){
            switch inputTypeInt {
            case 0:
                formInputs[0] = userInputField.text!
            case 1:
                formInputs[1] = userInputField.text!
            case 2:
                formInputs[2] = userInputField.text!
            default:
                break
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = messagePlaceHolder
            textView.textColor = UIColor.lightGray
        }
    }
    
    /******************************************* UIButton Actions **************************************/
    
    func submitMessage(){
        if messageBox.textColor == UIColor.black && !messageBox.text.isEmpty {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            composeVC.setCcRecipients(["ttmemail@ttmail.com"])
            composeVC.setSubject("\(formInputs[1])")
            var messageBody = "\((messageBox.text)!)\n\n\(formInputs[0])"
            if formInputs[2] != "" {
                let numberRegex = "^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}$"
                if formInputs[2].validatePredicate(regex: numberRegex) {
                    messageBody += "\nPhone number: \(formInputs[2])"
                }
            }
            composeVC.setMessageBody(messageBody, isHTML: false)
            
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
            } else {
                self.present(composeVC, animated: true, completion: nil)
            }
        } else {
            promptAlertWithDelay("no message given", inmessage: "Please let us know a few more details about your concerns", indelay: 5.0)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if error != nil {
            self.promptAlertWithDelay("Uh oh! Something went wrong", inmessage: "We were unable to send your mail", indelay: 5.0)
            return
        }
        if result == MFMailComposeResult.failed {
            self.promptAlertWithDelay("Uh oh! Something went wrong", inmessage: "We were unable to send your mail", indelay: 5.0)
        } else if result == MFMailComposeResult.sent {
            self.promptAlertWithDelay("Success!", inmessage: "Message has been sent. We will have someone address your concerns at our earliest convenience", indelay: 5.0)
        }

    }
    
    func loadFAQs(){
        self.performSegue(withIdentifier: "tempSegue", sender: self)
    }
    
    
    
    
    
    
}
