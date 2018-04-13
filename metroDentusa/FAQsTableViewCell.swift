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
}
