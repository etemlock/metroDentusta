//
//  FAQsViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 3/12/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class FAQsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var menuButton: UIBarButtonItem!
    var titleViewTop: UIView!
    var FAQsTableView: UITableView!
    var titleViewBottom: UIView!
    var contactTableView: UITableView!
    var FAQs = ["Who can join MetroDent?",
                "What plan does it cost to join the Discount Fee For Service Dental Plan?",
                "Which providers accept these Discount Fees?",
                "What is the Cancellation and Refund Policy?",
                "Will my membership automatically renew?",
                "What is the MetrodentUSA refund policy?"]
    private static var rowHeightsArray : [CGFloat] = []
    private static var rowHeightsSum : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardWhenTappedAround()
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.navigationItem.title = "Help"
        if FAQsViewController.rowHeightsArray.count < 1{
            assignRowHeights()
        }
        self.automaticallyAdjustsScrollViewInsets = false
        setUpView()
        self.toggleMenuButton(menuButton: menuButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func assignRowHeights(){
        for question in FAQs {
            let estRect = question.estimateFrameForText(maxWidth: self.view.frame.width - 16, maxHeight: 90, font: 15)
            FAQsViewController.rowHeightsArray.append(estRect.height)
            FAQsViewController.rowHeightsSum = FAQsViewController.rowHeightsSum + (estRect.height + 20)
        }
    }
    
    func setUpView(){
        titleViewTop = UIView(frame: CGRect(x: 0, y: 65, width: self.view.frame.width, height: 30))
        
        /*  layout Constraints when refactoring Front End
        titleViewTop.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        titleViewTop.centerYAnchor.constraint(equalTo: self.navigationController?.navigationBar.bottomAnchor, constant: 15)
        titleViewTop.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        titleViewTop.heightAnchor.constraint(equalToConstant: 30)
        */
        
        titleViewTop.backgroundColor = LoginSignUpViewController.themeColor
        
        let FAQsTitle = UILabel(frame: CGRect(x: self.view.center.x - 125, y: 4, width: 250, height: 22))
        FAQsTitle.text = "Frequently Asked Questions"
        FAQsTitle.textColor = UIColor.white
        FAQsTitle.textAlignment = .center
        FAQsTitle.font = FAQsTitle.font.withSize(19)
        titleViewTop.addSubview(FAQsTitle)
        
        setUpTables()
        
        titleViewBottom = UIView(frame: CGRect(x: 0, y: FAQsTableView.frame.maxY + 1, width: self.view.frame.width, height: 30))
        titleViewBottom.backgroundColor = LoginSignUpViewController.themeColor
        
        let contactTitle = UILabel(frame: CGRect(x: self.view.center.x - 75, y: 4, width: 150, height: 22))
        contactTitle.text = "Contact Us"
        contactTitle.textColor = UIColor.white
        contactTitle.textAlignment = .center
        contactTitle.font = contactTitle.font.withSize(19)
        titleViewBottom.addSubview(contactTitle)
        
        self.view.addSubview(titleViewTop)
        self.view.addSubview(titleViewBottom)
    }
    
    func setUpTables(){
        FAQsTableView = UITableView(frame: CGRect(x: 0, y: titleViewTop.frame.maxY + 5, width: self.view.frame.width, height: FAQsViewController.rowHeightsSum))
       // FAQsTableView.separatorInset = UIEdgeInsets.zero
        FAQsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "faqCell")
        FAQsTableView.delegate = self
        FAQsTableView.dataSource = self
        FAQsTableView.alwaysBounceVertical = false
        
        contactTableView = UITableView(frame: CGRect(x: 0, y: FAQsTableView.frame.maxY + 35, width: self.view.frame.width, height: 90))
        contactTableView.register(genericTableViewCell.self, forCellReuseIdentifier: "contactMethodCell")
        contactTableView.dataSource = self
        contactTableView.delegate = self
        contactTableView.alwaysBounceVertical = false
        
        self.view.addSubview(FAQsTableView)
        self.view.addSubview(contactTableView)
    }
    
    /*************************************************** tableView delegate functions ************************************************/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == FAQsTableView {
            return FAQs.count
        } else if tableView == contactTableView {
            return 2
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        let rightCarrot = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        rightCarrot.text = ">"
        rightCarrot.textColor = UIColor.lightGray
        rightCarrot.textAlignment = .center
        
        
        if tableView == FAQsTableView {
            let faqtvc = tableView.dequeueReusableCell(withIdentifier: "faqCell", for: indexPath)
            let numLines = (FAQsViewController.rowHeightsArray[indexPath.row]/20) + 1
            let questionText = faqtvc.textLabel
            questionText?.frame = CGRect(x: 8, y: 10, width: cell.contentView.frame.width - 16, height: numLines*20)
            questionText?.numberOfLines = Int(numLines)
            questionText?.text = FAQs[indexPath.row]
            questionText?.font = questionText?.font.withSize(15)
            
            rightCarrot.frame.origin.x = (questionText?.frame.maxX)! + 30
            rightCarrot.frame.origin.y = cell.contentView.center.y - 10
            faqtvc.contentView.addSubview(rightCarrot)
            cell = faqtvc
            
        } else if tableView == contactTableView {
            let ctvc = tableView.dequeueReusableCell(withIdentifier: "contactMethodCell", for: indexPath) as! genericTableViewCell
            if indexPath.row == 0 {
                ctvc.setImage(image: UIImage(named: "Mail Icon")!)
                ctvc.setText(text: "Mail Us")
            } else {
                ctvc.setImage(image: UIImage(named: "Phone Icon")!)
                ctvc.setText(text: "Call Us")
            }
            
            rightCarrot.frame.origin.x = 342
            rightCarrot.frame.origin.y = 17
            ctvc.contentView.addSubview(rightCarrot)
            
            cell = ctvc
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == FAQsTableView {
            return FAQsViewController.rowHeightsArray[indexPath.row] + 20
        } else if tableView == contactTableView {
            return 45
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == FAQsTableView {
            let nextVC = FAQsAnswerViewController(question: FAQs[indexPath.row], questionNum: indexPath.row)
            self.setUpBackBarButton(title: "Back to Help")
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else if tableView == contactTableView {
            if indexPath.row == 0 {
                let nextVC = contactUsViewController()
                self.setUpBackBarButton(title: "Back to Help")
                self.navigationController?.pushViewController(nextVC, animated: true)
            } else {
                promptCallAlert()
            }
        }
    }
    
    /*********************************** UIButton function **************************/
    
    func promptCallAlert(){
        let number = "844-628-3368"
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
