//
//  blogTableCell.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 3/2/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class blogTableCell : UITableViewCell {
    private var title = UILabel()
    private var authorDate = UILabel()
    private var categoryLabel = UILabel()
    private var cellImageView = UIImageView()
    private var descriptionText = UILabel()
    var link = String()
    
    override init (style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setUpCell(params: blogPostParams){
        /**************** assign link ******************/
        link = params.blogLink
        
        /****************** set up content***************/
        let labelWidth = self.contentView.frame.width - 16
        let estRect1 = params.title.estimateFrameForText(maxWidth: labelWidth, maxHeight: 45, font: 17)
        title.frame = CGRect(x: 8, y: 23, width: labelWidth, height: estRect1.height)
        title.text = params.title
        title.textColor = LoginSignUpViewController.themeColor
        title.numberOfLines = 2
        
        authorDate.frame = CGRect(x: 8, y: title.frame.maxY + 4, width: labelWidth, height: 17)
        authorDate.text = params.date + " by " + params.author
        authorDate.font = authorDate.font.withSize(13)
        authorDate.textColor = UIColor.darkGray
        
        var categoryString = ""
        for category in params.categories {
            categoryString += "\(category), "
        }
        let endIndex = categoryString.index(categoryString.endIndex, offsetBy: -2)
        categoryString = categoryString.substring(to: endIndex)
        let estRect2 = categoryString.estimateFrameForText(maxWidth: labelWidth, maxHeight: 35, font: 13)
        categoryLabel.frame = CGRect(x: 8, y: authorDate.frame.maxY + 2, width: labelWidth, height: estRect2.height)
        categoryLabel.text = categoryString
        categoryLabel.font = categoryLabel.font.withSize(13)
        categoryLabel.numberOfLines = 2
        categoryLabel.textColor = UIColor.darkGray
        
        cellImageView.frame = CGRect(x: 0, y: 195, width: self.contentView.frame.width, height: 140)
        if params.image != nil {
            cellImageView.image = params.image
        } else {
            cellImageView.image = UIImage(named: "metroTooth")
        }
        cellImageView.contentMode = .scaleAspectFit
        
        let descriptionHeight = cellImageView.frame.minY - categoryLabel.frame.maxY - 8
        descriptionText.frame = CGRect(x: 8, y: categoryLabel.frame.maxY + 4, width: labelWidth, height: descriptionHeight)
        descriptionText.text = params.description
        descriptionText.font = descriptionText.font.withSize(15)
        descriptionText.numberOfLines = 4
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(authorDate)
        self.contentView.addSubview(categoryLabel)
        self.contentView.addSubview(cellImageView)
        self.contentView.addSubview(descriptionText)
    }
    

    
    
}
