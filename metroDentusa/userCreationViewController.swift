//
//  userCreationViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 4/3/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class userCreationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    /******* views *******/
    var scrollView = UIScrollView()
    var contentView = UIView()
    var usrNameTxtFld = UITextField()
    var confirmNameTxtFld = UITextField()
    var passwrdTxtFld = UITextField()
    var confirmPassTxtFld = UITextField()
    var emailAddTxtFld = UITextField()
    var confirmEmlTxtFld = UITextField()
    var securityQReel1 = UIPickerView()
    var answer1TxtFld = UITextField()
    var securityQReel2 = UIPickerView()
    var answer2TxtFld = UITextField()
    
    /******* data ********/
    private var randomPickerViewFiller = ["aga","duck","my Car!","Cinderella","James Watt","Smokin"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "User Creation"
        self.navigationController?.view.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        self.hideKeyBoardWhenTappedAround()
        edgesForExtendedLayout = []
        self.setUpScrollViewAndContentView(scrollView: self.scrollView, contentView: self.contentView)
        setUpTextFields()
        setUpSecurityQsFields()
        contentView.bottomAnchor.constraint(equalTo: answer1TxtFld.bottomAnchor, constant: 30).isActive = true
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    func setUpTextFields(){
        usrNameTxtFld.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(usrNameTxtFld)
        usrNameTxtFld.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        usrNameTxtFld.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        usrNameTxtFld.heightAnchor.constraint(equalToConstant: 30).isActive = true
        usrNameTxtFld.widthAnchor.constraint(equalToConstant: 200).isActive = true
        usrNameTxtFld.attributedPlaceholder = NSAttributedString(string: "New Username", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        confirmNameTxtFld.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(confirmNameTxtFld)
        confirmNameTxtFld.topAnchor.constraint(equalTo: usrNameTxtFld.bottomAnchor, constant: 8).isActive = true
        confirmNameTxtFld.leadingAnchor.constraint(equalTo: usrNameTxtFld.leadingAnchor).isActive = true
        confirmNameTxtFld.trailingAnchor.constraint(equalTo: usrNameTxtFld.trailingAnchor).isActive = true
        confirmNameTxtFld.heightAnchor.constraint(equalToConstant: 30).isActive = true
        confirmNameTxtFld.attributedPlaceholder = NSAttributedString(string: "Confirm Username", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        passwrdTxtFld.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwrdTxtFld)
        passwrdTxtFld.topAnchor.constraint(equalTo: confirmNameTxtFld.bottomAnchor, constant: 35).isActive = true
        passwrdTxtFld.leadingAnchor.constraint(equalTo: usrNameTxtFld.leadingAnchor).isActive = true
        passwrdTxtFld.trailingAnchor.constraint(equalTo: usrNameTxtFld.trailingAnchor).isActive = true
        passwrdTxtFld.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passwrdTxtFld.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        confirmPassTxtFld.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(confirmPassTxtFld)
        confirmPassTxtFld.topAnchor.constraint(equalTo: passwrdTxtFld.bottomAnchor, constant: 8).isActive = true
        confirmPassTxtFld.leadingAnchor.constraint(equalTo: passwrdTxtFld.leadingAnchor).isActive = true
        confirmPassTxtFld.trailingAnchor.constraint(equalTo: passwrdTxtFld.trailingAnchor).isActive = true
        confirmPassTxtFld.heightAnchor.constraint(equalToConstant: 30).isActive = true
        confirmPassTxtFld.attributedPlaceholder =  NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        emailAddTxtFld.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emailAddTxtFld)
        emailAddTxtFld.topAnchor.constraint(equalTo: confirmPassTxtFld.bottomAnchor, constant: 35).isActive = true
        emailAddTxtFld.leadingAnchor.constraint(equalTo: confirmPassTxtFld.leadingAnchor).isActive = true
        emailAddTxtFld.widthAnchor.constraint(equalToConstant: 250).isActive = true
        emailAddTxtFld.heightAnchor.constraint(equalToConstant: 30).isActive = true
        emailAddTxtFld.attributedPlaceholder = NSAttributedString(string: "Enter Email Address??", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        confirmEmlTxtFld.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(confirmEmlTxtFld)
        confirmEmlTxtFld.topAnchor.constraint(equalTo: emailAddTxtFld.bottomAnchor, constant: 8).isActive = true
        confirmEmlTxtFld.leadingAnchor.constraint(equalTo: emailAddTxtFld.leadingAnchor).isActive = true
        confirmEmlTxtFld.trailingAnchor.constraint(equalTo: emailAddTxtFld.trailingAnchor).isActive = true
        confirmEmlTxtFld.heightAnchor.constraint(equalToConstant: 30).isActive = true
        confirmEmlTxtFld.attributedPlaceholder = NSAttributedString(string: "Confirm Email Address??", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        for case let textField as UITextField in contentView.subviews {
            textField.borderStyle = UITextBorderStyle.roundedRect
            textField.clearButtonMode = .whileEditing
        }
    }
    
    func setUpSecurityQsFields(){
        let security1 = UILabel()
        security1.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(security1)
        security1.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        security1.widthAnchor.constraint(equalToConstant: 230).isActive = true
        security1.topAnchor.constraint(equalTo: confirmEmlTxtFld.bottomAnchor, constant: 35).isActive = true
        security1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        security1.text = "Choose Security Question 1"
        security1.textAlignment = .center
        
        securityQReel1.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(securityQReel1)
        securityQReel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        securityQReel1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        securityQReel1.topAnchor.constraint(equalTo: security1.bottomAnchor, constant: 5).isActive = true
        securityQReel1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        securityQReel1.delegate = self
        securityQReel1.dataSource = self
        
        let answerToQ1 = UILabel()
        answerToQ1.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(answerToQ1)
        answerToQ1.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        answerToQ1.topAnchor.constraint(equalTo: securityQReel1.bottomAnchor, constant: 20).isActive = true
        answerToQ1.widthAnchor.constraint(equalToConstant: 200).isActive = true
        answerToQ1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        answerToQ1.text = "Answer To Question 1"
        answerToQ1.textAlignment = .center
        
        answer1TxtFld.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(answer1TxtFld)
        answer1TxtFld.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        answer1TxtFld.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        answer1TxtFld.topAnchor.constraint(equalTo: answerToQ1.bottomAnchor, constant: 5).isActive = true
        answer1TxtFld.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        answer1TxtFld.borderStyle = UITextBorderStyle.roundedRect
        answer1TxtFld.clearButtonMode = .whileEditing
    }
    
    /************************************** pickerView functions *************************/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return randomPickerViewFiller.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return randomPickerViewFiller[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return
    }
}
