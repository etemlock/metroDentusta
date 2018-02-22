//
//  welcomeUserViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 2/15/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class welcomeUserViewController: UIViewController {
    var welcomeLabel : UILabel!
    var idLabel: UILabel!
    private var currUser: member!
    private var session: URLSession!
    
    convenience init(user: member, session: URLSession){
        self.init(user: user, session: session)
        self.currUser = user
        self.session = session
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "Welcome "
        view.backgroundColor = UIColor.white
        
        self.hideKeyBoardWhenTappedAround()
        setUpLabels()
    }
    
    func setUpLabels(){
        welcomeLabel = UILabel(frame: CGRect(x: self.view.center.x - 100, y: self.view.center.y - 30, width: 200, height: 30))
        welcomeLabel.text = "Welcome \(currUser.getUsername())"
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = welcomeLabel.font.withSize(19)
        
        idLabel = UILabel(frame: CGRect(x: self.view.center.x - 50, y: self.view.center.y + 20, width: 100, height: 30))
        idLabel.text = currUser.getId()
        idLabel.textAlignment = .center
        idLabel.font = idLabel.font.withSize(19)
        
        self.view.addSubview(welcomeLabel)
        self.view.addSubview(idLabel)
    }
}
