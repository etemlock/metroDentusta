//
//  testingScrollVC.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 4/2/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class testingScrollVC : UIViewController {
    var menuButton : UIBarButtonItem!
    var scrollView = UIScrollView()
    var contentView = UIView()
    var viewR = UIView()
    var viewG = UIView()
    var viewB = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardWhenTappedAround()
        self.view.backgroundColor = UIColor.white
        
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.toggleMenuButton(menuButton: menuButton)
        //setUpScrollAndContentView()
        self.setUpScrollViewAndContentView(scrollView: self.scrollView, contentView: self.contentView)
        setUpViews()
        contentView.bottomAnchor.constraint(equalTo: viewG.bottomAnchor, constant: 15).isActive = true
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func setUpViews(){
        viewR.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewR)
        viewR.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        viewR.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        viewR.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        viewR.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -40).isActive = true
        viewR.backgroundColor = UIColor.red
        
        viewG.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewG)
        viewG.topAnchor.constraint(equalTo: viewR.bottomAnchor, constant: 30).isActive = true
        viewG.leadingAnchor.constraint(equalTo: viewR.leadingAnchor).isActive = true
        viewG.trailingAnchor.constraint(equalTo: viewR.trailingAnchor).isActive = true
        viewG.heightAnchor.constraint(equalTo: viewR.heightAnchor).isActive = true
        viewG.backgroundColor = UIColor.green
    }
}
