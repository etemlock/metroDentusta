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
    private var memberId: String
    private var clientId: String
    private var sessionId: String
    
    init(id: String, usrname: String, pssword: String, memId: String, group: String, ssId: String){
        Id = id
        username = usrname
        password = pssword
        memberId = memId
        clientId = group
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
    
    mutating func setMemberId(memId: String){
        memberId = memId
    }
    
    mutating func setClientId(group: String){
        clientId = group
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
    
    func getMemberId() -> String {
        return memberId
    }
    
    func getClientId() -> String {
        return clientId
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

struct SaveUserParams {
    private var username : String
    private var nameCfrm : String
    private var passwd: String
    private var passCfrm: String
    private var mail: String
    private var mailCfrm: String
    private var secQ1: String
    private var ans1: String
    private var secQ2: String
    private var ans2: String
    private var userSessId: String
    private var userSUId: String
    
    init(){
        username = ""
        nameCfrm = ""
        passCfrm = ""
        passwd = ""
        mailCfrm = ""
        mail = ""
        secQ2 = ""
        secQ1 = ""
        ans2 = ""
        ans1 = ""
        userSUId = ""
        userSessId = ""
    }
    
    mutating func setName(name: String){
        username = name
    }
    
    mutating func setNameCfrm(name: String){
        nameCfrm = name
    }
    
    mutating func setPass(pass: String){
        passwd = pass
    }
    
    mutating func setPassCfrm(pass: String){
        passCfrm = pass
    }
    
    mutating func setMail(newMail: String){
        mail = newMail
    }
    
    mutating func setMailCfrm(newMail: String){
        mailCfrm = newMail
    }
    
    mutating func setSecurityQuestion1(question: String){
        secQ1 = question
    }
    
    mutating func setSecurityQuestion2(question: String){
        secQ2 = question
    }
    
    mutating func setAnswer1(answer: String) {
        ans1 = answer
    }
    
    mutating func setAnswer2(answer: String){
        ans2 = answer
    }
    
    mutating func setSessionID(sessId: String){
        userSessId = sessId
    }
    
    mutating func setSuID(suId: String){
        userSUId = suId
    }
    
    func getName(getConfirmField: Bool) -> String {
        if getConfirmField {
            return nameCfrm
        }
        return username
    }
    
    func getPass(getConfirmField: Bool) -> String {
        if getConfirmField {
            return passCfrm
        }
        return passwd
    }
    
    func getMail(getConfirmField: Bool) -> String {
        if getConfirmField {
            return mailCfrm
        }
        return mail
    }
    
    func getSecurityQuestion1() -> String {
        return secQ1
    }
    
    func getAnswer1() -> String {
        return ans1
    }
    
    func getSecurityQuestion2() -> String {
        return secQ2
    }
    
    func getAnswer2() -> String {
        return ans2
    }
    
    func getSessionID() -> String {
        return userSessId
    }
    
    func getSuID() -> String {
        return userSUId
    }
    
    mutating func clear() {
        username = ""
        nameCfrm = ""
        passCfrm = ""
        passwd = ""
        mailCfrm = ""
        mail = ""
        secQ2 = ""
        secQ1 = ""
        ans2 = ""
        ans1 = ""
        userSUId = ""
        userSessId = ""
    }
}

struct DocumentModel{
    var name: String
    var docURL: String
    
    mutating func clearParams(){
        self.name = ""
        self.docURL = ""
    }
    
}

struct providerModel {
    var instName: String
    //var provName: String
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
    static private var singleton = providerModel(instName: "",/* provName: "",*/ languages: "", address: "", city: "", stateZip: "", lat: -1, long: -1, distance: -1, telephone: "", hours: "", handicapAccess: "", webAddress: "", doctors: [])
    
    static func getSingleton() -> providerModel {
        return singleton 
    }
    
    static func setSingleton(toSetModel: providerModel){
        singleton = toSetModel
    }
}


