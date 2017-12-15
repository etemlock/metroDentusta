//
//  navBarController.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/14/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation
 class paddedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}

class navBarController : UITableViewController {
    //var textLabelArray = ["Home","Find Your Dentist","Forms","FAQs","Dental Health","Contact US","Sign In/Sign Up"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 6){
            performSegue(withIdentifier: "toSignUp", sender: self)
        }
    }
    
    
}
