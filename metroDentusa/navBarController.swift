//
//  navBarController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/14/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation


class navBarController : UITableViewController {
    //var textLabelArray = ["Home","Find Your Dentist","Forms","FAQs","Dental Health","Contact US","Sign In/Sign Up"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            performSegue(withIdentifier: "backHome", sender: self)
        }
        if(indexPath.section == 1){
            performSegue(withIdentifier: "findDentistSegue", sender: self)
        }
        if(indexPath.section == 6){
            performSegue(withIdentifier: "toSignUp", sender: self)
        }
    }
    
    
}
