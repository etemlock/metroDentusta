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

struct countryInfo{
    var topoName : String
    var name : String
    var lat : Float
    var long : Float
    var geoId : Int32
    var countryCode : String
    var countryName: String
}
