//
//  FAQsViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 3/12/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class FAQsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    /********* views and related dats *********/
    var menuButton: UIBarButtonItem!
    var titleViewTop = UIView()
    var scrollView = UIScrollView()
    var contentView = UIView()
    var FAQsTableView = UITableView()
    var FAQsTableHeight : NSLayoutConstraint!
    var titleViewBottom = UIView()
    var contactTableView = UITableView()
    
    /********* data ***********/
    var FAQs = ["Who can join MetroDent?",
                "What plan does it cost to join the Discount Fee For Service Dental Plan?",
                "Which providers accept these Discount Fees?",
                "What is the Cancellation and Refund Policy?",
                "Will my membership automatically renew?",
                "What is the MetrodentUSA refund policy?"]
    private static var rowHeightsArray : [CGFloat] = []
    private static var rowHeightsSum : CGFloat = 0
    var faqCellId = "faqCell"
    var conCellId = "contactCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardWhenTappedAround()
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.toggleMenuButton(menuButton: menuButton)
        self.navigationItem.title = "Help"
        self.navigationController?.view.backgroundColor = UIColor.white
        
        if FAQsViewController.rowHeightsArray.count < 1{
            assignRowHeights()
        }
        edgesForExtendedLayout = []
        self.setUpScrollViewAndContentView(scrollView: self.scrollView, contentView: self.contentView)
        setUpView()
        
        contentView.bottomAnchor.constraint(equalTo: contactTableView.bottomAnchor, constant: 30).isActive = true
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            (context) -> Void in
            FAQsViewController.rowHeightsArray.removeAll()
            FAQsViewController.rowHeightsSum = 0
            self.assignRowHeights()
            self.FAQsTableHeight.isActive = false
            self.FAQsTableHeight = self.FAQsTableView.heightAnchor.constraint(equalToConstant: FAQsViewController.rowHeightsSum)
            self.FAQsTableHeight.isActive = true
            self.FAQsTableView.reloadData()
        })
    }
    
    func assignRowHeights(){
        for question in FAQs {
            let estRect = question.estimateFrameForText(maxWidth: self.view.frame.width - 36, maxHeight: 90, font: 15)
            FAQsViewController.rowHeightsArray.append(estRect.height)
            FAQsViewController.rowHeightsSum = FAQsViewController.rowHeightsSum + (estRect.height + 20)
        }
    }
    
    func setUpView(){
        setUpTopView()
        setUpTables()
    }
    
    func setUpTables(){
        FAQsTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(FAQsTableView)
        FAQsTableView.topAnchor.constraint(equalTo: titleViewTop.bottomAnchor, constant: 1).isActive = true
        FAQsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        FAQsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        FAQsTableHeight = FAQsTableView.heightAnchor.constraint(equalToConstant: FAQsViewController.rowHeightsSum)
        FAQsTableHeight.isActive = true
        // FAQsTableView.separatorInset = UIEdgeInsets.zero
        FAQsTableView.register(FAQsTableViewCell.self, forCellReuseIdentifier: faqCellId)
        FAQsTableView.delegate = self
        FAQsTableView.dataSource = self
        FAQsTableView.alwaysBounceVertical = false
        
        
        setUpBottomView()
        
        
        contactTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contactTableView)
        contactTableView.topAnchor.constraint(equalTo: titleViewBottom.bottomAnchor, constant: 1).isActive = true
        contactTableView.leadingAnchor.constraint(equalTo: FAQsTableView.leadingAnchor).isActive = true
        contactTableView.trailingAnchor.constraint(equalTo: FAQsTableView.trailingAnchor).isActive = true
        contactTableView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        contactTableView.register(FAQsTableViewCell.self, forCellReuseIdentifier: conCellId)
        contactTableView.dataSource = self
        contactTableView.delegate = self
        contactTableView.alwaysBounceVertical = false
        
    }
    
    func setUpTopView(){
        titleViewTop.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleViewTop)
        titleViewTop.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleViewTop.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleViewTop.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleViewTop.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleViewTop.layoutIfNeeded()
        titleViewTop.backgroundColor = LoginSignUpViewController.themeColor
        
        let FAQsTitle = UILabel()
        FAQsTitle.translatesAutoresizingMaskIntoConstraints = false
        titleViewTop.addSubview(FAQsTitle)
        FAQsTitle.centerXAnchor.constraint(equalTo: titleViewTop.centerXAnchor).isActive = true
        FAQsTitle.centerYAnchor.constraint(equalTo: titleViewTop.centerYAnchor).isActive = true
        FAQsTitle.widthAnchor.constraint(equalToConstant: 250).isActive = true
        FAQsTitle.heightAnchor.constraint(equalToConstant: 22).isActive = true
        FAQsTitle.text = "Frequently Asked Questions"
        FAQsTitle.textColor = UIColor.white
        FAQsTitle.textAlignment = .center
        FAQsTitle.font = FAQsTitle.font.withSize(19)
    }
    
    func setUpBottomView(){
        //titleViewBottom = UIView(frame: CGRect(x: 0, y: FAQsTableView.frame.maxY + 1, width: self.view.frame.width, height: 30))
        
        titleViewBottom.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleViewBottom)
        titleViewBottom.topAnchor.constraint(equalTo: FAQsTableView.bottomAnchor, constant: 1).isActive = true
        titleViewBottom.leadingAnchor.constraint(equalTo: titleViewTop.leadingAnchor).isActive = true
        titleViewBottom.trailingAnchor.constraint(equalTo: titleViewTop.trailingAnchor).isActive = true
        titleViewBottom.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleViewBottom.backgroundColor = LoginSignUpViewController.themeColor
        
        //let contactTitle = UILabel(frame: CGRect(x: self.view.center.x - 75, y: 4, width: 150, height: 22))
        let contactTitle = UILabel()
        contactTitle.translatesAutoresizingMaskIntoConstraints = false
        titleViewBottom.addSubview(contactTitle)
        contactTitle.centerXAnchor.constraint(equalTo: titleViewBottom.centerXAnchor).isActive = true
        contactTitle.centerYAnchor.constraint(equalTo: titleViewBottom.centerYAnchor).isActive = true
        contactTitle.widthAnchor.constraint(equalToConstant: 150).isActive = true
        contactTitle.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        contactTitle.text = "Contact Us"
        contactTitle.textColor = UIColor.white
        contactTitle.textAlignment = .center
        contactTitle.font = contactTitle.font.withSize(19)
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
        var cell = FAQsTableViewCell()

        
        
        if tableView == FAQsTableView {
            let faqtvc = tableView.dequeueReusableCell(withIdentifier: faqCellId, for: indexPath) as! FAQsTableViewCell
            let questionText = faqtvc.cellLabel
            let numLines = (FAQsViewController.rowHeightsArray[indexPath.row]/20) + 1
            questionText.translatesAutoresizingMaskIntoConstraints = false
            questionText.leadingAnchor.constraint(equalTo: faqtvc.leadingAnchor, constant: 8).isActive = true
            questionText.trailingAnchor.constraint(equalTo: faqtvc.trailingAnchor, constant: -28).isActive = true
            questionText.centerYAnchor.constraint(equalTo: faqtvc.centerYAnchor).isActive = true
            questionText.heightAnchor.constraint(equalToConstant: numLines*20).isActive = true
            
            questionText.numberOfLines = Int(numLines)
            questionText.text = FAQs[indexPath.row]
            questionText.font = questionText.font.withSize(15)
            
            cell = faqtvc
            
        } else if tableView == contactTableView {
            let ctvc = tableView.dequeueReusableCell(withIdentifier: conCellId, for: indexPath) as! FAQsTableViewCell

            let cellImage = ctvc.cellImage
            cellImage.translatesAutoresizingMaskIntoConstraints = false
            cellImage.leadingAnchor.constraint(equalTo: ctvc.leadingAnchor, constant: 8).isActive = true
            cellImage.centerYAnchor.constraint(equalTo: ctvc.centerYAnchor).isActive = true
            cellImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
            cellImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            let cellLabel = ctvc.cellLabel
            cellLabel.translatesAutoresizingMaskIntoConstraints = false
            cellLabel.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 22).isActive = true
            cellLabel.centerYAnchor.constraint(equalTo: ctvc.centerYAnchor).isActive = true
            cellLabel.trailingAnchor.constraint(equalTo: ctvc.trailingAnchor, constant: -28).isActive = true
            cellLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            if indexPath.row == 0 {
                ctvc.setImage(image: UIImage(named: "Mail Icon")!)
                ctvc.setText(text: "Mail Us")
            } else {
                ctvc.setImage(image: UIImage(named: "Phone Icon")!)
                ctvc.setText(text: "Call Us")
            }
            
            cell = ctvc
        }
        
        let rightCarrot = cell.rightCarrot
        
        rightCarrot.text = ">"
        rightCarrot.textColor = UIColor.lightGray
        rightCarrot.textAlignment = .center
        rightCarrot.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(rightCarrot)
        rightCarrot.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        rightCarrot.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -4).isActive = true
        rightCarrot.widthAnchor.constraint(equalToConstant: 20).isActive = true
        rightCarrot.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
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
