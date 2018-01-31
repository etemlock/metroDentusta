//
//  dentistInfoTableCell.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 1/27/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class dentistInfoTableCell : UITableViewCell {
    var dentistNameLabel : UILabel!
    var addressLabel1 = UILabel(frame: CGRect(x: 8, y: 29, width: 175, height: 20))
    var addressLabel2 = UILabel(frame: CGRect(x: 8, y: 50, width: 220, height: 20))
    var phoneNumLabel = UILabel(frame: CGRect(x: 8, y: 71, width: 120, height: 20))
    var handicapAccLabel = UILabel(frame: CGRect(x: 8, y: 92, width: 155, height: 20))
    var credentialLabel : UILabel!
    var distanceLabel = UILabel(frame: CGRect(x: 242, y: 150, width: 125, height: 20))

    
    
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
        credentialLabel = UILabel(frame: CGRect(x: 8, y: 110, width: self.frame.width-16, height: 40))
        credentialLabel.numberOfLines = 2
        distanceLabel.textColor = RootViewController.themeColor
        self.contentView.addSubview(credentialLabel)
        self.contentView.addSubview(addressLabel1)
        self.contentView.addSubview(addressLabel2)
        self.contentView.addSubview(phoneNumLabel)
        self.contentView.addSubview(handicapAccLabel)
        self.contentView.addSubview(credentialLabel)
        self.contentView.addSubview(distanceLabel)
        
        for case let label as UILabel in self.contentView.subviews {
            label.font = label.font.withSize(15)
        }
        
        dentistNameLabel = UILabel(frame: CGRect(x: 8, y: 8, width: self.frame.width-16, height: 20))
        self.contentView.addSubview(dentistNameLabel)
    }
    
    func setUpButtons(){
        let officeProfile = UIButton(frame: CGRect(x: 247, y: 30, width: 120, height: 40))
        officeProfile.setUpDefaultType(title: "Office Profile")
        self.contentView.addSubview(officeProfile)
    }
}
