//
//  cellLabelCell.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 4/18/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class labelCell: UITableViewCell, genericTableViewCell {
    var cellLabel = UILabel()
    var cellLabelConstraints : [String: NSLayoutConstraint?] = ["X": nil, "Y": nil, "width": nil,"height": nil]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    func setUpDefaultcellLabel(){
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cellLabel)
        cellLabelConstraints["X"] = cellLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        cellLabelConstraints["Y"] = cellLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        cellLabelConstraints["width"] = cellLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8)
        cellLabelConstraints["height"] = cellLabel.heightAnchor.constraint(equalToConstant: 20)
        cellLabel.textColor = UIColor.white
        cellLabel.textAlignment = .center
        
        for constraint in cellLabelConstraints {
            if constraint.value != nil {
                constraint.value?.isActive = true
            }
        }
    }
    
}
