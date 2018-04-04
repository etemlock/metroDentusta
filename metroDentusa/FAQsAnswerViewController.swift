//
//  FAQsAnswerViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 3/12/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class FAQsAnswerViewController: UIViewController {
    var menuButton : UIBarButtonItem!
    private var questionNum : Int!
    var scrollView = UIScrollView()
    var contentView = UIView()
    var containerView = UIView()
    var questionLabel = UILabel()
    var questionLabelHeight : NSLayoutConstraint!
    var answerLabel = UILabel()
    var answerLabelHeight: NSLayoutConstraint!
    //var containerHeightAnchor : NSLayoutConstraint!
    
    /******* data ********/
    var answerHeight : CGFloat = 0
    var questionHeight : CGFloat = 0
    
    init(question: String, questionNum: Int){
        super.init(nibName: nil, bundle: nil)
        questionLabel.text = question
        self.questionNum = questionNum
        estimateHeightForQuestion()
        estimateHeightForAnswer(questionNum: self.questionNum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "FAQs"
        view.backgroundColor = UIColor.white
        self.hideKeyBoardWhenTappedAround()
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.toggleMenuButton(menuButton: menuButton)
        self.navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
        self.navigationItem.rightBarButtonItem = menuButton
        edgesForExtendedLayout = []
        
        self.setUpScrollViewAndContentView(scrollView: self.scrollView, contentView: self.contentView)
        setUpView()
        
        contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 15).isActive = true
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { (context) -> Void in
            self.answerLabelHeight.isActive = false
            self.questionLabelHeight.isActive = false
            self.estimateHeightForQuestion()
            self.estimateHeightForAnswer(questionNum: self.questionNum)
            self.answerLabelHeight = self.answerLabel.heightAnchor.constraint(equalToConstant: self.answerHeight)
            self.answerLabelHeight.isActive = true
            self.questionLabelHeight = self.questionLabel.heightAnchor.constraint(equalToConstant: self.questionHeight)
            self.questionLabelHeight.isActive = true
        })
    }
    
    func estimateHeightForQuestion(){
        if let estHeight = questionLabel.text?.estimateFrameForText(maxWidth: self.view.frame.width - 32, maxHeight: 100, font: 16).height {
            questionHeight = estHeight + 20
        }
        let numLines = (questionHeight/20) + 1
        questionLabel.numberOfLines = Int(numLines)
    }
    
    func estimateHeightForAnswer(questionNum: Int){
        var answerText = ""
        switch questionNum {
        case 0:
            answerText = "Anyone looking for great dental care at affordable prices. Dependents up to 19 and students up to 23 are covered under the family plan."
        case 1:
            answerText = "There is a yearly fee. $85 for individuals. $125 for member + one other family member. $150 for family coverage. Group discounts are available."
        case 2:
            answerText = "Dentists listed on this site will accept these fees. You should always verify that the dentist is currently participating and go over any charges you will incur before beginning any treatment as you will be responsible to pay the dentist."
        case 3:
            answerText = "If you are dissatisfied with the plan and wish to cancel, send a written cancellation letter, together with your membership card(s) to Administrative Services Only, Inc., 303 Merrick Road, Ste. 300, Lynbrook, NY 11563.\n\nUpon cancellation Administrative Services Only will stop collecting membership fees in a reasonable amount of time, but no later than 30 days after receiving a valid cancellation notice.\n\nIf you cancel within the first 30 days after activation you will receive a full refund of all membership fees. In the event of cancellation by either party following the first 30 days after activation, Administrative Services Only will make a pro-rata reimbursement of the membership fees to you for the unexpired portion of the term."
        case 4:
            answerText = "Your membership is effective for 12 months and will not automatically renew. If you wish to renew your membership, please complete a new enrollment application and submit with payment either on our website via credit or electronic check or in the form of a check or money order made payable and mailed to MetroDent."
        case 5:
            answerText = "If a you are dissatisfied with the plan and wish to submit a complaint, please call us Toll Free at 844-638-3368 or submit a concern or mail your written complaint to Administrative Services Only, Inc., 303 Merrick Road, Ste. 300, Lynbrook, NY 11563. While response times vary, we strive to resolve all complaints no later than 30 calendar days following receipt of the complaint."
        default:
            break
        }
        
        answerLabel.text = answerText
        answerLabel.font = answerLabel.font.withSize(15)

        answerHeight = answerText.estimateFrameForText(maxWidth: self.view.frame.width - 32, maxHeight: 500, font: 15).height + 20
        let numLines = (answerHeight/18) + 1
        answerLabel.numberOfLines = Int(numLines)
        
    }
    
    /*func setUpView(){
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        containerHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: 300)
        containerHeightAnchor.isActive = true
        containerView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.5)
        
        containerView.layoutIfNeeded()
        
        setUpTitle()
        setUpAnswer()
    }*/
    
    func setUpView(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        containerView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.5)
        
        setUpTitle()
        setUpAnswer()
        
        containerView.bottomAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func setUpTitle(){
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(questionLabel)
        
        questionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        questionLabelHeight = questionLabel.heightAnchor.constraint(equalToConstant: questionHeight)
        questionLabelHeight.isActive = true
        
        questionLabel.backgroundColor = UIColor.white
        questionLabel.textColor = LoginSignUpViewController.themeColor
        questionLabel.textAlignment = .center
        questionLabel.font = questionLabel.font.withSize(16)
    }
    
    func setUpAnswer(){
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(answerLabel)
        
        answerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 5).isActive = true
        answerLabel.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor).isActive = true
        answerLabel.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor).isActive = true
        answerLabelHeight = answerLabel.heightAnchor.constraint(equalToConstant: answerHeight)
        answerLabelHeight.isActive = true
        
        answerLabel.backgroundColor = UIColor.white
    }
    
    /*func setUpTitle(){
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(questionLabel)
        
        let estHeight = questionLabel.text?.estimateFrameForText(maxWidth: containerView.frame.size.width - 16, maxHeight: 100, font: 16).height
        questionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        questionLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        questionLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        questionLabel.heightAnchor.constraint(equalToConstant: estHeight! + 10).isActive = true
        
        let numLines = (estHeight!/20) + 1
        questionLabel.numberOfLines = Int(numLines)
        questionLabel.backgroundColor = UIColor.white
        questionLabel.textColor = LoginSignUpViewController.themeColor
        questionLabel.textAlignment = .center
        questionLabel.font = questionLabel.font.withSize(16)
        
    }
    
    func setUpAnswer(){
        var answerText = ""
        switch questionNum {
        case 0:
            answerText = "Anyone looking for great dental care at affordable prices. Dependents up to 19 and students up to 23 are covered under the family plan."
        case 1:
            answerText = "There is a yearly fee. $85 for individuals. $125 for member + one other family member. $150 for family coverage. Group discounts are available."
        case 2:
            answerText = "Dentists listed on this site will accept these fees. You should always verify that the dentist is currently participating and go over any charges you will incur before beginning any treatment as you will be responsible to pay the dentist."
        case 3:
            answerText = "If you are dissatisfied with the plan and wish to cancel, send a written cancellation letter, together with your membership card(s) to Administrative Services Only, Inc., 303 Merrick Road, Ste. 300, Lynbrook, NY 11563.\n\nUpon cancellation Administrative Services Only will stop collecting membership fees in a reasonable amount of time, but no later than 30 days after receiving a valid cancellation notice.\n\nIf you cancel within the first 30 days after activation you will receive a full refund of all membership fees. In the event of cancellation by either party following the first 30 days after activation, Administrative Services Only will make a pro-rata reimbursement of the membership fees to you for the unexpired portion of the term."
        case 4:
            answerText = "Your membership is effective for 12 months and will not automatically renew. If you wish to renew your membership, please complete a new enrollment application and submit with payment either on our website via credit or electronic check or in the form of a check or money order made payable and mailed to MetroDent."
        case 5:
            answerText = "If a you are dissatisfied with the plan and wish to submit a complaint, please call us Toll Free at 844-638-3368 or submit a concern or mail your written complaint to Administrative Services Only, Inc., 303 Merrick Road, Ste. 300, Lynbrook, NY 11563. While response times vary, we strive to resolve all complaints no later than 30 calendar days following receipt of the complaint."
        default:
            break
        }
        
        let estHeight = answerText.estimateFrameForText(maxWidth: containerView.frame.width - 16, maxHeight: 500, font: 15).height
        
        let answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(answerLabel)
        answerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 5).isActive = true
        answerLabel.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor).isActive = true
        answerLabel.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor).isActive = true
        answerLabel.heightAnchor.constraint(equalToConstant: CGFloat(estHeight + 10)).isActive = true
        
        let numLines = (estHeight/18) + 1
        answerLabel.numberOfLines = Int(numLines)
        answerLabel.backgroundColor = UIColor.white
        answerLabel.text = answerText
        answerLabel.font = answerLabel.font.withSize(15)
       
        
        /********** modify container Height ************/
        containerHeightAnchor.isActive = false
        containerHeightAnchor = containerView.bottomAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 8)
        containerHeightAnchor.isActive = true
    }*/
    

}
