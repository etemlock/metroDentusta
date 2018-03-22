//
//  models.swift
//  metroDentusa
//
//  Created by Eugene  Temlock on 12/31/17.
//  Copyright © 2017 ASO. All rights reserved.
//

struct member{
    private var Id: String
    private var username: String
    private var password: String
    private var sessionId: String
    
    init(id: String, usrname: String, pssword: String, ssId: String){
        Id = id
        username = usrname
        password = pssword
        sessionId = ssId
    }
    
    mutating func setSessionId(ssId: String){
        sessionId = ssId
    }
    
    mutating func setUsername(name: String){
        username = name
    }
    
    mutating func setPassword(pass: String){
        password = pass
    }
    
    func getId() -> String {
        return Id
    }
    
    func getSessionId() -> String {
        return sessionId
    }
    
    func getUsername() -> String {
        return username
    }
    
    func getPassword() -> String {
        return password
    }
}

struct dentSearchParams {
    var patientzip: String
    var distance: String
    var specialty: String
    var state: String
    var dentName: String
}

struct blogPostParams {
    var title : String
    var date: String
    var author: String
    var categories : [String]
    var description: String
    var blogLink: String
    var image: UIImage?
    
    
    mutating func clearParams(){
        self.title = ""
        self.date = ""
        self.author = ""
        self.categories = []
        self.description = ""
        self.blogLink = ""
        self.image = nil
    }
}

struct providerModel {
    var instName: String
    var provName: String
    var languages: String
    var address: String
    var city: String
    var stateZip: String
    var lat: Double
    var long: Double
    var distance: Double
    var telephone: String
    var hours: String
    var handicapAccess: String
    var webAddress: String
    var doctors : [(name: String, specialty: String, school: String, graduationDate: String)]
}

struct expProvider {
    static private var singleton = providerModel(instName: "", provName: "", languages: "", address: "", city: "", stateZip: "", lat: -1, long: -1, distance: -1, telephone: "", hours: "", handicapAccess: "", webAddress: "", doctors: [])
    
    static func getSingleton() -> providerModel {
        return singleton 
    }
    
    static func setSingleton(toSetModel: providerModel){
        singleton = toSetModel
    }
}


