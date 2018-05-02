//
//  dentistInfoTableCell.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 1/27/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class dentistInfoTableCell : UITableViewCell {
    /*var dentistNameLabel = UILabel(frame: CGRect(x: 8, y: 8, width: 260, height: 50))
    var addressLabel1 = UILabel(frame: CGRect(x: 8, y: 62, width: 220, height: 17))
    var addressLabel2 = UILabel(frame: CGRect(x: 8, y: 83, width: 220, height: 17))
    var specialtiesLabel = UILabel(frame: CGRect(x: 8, y: 104, width: 236, height: 20))
    var distanceLabel = UILabel(frame: CGRect(x: 247, y: 104, width: 120, height: 20))
    var officeProfile = UIButton(frame: CGRect(x: 268, y: 35, width: 100, height: 40))*/
    
    var dentistNameLabel = UILabel()
    var addressLabel1 = UILabel()
    var addressLabel2 = UILabel()
    var specialtiesLabel = UILabel()
    var distanceLabel = UILabel()
    var officeProfile = UIButton()

    var setRowdelegate : setRowDelegate?
    var row: Int?
    
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpButtons()
        setUpLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setUpLabels(){
        
        dentistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(dentistNameLabel)
        dentistNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        dentistNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        dentistNameLabel.trailingAnchor.constraint(equalTo: officeProfile.leadingAnchor, constant: 8).isActive = true
        dentistNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(distanceLabel)
        distanceLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6).isActive = true
        distanceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addressLabel1.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(addressLabel1)
        addressLabel1.leadingAnchor.constraint(equalTo: dentistNameLabel.leadingAnchor).isActive = true
        addressLabel1.topAnchor.constraint(equalTo: dentistNameLabel.bottomAnchor, constant: 4).isActive = true
        addressLabel1.trailingAnchor.constraint(equalTo: distanceLabel.leadingAnchor, constant: -8).isActive = true
        addressLabel1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addressLabel2.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(addressLabel2)
        addressLabel2.topAnchor.constraint(equalTo: addressLabel1.bottomAnchor, constant: 1).isActive = true
        addressLabel2.leadingAnchor.constraint(equalTo: addressLabel1.leadingAnchor).isActive = true
        addressLabel2.trailingAnchor.constraint(equalTo: addressLabel1.trailingAnchor).isActive = true
        addressLabel2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        specialtiesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(specialtiesLabel)
        specialtiesLabel.topAnchor.constraint(equalTo: addressLabel2.bottomAnchor, constant: 1).isActive = true
        specialtiesLabel.leadingAnchor.constraint(equalTo: addressLabel2.leadingAnchor).isActive = true
        specialtiesLabel.trailingAnchor.constraint(equalTo: addressLabel2.trailingAnchor).isActive = true
        specialtiesLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        distanceLabel.textColor = LoginSignUpViewController.themeColor
        distanceLabel.textAlignment = .right
        self.contentView.addSubview(addressLabel1)
        self.contentView.addSubview(addressLabel2)
        self.contentView.addSubview(specialtiesLabel)
        self.contentView.addSubview(distanceLabel)
        
        for case let label as UILabel in self.contentView.subviews {
            label.font = label.font.withSize(15)
        }
        
        dentistNameLabel.numberOfLines = 2
        //dentistNameLabel.tex
        self.contentView.addSubview(dentistNameLabel)
    }
    
    func setUpButtons(){
        officeProfile.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(officeProfile)
        officeProfile.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        officeProfile.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        officeProfile.widthAnchor.constraint(equalToConstant: 100).isActive = true
        officeProfile.heightAnchor.constraint(equalToConstant: 35).isActive = true
        officeProfile.setUpDefaultType(title: "Office Profile")
        officeProfile.titleLabel?.font = officeProfile.titleLabel?.font.withSize(15)
    }
    
    func setRowTrigger(){
        setRowdelegate?.setRow(row: self.row!)
    }
    

}
