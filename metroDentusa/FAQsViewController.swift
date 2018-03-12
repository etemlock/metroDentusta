//
//  FAQsViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 3/12/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class FAQsViewController: UIViewController {
    var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoardWhenTappedAround()
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.navigationItem.title = "Frequently Asked Questions"
        self.toggleMenuButton(menuButton: menuButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
