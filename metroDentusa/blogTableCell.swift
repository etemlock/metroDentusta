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
        //let standardWidth = self.frame.width - 16
        
        title.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(title)
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
       // var estHeight = params.title.estimateFrameForText(maxWidth: standardWidth, maxHeight: 45, font: 17).height
        //title.heightAnchor.constraint(equalToConstant: estHeight).isActive = true
        title.text = params.title
        title.textColor = LoginSignUpViewController.themeColor
        title.numberOfLines = 2

        
        authorDate.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(authorDate)
        authorDate.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4).isActive = true
        authorDate.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        authorDate.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        authorDate.heightAnchor.constraint(equalToConstant: 17).isActive = true
        authorDate.text = params.date + " by " + params.author
        authorDate.font = authorDate.font.withSize(13)
        authorDate.textColor = UIColor.darkGray
        
        var categoryString = ""
        for category in params.categories {
            categoryString += "\(category), "
        }
        let endIndex = categoryString.index(categoryString.endIndex, offsetBy: -2)
        categoryString = categoryString.substring(to: endIndex)
        //estHeight = categoryString.estimateFrameForText(maxWidth: standardWidth, maxHeight: 35, font: 13).height
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(categoryLabel)
        categoryLabel.topAnchor.constraint(equalTo: authorDate.bottomAnchor, constant: 2).isActive = true
        categoryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        categoryLabel.text = categoryString
        categoryLabel.font = categoryLabel.font.withSize(13)
        categoryLabel.numberOfLines = 2
        categoryLabel.textColor = UIColor.darkGray
        
        parentViewDidTransition(orientation: UIDevice.current.orientation)

        
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cellImageView)
        cellImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cellImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        cellImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellImageView.heightAnchor.constraint(equalToConstant: 145).isActive = true
        if params.image != nil {
            cellImageView.image = params.image
        } else {
            cellImageView.image = UIImage(named: "metroTooth")
        }
        cellImageView.contentMode = .scaleAspectFit
        
        
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(descriptionText)
        descriptionText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        descriptionText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        descriptionText.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4).isActive = true
        descriptionText.bottomAnchor.constraint(equalTo: cellImageView.topAnchor, constant: -4).isActive = true
        descriptionText.text = params.description
        descriptionText.font = descriptionText.font.withSize(15)
        descriptionText.numberOfLines = 4
        
    }
    
    func parentViewDidTransition(orientation: UIDeviceOrientation){
        switch orientation {
        case .portrait:
            title.textAlignment = .left
            authorDate.textAlignment = .left
            categoryLabel.textAlignment = .left
        case .landscapeLeft, .landscapeRight:
            title.textAlignment = .center
            authorDate.textAlignment = .center
            categoryLabel.textAlignment = .center
        default:
            break
        }
    }
    

    
    
}
