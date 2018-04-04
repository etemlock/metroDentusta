//
//  FAQsTableViewCell.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 3/12/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class FAQsTableViewCell: UITableViewCell {
    var cellLabel = UILabel()
    var cellImage = UIImageView()
    var rightCarrot = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(cellLabel)
        self.contentView.addSubview(cellImage)
        self.contentView.addSubview(rightCarrot)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setImage(image: UIImage){
        cellImage.image = image
        cellImage.contentMode = .scaleAspectFit
    }
    
    func setText(text: String){
        cellLabel.text = text
    }
    /*private var cellLabel = UILabel(frame: CGRect(x: 60, y: 14, width: 200, height: 20))
    private var cellImage = UIImageView(frame: CGRect(x: 8, y: 9, width: 30, height: 30))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //cellImage.image = UIImage(named: "Phone Icon")
        cellImage.contentMode = .scaleAspectFit
        self.contentView.addSubview(cellImage)
        self.contentView.addSubview(cellLabel)
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
     let cellLabel = cell.cellLabel
     cellLabel.translatesAutoresizingMaskIntoConstraints = false
     cellLabel.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 22).isActive = true
     cellLabel.centerYAnchor.constraint(equalTo: ctvc.centerYAnchor).isActive = true
     cellLabel.trailingAnchor.constraint(equalTo: ctvc.trailingAnchor, constant: -28).isActive = true
     cellLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
     
     if indexPath.row == 0 {
     ctvc.setImage(image: UIImage(named: "Mail Icon")!)
     ctvc.setText("Mail Us")
     } else {
     ctvc.setImage(image: UIImage(named: "Phone Icon")!)
     ctvc.setText("Call ")
     }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    func setImage(image: UIImage){
        cellImage.image = image
    }*/
}
