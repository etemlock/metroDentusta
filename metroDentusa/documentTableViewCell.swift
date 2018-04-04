//
//  documentTableViewCell.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 3/27/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class documentTableViewCell: UITableViewCell, genericTableViewCell {
    private var cellLabel = UILabel()
    var cellButton = UIButton()
    var setRowDelegate: setRowDelegate?
    var row: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setText(text: String){
        cellLabel.text = text
    }
    
    func getText() -> String?{
        return cellLabel.text
    }
    

    
    func setUpView(){
        cellButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellButton)
        cellButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        cellButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        cellButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        cellButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cellButton.setTitle("View PDF", for: .normal)
        cellButton.setTitleColor(LoginSignUpViewController.defaultButtonTextColor, for: .normal)
        cellButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellLabel)
        cellLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        cellLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        cellLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cellLabel.trailingAnchor.constraint(equalTo: cellButton.leadingAnchor, constant: -8).isActive = true
    }
    
    func setRowTrigger(){
        setRowDelegate?.setRow(row: self.row!)
    }
    
    
}
