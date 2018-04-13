//
//  delegateMethods.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/16/17.
//  Copyright © 2017 ASO. All rights reserved.
//

import Foundation

protocol userInputFieldDelegate {
    func userInputFieldDidChange(userInputField: userInputField)
}

protocol setRowDelegate {
    func setRow(row: Int)
}

protocol openViewDelegate {
    func openView(navBar: navBarController)
}
