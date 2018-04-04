//
//  popUpPickerViewView.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 1/15/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class popUpPickerViewView : UIView {
    var barView = UIView()
    var barLabel = UILabel()
    var closeButton = UIButton()
    var pickerView = UIPickerView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setUpViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUpViews()
    }
    
    
    private func setUpViews(){
        /*barView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
        barView.backgroundColor = LoginSignUpViewController.themeColor
        barLabel = UILabel(frame: CGRect(x: barView.center.x - 100, y: 5, width: 200, height: 20))
        barLabel.textAlignment = .center
        barLabel.textColor = UIColor.white
        closeButton = UIButton(frame: CGRect(x: barView.frame.width-28, y: 5, width: 20, height: 20))
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(UIColor.white, for: .normal)
        barView.addSubview(closeButton)
        barView.addSubview(barLabel)
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(pickerView)
        self.addSubview(barView)
        self.backgroundColor = UIColor.white*/
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pickerView)
        pickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        pickerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        barView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(barView)
        barView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        barView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        barView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        barView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        barView.backgroundColor = LoginSignUpViewController.themeColor
        
        barLabel.translatesAutoresizingMaskIntoConstraints = false
        barView.addSubview(barLabel)
        barLabel.centerXAnchor.constraint(equalTo: barView.centerXAnchor).isActive = true
        barLabel.centerYAnchor.constraint(equalTo: barView.centerYAnchor).isActive = true
        barLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        barLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        barLabel.textAlignment = .center
        barLabel.textColor = UIColor.white
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        barView.addSubview(closeButton)
        closeButton.trailingAnchor.constraint(equalTo: barView.trailingAnchor, constant: -8).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: barView.centerYAnchor).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(UIColor.white, for: .normal)
        
        self.backgroundColor = UIColor.white
    }
    
    func updatePickerView(){
        pickerView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    
}
