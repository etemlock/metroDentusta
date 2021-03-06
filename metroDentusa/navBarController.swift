//
//  navBarController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/14/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation


class navBarController : UITableViewController {
    var openviewdelagte : openViewDelegate?
    private var user: member?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    
        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if user != nil {
            return 7
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            performSegue(withIdentifier: "findDentistSegue", sender: self)
        }
        if(indexPath.section == 1){
            performSegue(withIdentifier: "formSegue", sender: self)
        }
        if(indexPath.section == 2){
            performSegue(withIdentifier: "dentalHealthSegue", sender: self)
        }
        if(indexPath.section == 3){
            performSegue(withIdentifier: "HelpSegue", sender: self)
        }
        if(indexPath.section == 4){
            performSegue(withIdentifier: "viewEditSegue", sender: self)
        }
        if(indexPath.section == 5){
            performSegue(withIdentifier: "viewCardSegue", sender: self)
        }
        if(indexPath.section == 6){
            performLogout()
        }
    }
    
    func setUser(member: member){
        self.user = member
    }
    
    func getUser() -> member? {
        if self.user != nil {
            return self.user!
        }
        return nil
    }
    
    func killUser(){
        self.user = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController {
            if segue.identifier == "formSegue" {
                navController.viewControllers = [formViewController(user: self.user)]
            }
            if segue.identifier == "viewCardSegue" {
                navController.viewControllers = [benefitCardViewController(user: (self.user)!, session: nil)]
            }
            if segue.identifier == "viewEditSegue" {
                navController.viewControllers = [userCreationEditViewController(user: (self.user)!, isNewUser: false)]
            }
        }
    }
    
    func performLogout(){
        let logoutAlert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
        logoutAlert.willPerformLogout(completion: { (didSelectLogout: Bool) in
            if didSelectLogout {
                self.killUser()
                self.performSegue(withIdentifier: "backToLogin", sender: self)
            }
        })
        present(logoutAlert, animated: true, completion: nil)
    }

    
    
    
    
    

    
    
}
