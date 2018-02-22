//
//  dentistInfoTableCell.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 1/27/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class dentistInfoTableCell : UITableViewCell {
    var dentistNameLabel = UILabel(frame: CGRect(x: 8, y: 8, width: 260, height: 50))
    var addressLabel1 = UILabel(frame: CGRect(x: 8, y: 62, width: 220, height: 17))
    var addressLabel2 = UILabel(frame: CGRect(x: 8, y: 83, width: 220, height: 17))
    var specialtiesLabel = UILabel(frame: CGRect(x: 8, y: 104, width: 236, height: 20))
    var distanceLabel = UILabel(frame: CGRect(x: 247, y: 104, width: 120, height: 20))
    var officeProfile = UIButton(frame: CGRect(x: 268, y: 35, width: 100, height: 40))

    var setRowdelegate : setRowDelegate?
    var row: Int?
    
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLabels()
        setUpButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setUpLabels(){
        
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
        officeProfile.setUpDefaultType(title: "Office Profile")
        officeProfile.titleLabel?.font = officeProfile.titleLabel?.font.withSize(15)
        //officeProfile.addTarget(self, action: #selector(setRowTrigger), for: .touchUpInside)
        self.contentView.addSubview(officeProfile)
    }
    
    func setRowTrigger(){
        setRowdelegate?.setRow(row: self.row!)
    }
    

}
