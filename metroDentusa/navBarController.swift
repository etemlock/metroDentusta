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
    }
    
        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    //You need a reload table delegate in order to actually acheive this
    override func numberOfSections(in tableView: UITableView) -> Int {
        if user != nil {
            return 7
        }
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            performSegue(withIdentifier: "backHome", sender: self)
        }
        if(indexPath.section == 1){
            performSegue(withIdentifier: "findDentistSegue", sender: self)
        }
        if(indexPath.section == 3){
            performSegue(withIdentifier: "FAQsSegue", sender: self)
        }
        if(indexPath.section == 4){
            performSegue(withIdentifier: "dentalHealthSegue", sender: self)
        }
        if(indexPath.section == 5){
            performSegue(withIdentifier: "ContactSegue", sender: self)
        }
        if(indexPath.section == 6){
            if self.user != nil {
                performSegue(withIdentifier: "viewCardSegue", sender: self)
            } else {
                DispatchQueue.main.async {
                    self.promptAlertWithDelay("", inmessage: "Must be logged in to view benefit card", indelay: 5.0)
                }
                performSegue(withIdentifier: "backHome", sender: self)
            }
        }
    }
    
    func setUser(member: member){
        self.user = member
    }
    
    func killUser(){
        self.user = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController {
            if segue.identifier == "backHome" {
                navController.viewControllers = [LoginSignUpViewController(user: self.user, session: nil)]
            }
            if segue.identifier == "viewCardSegue" {
                navController.viewControllers = [benefitCardViewController(user: (self.user)!, session: nil)]
            }
        }
    }
    

    
    
    
    
    

    
    
}
