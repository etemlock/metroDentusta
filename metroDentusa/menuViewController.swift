//
//  menuViewController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 4/18/18.
//  Copyright © 2018 ASO. All rights reserved.
//

import Foundation

class menuViewController: UITableViewController {
    private var user: member?
    
    
    /*********** data *********/
    var labelArray = ["Find Dentists", "Forms", "Dental Health", "Help",
                      "View/Edit User Profile", "View Benefit Card", "Logout"]
    var segueArray = ["findDentistSegue", "formSegue",
                      "dentalHealthSegue", "HelpSegue",
                      "viewEditSegue", "viewCardSegue", "logoutSegue"]
    var cellId = "menuCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let index = self.navigationController?.viewControllers.index(of: self){
            let parentVC = self.navigationController?.viewControllers[index-1] as! LoginSignUpViewController
            if parentVC.currUser != nil {
                self.user = parentVC.currUser
                self.promptAlertWithDelay("Welcome Back", inmessage: "Welcome back \((self.user?.getName())!)", indelay: 1000)
                print("\(self.user)")
                
            }
        }
        self.navigationItem.title = "Main Menu"
        self.navigationItem.hidesBackButton = true
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
        tableView.register(cellClass: labelCell.self)
    }

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.user != nil {
            return 7
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: labelCell.self, for: indexPath)
        cell.contentView.backgroundColor = LoginSignUpViewController.themeColor
        cell.setUpDefaultcellLabel()
        cell.cellLabel.text = labelArray[indexPath.section]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segueArray[indexPath.section] == "logoutSegue" {
            performLogout()
        } else {
            performSegue(withIdentifier: segueArray[indexPath.section], sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController {
            if segue.identifier == "formSegue" {
                navController.viewControllers = [formViewController(user: self.user)]
            }
            else if segue.identifier == "viewCardSegue" {
                navController.viewControllers = [benefitCardViewController(user: (self.user)!, session: nil)]
            }
            else if segue.identifier == "viewEditSegue" {
                navController.viewControllers = [userCreationEditViewController(user: (self.user)!, isNewUser: false)]
            }
        }
    }
    
    func performLogout(){
        let logoutAlert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
        logoutAlert.willPerformLogout(completion: { (didSelectLogout: Bool) in
            if didSelectLogout {
                if let revealVC = self.revealViewController(), let navBarView = revealVC.rearViewController as? navBarController {
                    navBarView.killUser()
                    self.performSegue(withIdentifier: "logoutSegue", sender: self)
                } else {
                    logoutAlert.dismiss(animated: true, completion: nil)
                    self.promptAlertWithDelay("", inmessage: "We're experiencing difficulty logging out. Try closing the app and reopening", indelay: 5.0)
                }
            }
        })
        present(logoutAlert, animated: true, completion: nil)
    }
    
}

