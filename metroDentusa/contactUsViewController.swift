//
//  contactUsViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 3/7/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation
import MessageUI

class numberTableViewCell: UITableViewCell {
    private var numberLabel = UILabel(frame: CGRect(x: 60, y: 14, width: 120, height: 20))
    private var cellImage = UIImageView(frame: CGRect(x: 8, y: 9, width: 30, height: 30))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellImage.image = UIImage(named: "Phone Icon")
        cellImage.contentMode = .scaleAspectFit
        self.contentView.addSubview(cellImage)
        self.contentView.addSubview(numberLabel)
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setNumber(number: String){
        numberLabel.text = number
    }
    
    func getNumber() -> String?{
        return numberLabel.text
    }
}

class contactUsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, userInputFieldDelegate, MFMailComposeViewControllerDelegate {
    var menuButton : UIBarButtonItem!
    var byEmail: UILabel!
    var byPhone: UILabel!
    var messageBox: UITextView!
    var formTableView: UITableView!
    var numbersTableView: UITableView!
    var submitButton: UIButton!
    var formInputs : [String] = ["",""]
    var numbers = ["844-628-3368"]
    var messagePlaceHolder = "Enter Message (Required)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardWhenTappedAround()
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.navigationItem.title = "Contact US"
        self.toggleMenuButton(menuButton: menuButton)
        setUpView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpView(){
        byEmail = UILabel(frame: CGRect(x: self.view.center.x - 50, y: 80, width: 100, height: 20))
        byEmail.text = "By Email"
        self.view.addSubview(byEmail)
        
        setUpTables()
        
        byPhone = UILabel(frame: CGRect(x: self.view.center.x - 50, y: numbersTableView.frame.minY - 50, width: 100, height: 20))
        byPhone.text = "By Phone"
        self.view.addSubview(byPhone)
        
        for case let label as UILabel in self.view.subviews {
            label.textColor = LoginSignUpViewController.themeColor
            label.textAlignment = .center
            label.font = byEmail.font.withSize(19)
        }
        
    }
    
    func setUpTables(){
        formTableView = UITableView(frame: CGRect(x: self.view.center.x - 140, y: byEmail.frame.maxY + 25, width: 280, height: 120))
        formTableView.delegate = self
        formTableView.dataSource = self
        formTableView.register(formTableViewCell.self, forCellReuseIdentifier: "formCells")
        formTableView.alwaysBounceVertical = false
        
        setUpMessageView()
        setUpButton()
        
        numbersTableView = UITableView(frame: CGRect(x: self.view.center.x - 140, y: submitButton.frame.maxY + 80, width: 280, height: 144))
        numbersTableView.delegate = self
        numbersTableView.dataSource = self
        numbersTableView.register(numberTableViewCell.self, forCellReuseIdentifier: "phoneCell")
        numbersTableView.alwaysBounceVertical = false
        
        
        self.view.addSubview(formTableView)
        self.view.addSubview(numbersTableView)
    }
    
    func setUpMessageView(){
        messageBox = UITextView(frame: CGRect(x: formTableView.frame.minX, y: formTableView.frame.maxY+1, width: formTableView.frame.width, height: 100))
        messageBox.backgroundColor = UIColor(red: 229/255, green: 226/255, blue: 233/255, alpha: 1)
        messageBox.layer.cornerRadius = 5
        messageBox.layer.borderWidth = 1
        messageBox.layer.borderColor = UIColor.lightGray.cgColor
        messageBox.font = .systemFont(ofSize: 17)
        messageBox.text = messagePlaceHolder
        messageBox.textColor = UIColor.lightGray
        messageBox.delegate = self
        self.view.addSubview(messageBox)
    }
    
    func setUpButton(){
        submitButton = UIButton(frame: CGRect(x: self.view.center.x - 50, y: messageBox.frame.maxY + 30, width: 100, height: 40))
        submitButton.setUpDefaultType(title: "Submit")
        submitButton.addTarget(self, action: #selector(submitMessage), for: .touchUpInside)
        self.view.addSubview(submitButton)
    }
    
    /********************************** tableView functions *********************************/
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == formTableView {
            return 2
        } else if tableView == numbersTableView {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == formTableView {
            return 1
        } else if tableView == numbersTableView {
            return numbers.count
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
        } else if tableView == numbersTableView {
            return 48
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == formTableView {
            let ftvc = tableView.dequeueReusableCell(withIdentifier: "formCells", for: indexPath) as! formTableViewCell
            ftvc.formTextField?.userInputdelegate = self
            if indexPath.section == 0 {
                ftvc.formTextField?.placeholder = "First and Last Name"
                ftvc.formTextField?.setVal(val: 0)
            }
            if indexPath.section == 1 {
                ftvc.formTextField?.placeholder = "Subject (Optional)"
                ftvc.formTextField?.setVal(val: 1)
            }
            cell = ftvc
        } else if tableView == numbersTableView {
            let ntvc = tableView.dequeueReusableCell(withIdentifier: "phoneCell", for: indexPath) as! numberTableViewCell
            ntvc.setNumber(number: numbers[indexPath.row])
            cell = ntvc
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == numbersTableView {
            let number = numbers[indexPath.row]
            let callAlert = UIAlertController(title: "Call \(number)?", message: "", preferredStyle: UIAlertControllerStyle.alert)
            callAlert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action: UIAlertAction) in
                let phoneString = number.seperateNumbers()
                guard let numberUrl = URL(string: "tel://\(phoneString)") else { return }
                UIApplication.shared.open(numberUrl, options: [:], completionHandler: nil)
                self.promptAlertWithDelay("Calling \(number)", inmessage: "This won't work in the simulator, but should work in the device", indelay: 5.0)
            }))
            callAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
                callAlert.dismiss(animated: true, completion: nil)
            }))
            present(callAlert, animated: true, completion: nil)
        }
    }
    
    /***************************************** textField and textView functions *****************************/
    func userInputFieldDidChange(userInputField: userInputField) {
        if let inputTypeInt = userInputField.getVal(){
            switch inputTypeInt {
            case 0:
                formInputs[0] = userInputField.text!
            case 1:
                formInputs[1] = userInputField.text!
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
            composeVC.setMessageBody("\((messageBox.text)!)\n\n\(formInputs[0])", isHTML: false)
            
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
    
    
    
    
    
    
}
