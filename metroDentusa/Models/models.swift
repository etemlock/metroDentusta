//
//  models.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/31/17.
//  Copyright © 2017 ASO. All rights reserved.
//


struct LoginMember{
    var username : String
    var password : String
    var StyleSheet : String
    var SectionId: String
}

struct dentSearchParams {
    var patientzip: String
    var distance: String
    var specialty: String
    var state: String
    var dentName: String
}
