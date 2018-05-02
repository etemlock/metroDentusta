//
//  formTableViewCell.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/16/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation

class userInputField : UITextField {
    private var val : Int?
    var userInputdelegate: userInputFieldDelegate?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.addTarget(self, action: #selector(doTheThing), for: .editingChanged)
        //self.addTarget(self, action: #selector(doTheOtherThing), for: .editingChanged)
        self.clearButtonMode = .whileEditing
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        self.addTarget(self, action: #selector(doTheThing), for: .editingChanged)
        //self.addTarget(self, action: #selector(doTheOtherThing), for: .editingChanged)
        self.clearButtonMode = .whileEditing
    }
    
    
    func setVal(val : Int) {
        self.val = val
    }
    
    func getVal() -> Int?{
        return val
    }
    
    func doTheThing(){
        userInputdelegate?.userInputFieldDidChange(userInputField: self)
    }
}


class formTableViewCell : UITableViewCell {
    var formTextField = userInputField()
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        /*formTextField = userInputField(frame: CGRect(x: 0, y: 0, width: self.frame.size.width-40, height: self.frame.size.height))
        formTextField.backgroundColor = LoginSignUpViewController.defaultGray, green: 226/255, blue: 233/255, alpha: 1)
        formTextField.borderStyle = UITextBorderStyle.roundedRect
        self.contentView.addSubview(formTextField!)*/
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpFormTextField(){
        formTextField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(formTextField)
        formTextField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        formTextField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        formTextField.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        formTextField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        formTextField.backgroundColor = LoginSignUpViewController.defaultGray
        formTextField.borderStyle = UITextBorderStyle.roundedRect
    }
}
