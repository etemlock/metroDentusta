//
//  LoginSignUpViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/14/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation

class LoginSignUpViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var segmentIndexFlag = 0
    var menuButton : UIBarButtonItem!
    var formTableView : UITableView!
    
    let segmentController : UISegmentedControl = UISegmentedControl(items: ["Login", "Create Username"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton = UIBarButtonItem(image: UIImage(named: "Hamburg Menu"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = menuButton
        self.navigationItem.title = "Sign Up or Login!"
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //view.backgroundColor = UIColor(red: 132/255, green: 159/255, blue: 208/255, alpha: 1)
        setUpSegmentController()
        setUpTableView()
    }
    
    func setUpSegmentController(){
        segmentController.frame = CGRect(x: 47, y: 196, width: 280, height: 30)
        segmentController.tintColor = UIColor.black
        segmentController.addTarget(self, action: #selector(changeIndex(sender:)), for: .valueChanged)
        segmentController.selectedSegmentIndex = 0
        self.view.addSubview(segmentController)
    }
    
    func setUpTableView(){
        formTableView = UITableView(frame: CGRect(x: 47, y: 250, width: 280, height: 200))
        formTableView.dataSource = self
        formTableView.delegate = self
        formTableView.register(UITableViewCell.self, forCellReuseIdentifier: "tempClass")
        formTableView.alwaysBounceVertical = false
        self.view.addSubview(formTableView)
    }
    
    func changeIndex(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            segmentIndexFlag = 0
            formTableView.reloadData()
            break
        case 1:
            segmentIndexFlag = 1
            formTableView.reloadData()
            break
        default:
            break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentIndexFlag == 0 {
            return 2
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tempClass", for: indexPath)
        cell.textLabel?.text = "\(indexPath.section)"
        return cell
    }
}
